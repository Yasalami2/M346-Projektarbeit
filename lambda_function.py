import os
import json
import logging
import boto3

# ==============================================================================
# Beschreibung: Dieses Skript implementiert die Lambda-Funktion für die Prominentenerkennung.
# Es nutzt Amazon Rekognition zur Analyse von Bildern, extrahiert Metadaten
# und speichert die Ergebnisse als JSON-Datei im definierten Output-Bucket.
# ==============================================================================

# --------------------------------------
# Initialisierung & AWS Clients
# --------------------------------------
logger = logging.getLogger()
logger.setLevel(logging.INFO)

rekognition = boto3.client('rekognition')
s3 = boto3.client('s3')

# --------------------------------------
# Lambda-Handler (Einstiegspunkt)
# --------------------------------------
def lambda_handler(event, context):
    try:
        # --------------------------------------
        # Extraktion der Eingabedaten
        # --------------------------------------
        bucket = event['Records'][0]['s3']['bucket']['name']
        key = event['Records'][0]['s3']['object']['key']
        logger.info(f"Verarbeite Datei: {key} aus Bucket: {bucket}")

        # --------------------------------------
        # Aufruf der Amazon Rekognition API
        # --------------------------------------
        response = rekognition.recognize_celebrities(
            Image={'S3Object': {'Bucket': bucket, 'Name': key}}
        )

        # --------------------------------------
        # Verarbeitung der Analyseergebnisse
        # --------------------------------------
        detected = []
        for person in response.get('CelebrityFaces', []):
            detected.append({
                "RecognizedName": person.get('Name'),
                "InternalID": person.get('Id'),
                "ConfidenceScore": person.get('MatchConfidence'),
                "InfoLinks": person.get('Urls')
            })

        # --------------------------------------
        # Erstellung des Ausgabe-Berichts
        # --------------------------------------
        output_report = {
            "AnalysisMetadata": {
                "SourceFile": key,
                "CelebrityCount": len(detected)
            },
            "CelebrityResults": detected
        }

        # --------------------------------------
        # Speichern im Output-Bucket
        # --------------------------------------
        target_bucket = os.environ.get('OUTPUT_BUCKET')
        target_key = f"result-{key}.json"

        s3.put_object(
            Bucket=target_bucket,
            Key=target_key,
            Body=json.dumps(output_report, indent=4),
            ContentType='application/json'
        )
        
        logger.info(f"Analyse erfolgreich in {target_bucket} gespeichert.")
        return {'statusCode': 200}

    except Exception as err:
        # --------------------------------------
        # Fehlerbehandlung
        # --------------------------------------
        logger.error(f"Fehler bei der Verarbeitung: {str(err)}")
        return {'statusCode': 500, 'body': str(err)}