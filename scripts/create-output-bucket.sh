#!/bin/bash
# ==============================================================================
# PROJEKT:      M346 - Face Recognition Service
# DATEI:        create-output-bucket.sh
# AUTOR:        Alessandro Renzetti
# DATUM:        11.12.2025
# QUELLEN:      
#   - AWS Rekognition Docs: https://docs.aws.amazon.com/rekognition/latest/dg/celebrities.html
#   - Moodle GBS St. Gallen: https://moodle.gbssg.ch/course/view.php?id=188
#   - KI-Unterstützung: Gemini AI (Strukturierung & Fehlerbehebung)
# ------------------------------------------------------------------------------
# Beschreibung: Richtet den S3-Output-Bucket für die Gesichtserkennung ein.
# ==============================================================================
set -e

# --------------------------------------
# Konfiguration
# --------------------------------------
REGION="eu-central-1"

OUTPUT_BUCKET="m346-fr-output-facerec-2025"

# --------------------------------------
# Ausgabe der Konfigurationsparameter
# --------------------------------------
echo "Region:        $REGION"
echo "Output-Bucket: $OUTPUT_BUCKET"
echo "--------------------------------------"

# --------------------------------------
# S3 Output-Bucket erstellen
# --------------------------------------
echo "Erstelle OUTPUT-Bucket..."
aws s3 mb "s3://$OUTPUT_BUCKET" --region "$REGION"

# --------------------------------------
# Überprüfung: Auflisten relevanter Buckets
# --------------------------------------
echo
echo "Buckets mit 'm346' im Namen:"
aws s3 ls | grep m346 || true

# --------------------------------------
# Abschlussmeldung
# --------------------------------------
echo
echo "Fertig: Output-Bucket-Script durchgelaufen."