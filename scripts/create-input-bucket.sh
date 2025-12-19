#!/bin/bash
# ==============================================================================
# PROJEKT:      M346 - Face Recognition Service
# DATEI:        create-input-bucket.sh
# AUTOR:        Alessandro Renzetti
# DATUM:        11.12.2025
# QUELLEN:      
#   - AWS Rekognition Docs: https://docs.aws.amazon.com/rekognition/latest/dg/celebrities.html
#   - Moodle GBS St. Gallen: https://moodle.gbssg.ch/course/view.php?id=188
#   - KI-Unterstützung: Gemini AI (Strukturierung & Fehlerbehebung)
# ------------------------------------------------------------------------------
# Beschreibung: Dieses Skript richtet den Input-Bucket für die Gesichtserkennung ein.
# Es definiert die Region und den Bucket-Namen, erstellt den Bucket in AWS S3
# und listet anschliessend alle Buckets auf, die 'm346' im Namen enthalten.
# ==============================================================================
set -e

# --------------------------------------
# Konfiguration
# --------------------------------------
REGION="us-east-1"
INPUT_BUCKET="m346-fr-input-facerec-2025"

# --------------------------------------
# Ausgabe der Konfigurationsparameter
# --------------------------------------
echo "Region:       $REGION"
echo "Input-Bucket: $INPUT_BUCKET"
echo "--------------------------------------"

# --------------------------------------
# S3 Input-Bucket erstellen
# --------------------------------------
echo "Erstelle INPUT-Bucket..."
aws s3 mb "s3://$INPUT_BUCKET" --region "$REGION"

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
echo "Fertig: Input-Bucket-Script durchgelaufen."