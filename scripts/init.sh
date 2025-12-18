#!/bin/bash
set -e

REGION="us-east-1"
TIMESTAMP=$(date +%s)
INPUT_BUCKET="m346-in-$TIMESTAMP"
OUTPUT_BUCKET="m346-out-$TIMESTAMP"
LAMBDA_FN="CelebrityRecognitionService"
ZIP_FILE="deployment_package.zip"

echo "--- 1. AWS Verbindung prüfen ---"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Account: $ACCOUNT_ID"

echo "Erstelle S3 Buckets..."
aws s3 mb "s3://$INPUT_BUCKET" --region "$REGION"
aws s3 mb "s3://$OUTPUT_BUCKET" --region "$REGION"

echo "Suche Quellcode..."
PY_FILE=$(find . -name "lambda_function.py" | head -n 1)
zip -j "$ZIP_FILE" "$PY_FILE"

if aws lambda get-function --function-name "$LAMBDA_FN" > /dev/null 2>&1; then
    echo "Update bestehende Funktion..."
    aws lambda update-function-code --function-name "$LAMBDA_FN" --zip-file "fileb://$ZIP_FILE" --region "$REGION" > /dev/null
    sleep 3
    aws lambda update-function-configuration --function-name "$LAMBDA_FN" --environment "Variables={OUTPUT_BUCKET=$OUTPUT_BUCKET}" --region "$REGION" > /dev/null
else
    echo "Erstelle neue Funktion..."
    aws lambda create-function \
        --function-name "$LAMBDA_FN" \
        --runtime python3.12 \
        --role "arn:aws:iam::$ACCOUNT_ID:role/LabRole" \
        --handler lambda_function.lambda_handler \
        --zip-file "fileb://$ZIP_FILE" \
        --environment "Variables={OUTPUT_BUCKET=$OUTPUT_BUCKET}" \
        --timeout 30 --region "$REGION" > /dev/null
fi

aws lambda add-permission --function-name "$LAMBDA_FN" --statement-id "s3-access-$TIMESTAMP" --action "lambda:InvokeFunction" --principal s3.amazonaws.com --source-arn "arn:aws:s3:::$INPUT_BUCKET" > /dev/null || true

aws s3api put-bucket-notification-configuration --bucket "$INPUT_BUCKET" --notification-configuration "{\"LambdaFunctionConfigurations\":[{\"LambdaFunctionArn\":\"arn:aws:lambda:$REGION:$ACCOUNT_ID:function:$LAMBDA_FN\",\"Events\":[\"s3:ObjectCreated:*\"]}]}"

echo "--- Suche Testbild ---"
TEST_IMAGE=$(find . -name "*.jpg" -o -name "*.png" | head -n 1)

if [ -n "$TEST_IMAGE" ]; then
    FILE_NAME=$(basename "$TEST_IMAGE")
    echo "Lade hoch: $FILE_NAME"
    aws s3 cp "$TEST_IMAGE" "s3://$INPUT_BUCKET/" > /dev/null
    
    echo "Warte auf Cloud-Verarbeitung..."
    sleep 20
    
    RESULT_KEY="result-$FILE_NAME.json"
    if aws s3 cp "s3://$OUTPUT_BUCKET/$RESULT_KEY" ./final_test_result.json --region "$REGION" > /dev/null 2>&1; then
        echo -e "\n--- ERGEBNIS DER GESICHTSERKENNUNG ---"
        cat final_test_result.json
        echo -e "\n--------------------------------------"
        echo "Test erfolgreich protokolliert." [cite: 31]
    else
        echo "Fehler: Kein Resultat gefunden. Prüfe die Lambda-Logs!"
    fi
else
    echo "Kein Bild für Test gefunden."
fi