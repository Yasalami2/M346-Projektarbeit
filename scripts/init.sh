#!/bin/bash
# ==============================================================================
# PROJEKT:      M346 - Face Recognition Service
# DATEI:        init.sh
# AUTOR:        Gabriel Sarkis & Alessandro Renzetti & Lionel Davatz
# DATUM:        11.12.2025
# QUELLEN:      
#   - AWS Rekognition Docs: https://docs.aws.amazon.com/rekognition/latest/dg/celebrities.html
#   - Moodle GBS St. Gallen: https://moodle.gbssg.ch/course/view.php?id=188
#   - KI-Unterstützung: Gemini AI (Strukturierung & Fehlerbehebung)
# ------------------------------------------------------------------------------
# Beschreibung: Dieses Skript richtet den Face Recognition Service ein.
# Es erstellt die nötigen Buckets, lädt die Lambda-Funktion hoch,
# setzt den Trigger und testet den Ablauf.
# ==============================================================================
set -e

# --------------------------------------
# Konfiguration
# --------------------------------------
REGION="us-east-1"
TIMESTAMP=$(date +%s)
INPUT_BUCKET="m346-in-$TIMESTAMP"
OUTPUT_BUCKET="m346-out-$TIMESTAMP"
LAMBDA_FN="CelebrityRecognitionService"
ZIP_FILE="deployment_package.zip"

echo "Starte FaceRecognition Init + Test"
echo "Region:         $REGION"
echo "In-Bucket:      $INPUT_BUCKET"
echo "Out-Bucket:     $OUTPUT_BUCKET"
echo "--------------------------------------"

# --------------------------------------
# Pfad-Ermittlung 
# --------------------------------------
BASE_DIR=$(dirname "$(cd "$(dirname "$0")" && pwd)")
echo "Projekt-Verzeichnis: $BASE_DIR"

# --------------------------------------
# AWS Authentifizierung prüfen
# --------------------------------------
aws sts get-caller-identity > /dev/null
echo "AWS Login OK"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# --------------------------------------
# S3 Buckets erstellen
# --------------------------------------
echo "Erstelle S3 Buckets..."
aws s3 mb "s3://$INPUT_BUCKET" --region "$REGION" > /dev/null
aws s3 mb "s3://$OUTPUT_BUCKET" --region "$REGION" > /dev/null
echo "Buckets bereit."

# --------------------------------------
# ZIP-Datei für Lambda erstellen
# --------------------------------------
echo "Suche Quellcode und erstelle ZIP..."
PY_FILE=$(find "$BASE_DIR" -name "lambda_function.py" | head -n 1)

if [ -z "$PY_FILE" ]; then
    echo "FEHLER: lambda_function.py nicht gefunden!"
    exit 1
fi

zip -j "$ZIP_FILE" "$PY_FILE" > /dev/null
echo "ZIP erstellt: $ZIP_FILE"

# --------------------------------------
# Lambda-Funktion erstellen oder aktualisieren
# --------------------------------------
if aws lambda get-function --function-name "$LAMBDA_FN" > /dev/null 2>&1; then
    echo "Aktualisiere bestehende Lambda-Funktion..."
    aws lambda update-function-code \
        --function-name "$LAMBDA_FN" \
        --zip-file fileb://"$ZIP_FILE" \
        --region "$REGION" > /dev/null
    sleep 3
    aws lambda update-function-configuration \
        --function-name "$LAMBDA_FN" \
        --environment "Variables={OUTPUT_BUCKET=$OUTPUT_BUCKET}" \
        --region "$REGION" > /dev/null
else
    echo "Erstelle neue Lambda-Funktion..."
    aws lambda create-function \
        --function-name "$LAMBDA_FN" \
        --runtime python3.12 \
        --role "arn:aws:iam::$ACCOUNT_ID:role/LabRole" \
        --handler lambda_function.lambda_handler \
        --zip-file fileb://"$ZIP_FILE" \
        --environment "Variables={OUTPUT_BUCKET=$OUTPUT_BUCKET}" \
        --timeout 20 \
        --region "$REGION" > /dev/null
