using System;
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
        private readonly IAmazonRekognition _rekognitionClient;
        private readonly IAmazonS3 _s3Client;

        private readonly string _outputBucketName;

        public FaceRecognitionFunction()
        {
            _rekognitionClient = new AmazonRekognitionClient();
            _s3Client = new AmazonS3Client();

            _outputBucketName = Environment.GetEnvironmentVariable("OUTPUT_BUCKET")
                ?? throw new Exception("Environment variable OUTPUT_BUCKET is not set.");
        }

        public async Task FunctionHandler(S3Event evnt, ILambdaContext context)
        {
            context.Logger.LogLine($"OUTPUT_BUCKET (Env): {_outputBucketName}");

            foreach (var record in evnt.Records)
            {
                var s3 = record.S3;
                var inputBucket = s3.Bucket.Name;
                var key = s3.Object.Key;

                context.Logger.LogLine("Neues Objekt im Input-Bucket erkannt:");
                context.Logger.LogLine($"Input-Bucket: {inputBucket}");
                context.Logger.LogLine($"Key:          {key}");

                var request = new RecognizeCelebritiesRequest
                {
                    Image = new Image
                    {
                        S3Object = new Amazon.Rekognition.Model.S3Object
                        {
                            Bucket = inputBucket,
                            Name = key
                        }
                    }
                };

                var response = await _rekognitionClient.RecognizeCelebritiesAsync(request);

                var result = new
                {
                    InputBucket = inputBucket,
                    InputKey = key,
                    Celebrities = response.CelebrityFaces,   
                    UnrecognizedFaces = response.UnrecognizedFaces.Count,
                    Timestamp = DateTime.UtcNow
                };

                var json = JsonSerializer.Serialize(
                    result,
                    new JsonSerializerOptions { WriteIndented = true }
                );

                var outputKey = key + ".json";

                context.Logger.LogLine($"Schreibe Ergebnis nach Output-Bucket:");
                context.Logger.LogLine($"Output-Bucket:  {_outputBucketName}");
                context.Logger.LogLine($"Output-Key:     {outputKey}");

                var putRequest = new PutObjectRequest
                {
                    BucketName = _outputBucketName,
                    Key = outputKey,
                    ContentBody = json
                };

                await _s3Client.PutObjectAsync(putRequest);

                context.Logger.LogLine("Ergebnis-JSON erfolgreich geschrieben.");
            }
        }
    }
}
