# M346 FaceRecognition Projekt

## Übersicht
Dieses Projekt erkennt bekannte Persönlichkeiten auf Fotos. Der Service verwendet zwei AWS S3 Buckets und eine AWS Lambda Funktion, die den Rekognition Celebrity Service aufruft. Sobald ein Bild in den Eingangs Bucket geladen wird, erstellt der Service eine JSON Datei mit den Analyseergebnissen im Ausgangs Bucket.

## Architektur
Der Service besteht aus:
- Eingangs Bucket für hochgeladene Bilder
- Lambda Funktion für die Erkennung
- AWS Rekognition Celebrity API
- Ausgangs Bucket für das Ergebnis als JSON


## Setup
Die Installation erfolgt über das Init Script im Ordner scripts. Das Script erstellt alle AWS Komponenten und bereitet die Umgebung vor.

## Verwendung
Es kann ein Testbild über das Script hochgeladen werden. Das Script lädt nach der Erkennung die JSON Datei herunter und zeigt die Resultate an.

## Team
Projektgruppe 2025 mit drei Mitgliedern.
Gabriel Sarkis,
Lionel Davatz,
Alessandro Renzetti.

## Dokumentation
Alle zusätzlichen Informationen befinden sich im Ordner docs. Dort sind Tests, Screenshots und die Reflexion abgelegt.