fi

# --------------------------------------
# Lambda-Berechtigungen & S3-Trigger
# --------------------------------------
aws lambda add-permission \
    --function-name "$LAMBDA_FN" \
    --statement-id "s3access-$TIMESTAMP" \
    --action "lambda:InvokeFunction" \
    --principal s3.amazonaws.com \
    --source-arn "arn:aws:s3:::$INPUT_BUCKET" \
    --region "$REGION" > /dev/null || true

aws s3api put-bucket-notification-configuration \
    --bucket "$INPUT_BUCKET" \
    --notification-configuration "{
        \"LambdaFunctionConfigurations\": [
            {
                \"LambdaFunctionArn\": \"arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$LAMBDA_FN\",
                \"Events\": [\"s3:ObjectCreated:*\"]
            }
        ]
    }" \
    --region "$REGION"

# --------------------------------------
# Testlauf 
# --------------------------------------
echo "--- Suche Testbild für Validierung ---"
TEST_IMAGE=$(find "$BASE_DIR" -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" | head -n 1)

if [ -n "$TEST_IMAGE" ]; then
    FILE_NAME=$(basename "$TEST_IMAGE")
    echo "Lade Testbild hoch: $FILE_NAME"
    aws s3 cp "$TEST_IMAGE" "s3://$INPUT_BUCKET/" > /dev/null
    
    echo "Warte auf Verarbeitung (20 Sekunden)..."
    sleep 20
    
    RESULT_KEY="result-$FILE_NAME.json"
    if aws s3 cp "s3://$OUTPUT_BUCKET/$RESULT_KEY" ./final_test.json --region "$REGION" > /dev/null 2>&1; then
        echo -e "\n--- ERGEBNIS DER GESICHTSERKENNUNG (JSON) ---"
        cat final_test.json
        echo -e "\n--------------------------------------"
    else
        echo "Fehler: Ergebnis-JSON wurde nicht im Out-Bucket erstellt."
    fi
else
    echo "Kein Testbild gefunden."
fi

# --------------------------------------
# Automatisierte Tests
# --------------------------------------
echo "--- Starte Tests ---"

# Testfall 1: Bekannte Persönlichkeit (Positiv-Test)
echo "[Test 1] Prüfe Promi-Erkennung (Promi.jpg)..."
if [ -f "$BASE_DIR/images/Promi.jpg" ]; then
    aws s3 cp "$BASE_DIR/images/Promi.jpg" "s3://$INPUT_BUCKET/Promi.jpg" > /dev/null
    echo "Warte 20s auf Verarbeitung..."
    sleep 20

    if aws s3 cp "s3://$OUTPUT_BUCKET/result-Promi.jpg.json" ./test_success.json > /dev/null 2>&1; then
        echo "Ergebnis Test 1 (Gefunden):"
        grep -E "RecognizedName|ConfidenceScore" test_success.json | tr -d '", '
    else
        echo "FEHLER: Datei 'result-Promi.jpg.json' nicht im Out-Bucket gefunden."
    fi
else
    echo "FEHLER: 'images/Promi.jpg' fehlt!"
fi

# Testfall 2: Unbekannte Person (Negativ-Test)
echo -e "\n[Test 2] Prüfe unbekannte Person (noPromi.jpeg)..."
if [ -f "$BASE_DIR/images/noPromi.jpeg" ]; then
    aws s3 cp "$BASE_DIR/images/noPromi.jpeg" "s3://$INPUT_BUCKET/noPromi.jpeg" > /dev/null
    sleep 20
    
    if aws s3 cp "s3://$OUTPUT_BUCKET/result-noPromi.jpeg.json" ./test_no_celeb.json > /dev/null 2>&1; then
        echo "Ergebnis Test 2: (Sollte leeres CelebrityResults Array sein)"
        cat test_no_celeb.json | grep "CelebrityResults" -A 2
    fi
else
    echo "FEHLER: 'images/noPromi.jpeg' fehlt!"
fi

echo "--------------------------------------"
echo "Test abgeschlossen."