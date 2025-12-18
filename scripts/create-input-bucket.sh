#!/bin/bash
set -e

REGION="us-east-1"
INPUT_BUCKET="m346-fr-input-facerec-2025"

echo "Region:       $REGION"
echo "Input-Bucket: $INPUT_BUCKET"
echo "--------------------------------------"

echo "Erstelle INPUT-Bucket..."
aws s3 mb "s3://$INPUT_BUCKET" --region "$REGION"

echo
echo "Buckets mit 'm346' im Namen:"
aws s3 ls | grep m346 || true

echo
echo "Fertig: Input-Bucket-Script durchgelaufen."
