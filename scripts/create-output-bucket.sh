#!/bin/bash
# ==============================================================================
# Beschreibung: Dieses Skript erstellt den Output-Bucket für die Gesichtserkennung.
# Es setzt die Region auf 'eu-central-1', definiert den Namen des Ziel-Buckets
# und erstellt diesen in AWS S3, gefolgt von einer Überprüfung der existierenden Buckets.
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