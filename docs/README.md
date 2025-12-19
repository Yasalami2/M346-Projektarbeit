# Face Recognition Service – Modul 346

## 1. Einleitung
In diesem Projekt wird ein Face Recognition Service entwickelt, der bekannte Persönlichkeiten auf Fotodateien automatisch erkennt. 
Ziel ist es, den Service in der Cloud zu betreiben und die Ergebnisse als JSON-Dateien zu speichern. 
Die Projektarbeit dient dazu, die im Modul 346 erlernten Cloud-Fertigkeiten praktisch anzuwenden.

## 2. Projektübersicht
Der Face Recognition Service besteht aus zwei AWS S3 Buckets: einem Input-Bucket für die Bildverarbeitung und einem Output-Bucket für die Analyse-Ergebnisse. 
Eine AWS Lambda-Funktion erkennt bekannte Persönlichkeiten auf den Fotos und speichert die Resultate als JSON-Dateien. 
Der Verarbeitungsprozess wird durch einen manuellen Start ausgelöst und läuft anschliessend automatisiert ab.
Das Projekt wurde in einer Dreiergruppe durchgeführt. Alle Konfigurationsdateien und die Dokumentation sind im Git-Repository versioniert, sodass Änderungen nachvollziehbar sind.

## 3. Architektur und Aufbau

![Architekturdiagramm des Face Recognition Services](screenshots/Projekt-Architecture.png)

**Abbildung 1:** Das Architekturdiagramm zeigt den Ablauf des Face Recognition Services.  
Der Verarbeitungsprozess wird durch das manuelle Ausführen eines Skripts gestartet. 
Dabei wird ein Foto aus dem Repository in den AWS S3 Input-Bucket hochgeladen, analysiert und das Ergebnis als JSON-Datei im Output-Bucket gespeichert.

## 4. Voraussetzungen

Für die Verwendung des Face Recognition Services werden folgende Voraussetzungen benötigt:

- AWS Learner Lab Account
- GitHub Repository mit Zugriff für alle Projektmitglieder und die Lehrperson
- AWS CLI (lokal installiert)
- Internetverbindung
- Foto-Dateien von bekannten Persönlichkeiten für Testzwecke

## 5. Inbetriebnahme

Die Inbetriebnahme des Face Recognition Services erfolgt über das Initialisierungsskript `init.sh`, welches sich im Ordner `/docs/scripts/` befindet. 
Durch das Ausführen dieses Skripts werden alle benötigten AWS-Komponenten im AWS Learner Lab erstellt und korrekt konfiguriert.

## 6. Verwendung des Services

Die zu analysierenden Foto-Dateien befinden sich in einem definierten Ordner im Git-Repository. 
In diesem Ordner können sich mehrere Bilder bekannter Persönlichkeiten befinden.

Durch das manuelle Ausführen des Initialisierungsskripts wird eines dieser Fotos ausgewählt,
in den AWS S3 Input-Bucket hochgeladen und anschliessend der Verarbeitungsprozess gestartet.

Der Ablauf ist wie folgt:

1. Mehrere Foto-Dateien bekannter Persönlichkeiten befinden sich im vorgesehenen Ordner im Repository.
2. Der Benutzer führt das Initialisierungsskript aus.
3. Eines der vorhandenen Fotos wird in den AWS S3 Input-Bucket hochgeladen.
4. Das Foto wird mit Hilfe von AWS Rekognition analysiert.
5. Das Analyseergebnis wird als JSON-Datei im Output-Bucket gespeichert.

## 7. Tests und Testprotokolle

Zur Überprüfung der Funktionalität des Face Recognition Services wurden mehrere Tests durchgeführt. 
Ziel der Tests war es zu prüfen, ob ein Foto korrekt analysiert wird und das Analyseergebnis als JSON-Datei im Output-Bucket gespeichert wird.

### Testfall 1: Erkennung einer bekannten Persönlichkeit (Jeff Bezos)

