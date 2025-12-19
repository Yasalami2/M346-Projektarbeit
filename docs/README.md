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
| Testdatum              | 19.12.2025 |
| Testperson             | Gabriel Sarkis |
| Ausgangslage           | Mehrere Fotos befinden sich im vorgesehenen Ordner im Repository |
| Testschritte           | Ausführen des Initialisierungsskripts |
| Erwartetes Ergebnis    | Die bekannte Persönlichkeit wird erkannt |
| Tatsächliches Ergebnis | Jeff Bezos wurde mit hoher Wahrscheinlichkeit erkannt |
| Testergebnis           | Erfolgreich |

**Fazit Testfall 1:**  
Der Testfall verlief erfolgreich. Die bekannte Persönlichkeit wurde korrekt erkannt 
und mit einer sehr hohen Wahrscheinlichkeit identifiziert.

---

### Testfall 2: Foto ohne bekannte Persönlichkeit

| Kriterium              | Beschreibung |
|------------------------|--------------|
| Testdatum              | 19.12.2025 |
| Testperson             | Gabriel Sarkis |
| Ausgangslage           | Foto ohne bekannte Persönlichkeit im Ordner vorhanden |
| Testschritte           | Ausführen des Initialisierungsskripts |
| Erwartetes Ergebnis    | Es wird keine bekannte Persönlichkeit erkannt |
| Tatsächliches Ergebnis | CelebrityCount: 0 |
| Testergebnis           | Erfolgreich |

**Fazit Testfall 2:**  
Der Testfall verlief erfolgreich. Das System erkannte korrekt, dass keine bekannte Persönlichkeit vorhanden ist.

---

![Testfälle 1 & 2 – Terminal-Ausgabe](screenshots/Test.png)

**Abbildung 2:** Terminal-Ausgabe eines vollständigen Testlaufs.
Das Initialisierungsskript analysiert zuerst ein Bild mit einer bekannten Persönlichkeit 
(Jeff Bezos) und erkennt diese mit sehr hoher Wahrscheinlichkeit. Anschliessend wird ein Bild 
ohne bekannte Persönlichkeit verarbeitet, wobei korrekt kein Treffer erkannt wird.

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
In diesem Projekt habe ich gelernt, wie man mit AWS arbeitet und wie die Services S3 und Lambda zusammen funktionieren. Besonders hilfreich war zu sehen, wie ein automatischer Ablauf aufgebaut ist, bei dem ein Verarbeitungsprozess gestartet wird und danach ein Resultat gespeichert wird. Dadurch habe ich besser verstanden, wie Cloud-Lösungen in der Praxis eingesetzt werden.

Positiv war auch die Zusammenarbeit im Team. Wir konnten uns gegenseitig helfen, Probleme besprechen und Lösungen gemeinsam suchen. Wenn jemand nicht weiterkam, haben wir versucht, das Problem zusammen zu analysieren, was den Lernprozess verbessert hat.

Verbesserungen sehe ich vor allem in der Planung. Die Einschränkungen im AWS Academy Lab, vor allem bei den Berechtigungen, haben uns mehr Zeit gekostet als erwartet. Für ein nächstes Projekt würde ich diese Punkte früher abklären, damit realistischer geplant werden kann.

Insgesamt war das Projekt lehrreich, da ich nicht nur technische Grundlagen gelernt habe, sondern auch gemerkt habe, wie wichtig gute Planung und Kommunikation im Team sind.

---

### Alessandro Renzetti
Das M346 FaceRecognition Projekt im AWS Learner Lab hat mir insgesamt sehr gut gefallen. Besonders spannend war für mich, dass wir am Ende eine funktionierende Lösung umgesetzt haben, die bekannte Persönlichkeiten auf Bildern erkennen kann.

Durch die Kombination von S3 Buckets, einer Lambda Funktion und dem AWS Rekognition Celebrity Service habe ich besser verstanden, wie verschiedene AWS Services zusammenarbeiten und einen automatisierten Ablauf ermöglichen. Am Anfang fand ich die Arbeit mit den Skripten eher kompliziert und teilweise schwer zu verstehen. Es war nicht immer sofort klar, was jedes Skript genau macht und wie die einzelnen Schritte zusammenhängen.

Mit der Zeit und durch das praktische Arbeiten wurde der Aufbau jedoch immer verständlicher. Positiv empfand ich den automatisierten Ablauf des Systems, der nach dem manuellen Start selbstständig arbeitet und die Analyseergebnisse speichert.

Als Verbesserung für ein nächstes Projekt würde ich mir eine klarere Einführung zu den einzelnen Skripten wünschen. Kurze Erklärungen zu Zweck und Ablauf der Skripte würden den Einstieg erleichtern. Insgesamt war das Projekt sehr lehrreich und praxisnah. Ich konnte mein Wissen zu AWS deutlich erweitern und habe einen guten Einblick in den Einsatz von Cloud-Technologien erhalten.

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

