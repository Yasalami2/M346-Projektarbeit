set -e


REGION="eu-central-1"
INPUT_BUCKET="m346-fr-input-facerec-2025"
OUTPUT_BUCKET="m346-fr-output-facerec-2025"

TEST_IMAGE="test-image.jpg"  
OUTPUT_JSON="${TEST_IMAGE}.json"


echo "Region:        $REGION"
echo "Input-Bucket:  $INPUT_BUCKET"
echo "Output-Bucket: $OUTPUT_BUCKET"
echo "Testbild:      $TEST_IMAGE"
echo "--------------------------------------"

if [ ! -f "$TEST_IMAGE" ]; then
  echo "FEHLER: Testbild '$TEST_IMAGE' existiert nicht im aktuellen Ordner."
  echo "Bitte eine bekannte Person als '$TEST_IMAGE' in diesen Ordner legen."
  exit 1
fi

echo "Lade Testbild in den INPUT-Bucket hoch..."
aws s3 cp "$TEST_IMAGE" "s3://$INPUT_BUCKET/$TEST_IMAGE" --region "$REGION"

echo "Warte kurz, bis Lambda die Erkennung gemacht hat..."
sleep 20  

echo "Pruefe, ob Output-JSON vorhanden ist..."
aws s3 ls "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" --region "$REGION" || {
  echo "FEHLER: Keine Ergebnis-Datei '$OUTPUT_JSON' im Output-Bucket gefunden."
  exit 1
}

echo "Lade Ergebnis-JSON herunter..."
aws s3 cp "s3://$OUTPUT_BUCKET/$OUTPUT_JSON" "$OUTPUT_JSON" --region "$REGION"

echo
echo "Rohes Ergebnis-JSON:"
cat "$OUTPUT_JSON"
echo
echo "--------------------------------------"
echo "HINWEIS: Auswertung (Name + Wahrscheinlichkeit) koennt ihr in der Dokumentation erklaeren."
