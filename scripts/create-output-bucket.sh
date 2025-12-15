set -e

REGION="us-east-1"

OUTPUT_BUCKET="m346-fr-output-facerec-2025"
 
echo "Region:        $REGION"
echo "Output-Bucket: $OUTPUT_BUCKET"
echo "--------------------------------------"
 
echo "Erstelle OUTPUT-Bucket..."
aws s3 mb "s3://$OUTPUT_BUCKET" --region "$REGION"
 
echo
echo "Buckets mit 'm346' im Namen:"
aws s3 ls | grep m346 || true
 
echo
echo "Fertig: Output-Bucket-Script durchgelaufen."