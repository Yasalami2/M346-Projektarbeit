using System;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.S3Events;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]
 
namespace FaceRecognitionLambda
{
    public class FaceRecognitionFunction
    {
        public async Task FunctionHandler(S3Event evnt, ILambdaContext context)
        {
            foreach (var record in evnt.Records)
            {
                var s3 = record.S3;
                var inputBucket = s3.Bucket.Name;
                var key = s3.Object.Key;

                context.Logger.LogLine("Neues Objekt im Input-Bucket erkannt:");
                context.Logger.LogLine($"Bucket: {inputBucket}");
                context.Logger.LogLine($"Key:    {key}");
            }
 
            await Task.CompletedTask;
        }
    }
}