| Kriterium              | Beschreibung |
|------------------------|--------------|
| Datum & Uhrzeit:       | 19.12.2025 23:00 Uhr |
| Testperson             | Gabriel Sarkis |
| Ausgangslage           | Mehrere Fotos befinden sich im vorgesehenen Ordner im Repository |
| In diesem Abschnitt zeigen wir, dass unsere Gesichtserkennung in der AWS Cloud funktioniert.|
--- 

## 1. Was haben wir getestet?

| ID. | Testfall | Ziel | Status |
|:--- |:--- |:--- |:--- |
| T1 | Promi erkennen | Erkennt das System Jeff Bezos? | ✅ OK |
| T2 | Normale Person | Erkennt das System, dass kein Promi da ist? | ✅ OK |
| T3 | Automatik | Läuft das ganze Script von alleine durch? | ✅ OK |

---

### Testfall T1: Der Promi-Test (Jeff Bezos)
Wir haben ein Bild von Jeff Bezos hochgeladen, um zu sehen, ob der AWS-Dienst ihn findet.
* **Was ist passiert:** Das Script hat die Infrastruktur geprüft und das Bild automatisch hochgeladen.
* **Ergebnis:** Jeff Bezos wurde sofort erkannt (Wahrscheinlichkeit: 99.99%).
* **Beweis (Screenshot):**
![Screenshot Terminal Jeff Bezos](./screenshots/PromiTest.png)
* **Fazit:** Der Test war erfolgreich. Die Verbindung zwischen Script, Lambda und Rekognition klappt einwandfrei.
* **Massnahmen/Empfehlungen:** Keine technischen Korrekturen nötig. Empfehlung: Bilder mit hoher Auflösung verwenden, um die Confidence-Rate hoch zu halten.

---
### Testfall T2: Der "keinPromi"-Test (NoPromi.jpeg)
Wir haben ein Bild ohne bekannte Persönlichkeit getestet, um Fehlalarme zu vermeiden.
* **Ergebnis:** Das System zeigt korrekt "CelebrityResults": [] an, was bedeuted dass es "leer" ist und daher nichts gefunden hat.
* **Beweis (Screenshot):**
![Screenshot Terminal noPromi](./screenshots/Test.png)
* **Fazit:** Das System erkennt den Unterschied zwischen Prominenten und normalen Personen korrekt.
* **Massnahmen/Empfehlungen:** Es sollte darauf geachtet werden, dass das Gesicht frontal und ohne starke Schatten fotografiert wird, damit die AWS-Rekognition die Merkmale optimal mit der Promi-Datenbank abgleichen kann.

---

**Gesamtfazit:**  
Alle durchgeführten Tests verliefen erfolgreich. Der Face Recognition Service erkennt bekannte Persönlichkeiten zuverlässig 
und liefert auch bei Bildern ohne Prominente korrekte Analyseergebnisse.

## 8. Reflexion

### Lionel Davatz
Während des M346 FaceRecognition Projekts habe ich gelernt, wie verschiedene AWS Services zusammenarbeiten. 
Besonders spannend war für mich zu sehen, wie mit S3 Buckets, einer Lambda Funktion und AWS Rekognition ein automatisierter Ablauf umgesetzt werden kann, der Bilder analysiert und Ergebnisse speichert.

Am Anfang hatte ich Mühe, den Aufbau und die verwendeten Skripte zu verstehen. Mit der Zeit und durch das praktische Arbeiten wurde der Ablauf jedoch klarer, sodass ich den Service gezielt testen und nachvollziehen konnte.

Die Zusammenarbeit im Team funktionierte gut. Probleme konnten gemeinsam besprochen und Lösungen zusammen gefunden werden, was den Arbeitsprozess erleichtert hat.

Als Verbesserung für ein nächstes Projekt würde ich mir eine bessere Einführung in die Skripte wünschen, damit der Einstieg einfacher fällt. Insgesamt war das Projekt lehrreich und hat mir einen guten Einblick in die praktische Nutzung von Cloud-Technologien gegeben.

