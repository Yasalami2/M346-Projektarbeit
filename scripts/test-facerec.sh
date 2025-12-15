set -e

REGION="us-east-1"
INPUT_BUCKET="m346-fr-input-facerec-2025"
OUTPUT_BUCKET="m346-fr-output-facerec-2025"

TEST_IMAGE="test-image.jpg"
OUTPUT_JSON="${TEST_IMAGE}.json"

echo "Region:        $REGION"
echo "Input-Bucket:  $INPUT_BUCKET"
echo "Output-Bucket: $OUTPUT_BUCKET"
echo "Testbild:      $TEST_IMAGE"
echo "--------------------------------------"

[ -f "$TEST_IMAGE" ] || { echo "FEHLER: $TEST_IMAGE fehlt im Projekt-Root."; exit 1; }

echo "Lade Testbild in den INPUT-Bucket hoch..."
aws s3 cp "$TEST_IMAGE" "s3://$INPUT_BUCKET/$TEST_IMAGE" --region "$REGION"

echo "Warte 20 Sekunden auf Lambda..."
sleep 20

echo "Pruefe Output-JSON..."
aws s3 ls "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" --region "$REGION" >/dev/null

echo "Lade Ergebnis-JSON herunter..."
aws s3 cp "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" "$OUTPUT_JSON" --region "$REGION"

echo
echo "Rohes Ergebnis-JSON:"
cat "$OUTPUT_JSON"
echo
echo "Fertig."
