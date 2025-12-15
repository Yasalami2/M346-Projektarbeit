using System;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.S3Events;
using Amazon.Rekognition;
using Amazon.S3;

// Lambda soll JSON mit SystemTextJson deserialisieren
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
            _rekognitionClient = new Amazon.Rekognition.AmazonRekognitionClient();
            _s3Client = new Amazon.S3.AmazonS3Client();

            _outputBucketName = Environment.GetEnvironmentVariable("OUTPUT_BUCKET")
                ?? throw new Exception("Environment variable OUTPUT_BUCKET is not set.");
        }

        public async Task FunctionHandler(S3Event evnt, ILambdaContext context)
        {
            context.Logger.LogLine($"OUTPUT_BUCKET (aus Env): {_outputBucketName}");

            foreach (var record in evnt.Records)
            {
                var s3 = record.S3;
                var inputBucket = s3.Bucket.Name;
                var key = s3.Object.Key;

                context.Logger.LogLine("Neues Objekt im Input-Bucket erkannt:");
                context.Logger.LogLine($"Input-Bucket: {inputBucket}");
                context.Logger.LogLine($"Key:          {key}");
            }

            await Task.CompletedTask;
        }
    }
}