---

### Gabriel Sarkis
In diesem Projekt habe ich gelernt, wie man mit AWS arbeitet und wie die Services S3 und Lambda zusammen funktionieren. Besonders hilfreich war zu sehen, wie ein automatischer Ablauf aufgebaut ist, bei dem ein Upload in ein Bucket eine Funktion auslöst und danach ein Resultat gespeichert wird. Dadurch habe ich besser verstanden, wie Cloud-Lösungen in der Praxis eingesetzt werden.

Positiv war auch die Zusammenarbeit im Team. Wir konnten uns gegenseitig helfen, Probleme besprechen und Lösungen gemeinsam suchen. Wenn jemand nicht weiterkam, haben wir versucht, das Problem zusammen zu analysieren. Das hat den Lernprozess verbessert.

Verbesserungen sehe ich vor allem in der Planung. Die Einschränkungen im AWS Academy Lab, vor allem bei den Berechtigungen, haben uns mehr Zeit gekostet als erwartet. Für ein nächstes Projekt würde ich diese Punkte früher abklären, damit man realistischer planen kann.
Insgesamt war das Projekt lehrreich, weil ich nicht nur technische Grundlagen gelernt habe, sondern auch gemerkt habe, wie wichtig gute Planung und Kommunikation im Team sind.

---

### Alessandro Renzetti
Das M346 FaceRecognition Projekt im AWS Learner Lab hat mir insgesamt sehr gut gefallen. Besonders spannend war für mich, dass wir am Ende eine funktionierende Lösung umgesetzt haben, die bekannte Persönlichkeiten auf Bildern erkennen kann. Durch die Kombination von S3 Buckets, einer Lambda Funktion und dem AWS Rekognition Celebrity Service habe ich besser verstanden, wie verschiedene AWS Services zusammenarbeiten und einen automatisierten Ablauf ermöglichen.

Am Anfang fand ich die Arbeit mit den Skripten eher kompliziert und teilweise schwer zu verstehen. Es war nicht immer sofort klar, was jedes Script genau macht und wie die einzelnen Schritte zusammenhängen. Mit der Zeit und durch das praktische Arbeiten wurde der Aufbau jedoch immer verständlicher. Gegen Ende des Projekts konnte ich den Ablauf gut nachvollziehen und die Skripte gezielt einsetzen.

Positiv empfand ich den automatischen Ablauf des Systems. Sobald ein Bild im Eingangs Bucket hochgeladen wird, verarbeitet die Lambda Funktion das Bild und speichert das Ergebnis als JSON Datei im Ausgangs Bucket. Dadurch habe ich besser verstanden, wie solche Prozesse ohne manuelle Eingriffe umgesetzt werden und wie Cloud Services im Hintergrund zusammenspielen.

Als Verbesserung für ein nächstes Projekt würde ich mir eine klarere Einführung zu den einzelnen Skripten wünschen. Kurze Erklärungen zu Zweck und Ablauf der Skripte würden den Einstieg erleichtern, besonders zu Beginn des Projekts.

Insgesamt war das Projekt sehr lehrreich und praxisnah. Ich konnte mein Wissen zu AWS, insbesondere zu S3, Lambda und Rekognition, deutlich erweitern. Das Projekt hat mein Interesse an Cloud Technologien weiter gestärkt und mir gezeigt, wie solche Services in der Praxis sinnvoll eingesetzt werden können.

## 9. Quellen
- AWS Rekognition – Recognizing Celebrities  
  https://docs.aws.amazon.com/rekognition/latest/dg/celebrities.html

- AWS Lambda – Developer Guide  
  https://docs.aws.amazon.com/lambda/latest/dg/welcome.html

- Amazon S3 – User Guide  
  https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html

- AWS CLI – User Guide  
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

- Moodle GBS St. Gallen – Modul 346 Unterlagen  
  https://moodle.gbssg.ch/

- KI-Unterstützung zur Strukturierung und Fehlerbehebung

