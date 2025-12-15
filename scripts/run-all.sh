set -e

REGION="us-east-1"
INPUT_BUCKET="m346-fr-input-facerec-2025"
OUTPUT_BUCKET="m346-fr-output-facerec-2025"

TEST_IMAGE="test-image.jpg"
OUTPUT_JSON="${TEST_IMAGE}.json"

echo "Starte FaceRecognition Init + Test"
echo "Region:        $REGION"
echo "Input-Bucket:  $INPUT_BUCKET"
echo "Output-Bucket: $OUTPUT_BUCKET"
echo "--------------------------------------"

aws sts get-caller-identity > /dev/null
echo "AWS Login OK"

echo "Pruefe / erstelle Input-Bucket..."
aws s3 ls "s3://$INPUT_BUCKET" > /dev/null 2>&1 || \
aws s3 mb "s3://$INPUT_BUCKET" --region "$REGION"

echo "Pruefe / erstelle Output-Bucket..."
aws s3 ls "s3://$OUTPUT_BUCKET" > /dev/null 2>&1 || \
aws s3 mb "s3://$OUTPUT_BUCKET" --region "$REGION"

echo "Buckets bereit."
echo "--------------------------------------"

if [ ! -f "$TEST_IMAGE" ]; then
  echo "FEHLER: Testbild '$TEST_IMAGE' fehlt im Projektordner."
  exit 1
fi

echo "Lade Testbild in Input-Bucket hoch..."
aws s3 cp "$TEST_IMAGE" "s3://$INPUT_BUCKET/$TEST_IMAGE" --region "$REGION"

echo "Warte auf Verarbeitung (20 Sekunden)..."
sleep 20

echo "Pruefe Output-JSON..."
aws s3 ls "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" --region "$REGION"

echo "Lade Ergebnis-JSON herunter..."
aws s3 cp "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" "$OUTPUT_JSON" --region "$REGION"

echo
echo "Ergebnis:"
cat "$OUTPUT_JSON"
echo
echo "--------------------------------------"
echo "Test abgeschlossen."
