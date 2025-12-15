set -euo pipefail

export REGION="${REGION:-us-east-1}"
export INPUT_BUCKET="${INPUT_BUCKET:-m346-fr-input-facerec-2025}"
export OUTPUT_BUCKET="${OUTPUT_BUCKET:-m346-fr-output-facerec-2025}"

echo "Init FaceRecognition | REGION=$REGION"
bash ./scripts/create-input-bucket.sh
bash ./scripts/create-output-bucket.sh

echo
echo "Buckets bereit:"
echo "  Input : s3://$INPUT_BUCKET"
echo "  Output: s3://$OUTPUT_BUCKET"
