using System;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.S3Events;
using Amazon.Rekognition;
using Amazon.Rekognition.Model;
using Amazon.S3;
using Amazon.S3.Model;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace FaceRecognitionLambda
{
    public class FaceRecognitionFunction
    {
        private static readonly JsonSerializerOptions JsonOpts = new() { WriteIndented = true };

        private readonly IAmazonRekognition _rekognition;
        private readonly IAmazonS3 _s3;
        private readonly string _outputBucket;
        private readonly string _outputPrefix;

        public FaceRecognitionFunction()
        {
            _rekognition = new AmazonRekognitionClient();
            _s3          = new AmazonS3Client();

            _outputBucket = Environment.GetEnvironmentVariable("OUTPUT_BUCKET")
                            ?? throw new Exception("Environment variable OUTPUT_BUCKET is not set.");

            _outputPrefix = Environment.GetEnvironmentVariable("OUTPUT_PREFIX") ?? string.Empty;
        }

        public async Task FunctionHandler(S3Event evnt, ILambdaContext context)
        {
            try
            {
                context.Logger.LogLine($"OUTPUT_BUCKET:  {_outputBucket}");
                context.Logger.LogLine($"OUTPUT_PREFIX:  {_outputPrefix}");

                foreach (var record in evnt.Records)
                {
                    var inputBucket = record.S3.Bucket.Name;
                    var rawKey      = record.S3.Object.Key;

                    var inputKey = Uri.UnescapeDataString(rawKey).Replace('+', ' ');

                    context.Logger.LogLine("Neues Objekt erkannt:");
                    context.Logger.LogLine($"  Bucket: {inputBucket}");
                    context.Logger.LogLine($"  Key   : {inputKey}");

                    var recReq = new RecognizeCelebritiesRequest
                    {
                        Image = new Image
                        {
                            S3Object = new Amazon.Rekognition.Model.S3Object
                            {
                                Bucket = inputBucket,
                                Name   = inputKey
                            }
                        }
                    };

                    var recRes = await _rekognition.RecognizeCelebritiesAsync(recReq);

                    var payload = new
                    {
                        Source = new { Bucket = inputBucket, Key = inputKey },
                        Count  = recRes.CelebrityFaces?.Count ?? 0,
                        Celebrities = recRes.CelebrityFaces?.Select(c => new
                        {
                            c.Id,
                            c.Name,
                            c.MatchConfidence,
                            BoundingBox = c.Face?.BoundingBox,
                            Urls        = c.Urls
                        }),
                        UnrecognizedFaces = recRes.UnrecognizedFaces?.Count ?? 0,
                        TimestampUtc = DateTime.UtcNow
                    };

                    var json = JsonSerializer.Serialize(payload, JsonOpts);

                    var prefix  = string.IsNullOrWhiteSpace(_outputPrefix)
                                    ? string.Empty
                                    : (_outputPrefix.EndsWith("/") ? _outputPrefix : _outputPrefix + "/");
                    var outKey  = prefix + Path.GetFileName(inputKey) + ".json";

                    var putReq = new PutObjectRequest
                    {
                        BucketName  = _outputBucket,
                        Key         = outKey,
                        ContentBody = json,
                        ContentType = "application/json"
                    };

                    await _s3.PutObjectAsync(putReq);

                    context.Logger.LogLine($"OK: Ergebnis geschrieben nach s3://{_outputBucket}/{outKey}");
                }
            }
            catch (Exception ex)
            {
                context.Logger.LogLine("ERROR: " + ex);
                throw; 
            }
        }
    }
}
