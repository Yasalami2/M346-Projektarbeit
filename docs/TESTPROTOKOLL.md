# Unser Testbericht

**Wer hat getestet:** Gabriel Sarkis

**Datum & Uhrzeit:** 19.12.2025 23:00 Uhr

In diesem Bericht zeigen wir, dass unsere Gesichtserkennung in der AWS Cloud funktioniert.

---

## 1. Was haben wir getestet?

| ID. | Testfall | Ziel | Status |
|:--- |:--- |:--- |:--- |
| T1 | Promi erkennen | Erkennt das System Jeff Bezos? | ✅ OK |
| T2 | Normale Person | Erkennt das System, dass kein Promi da ist? | ✅ OK |
| T3 | Automatik | Läuft das ganze Script von alleine durch? | ✅ OK |

---

## 2. Die Ergebnisse im Detail

### Testfall T1: Der Promi-Test (Jeff Bezos)
Wir haben ein Bild von Jeff Bezos hochgeladen, um zu sehen, ob der AWS-Dienst ihn findet.
* **Was ist passiert:** Das Script hat die Infrastruktur geprüft und das Bild automatisch hochgeladen.
* **Ergebnis:** Jeff Bezos wurde sofort erkannt (Wahrscheinlichkeit: 99.99%).
* **Beweis (Screenshot):**
![Screenshot Terminal Jeff Bezos](./screenshots/PromiTest.png)
* **Fazit:** Der Test war erfolgreich. Die Verbindung zwischen Script, Lambda und Rekognition klappt einwandfrei.
* **Massnahmen/Empfehlungen:** Keine technischen Korrekturen nötig. Empfehlung: Bilder mit hoher Auflösung verwenden, um die Confidence-Rate hoch zu halten.

---
### Testfall T2: Der "keinPromi"-Test (Test.jpeg)
Wir haben ein Bild ohne bekannte Persönlichkeit getestet, um Fehlalarme zu vermeiden.
* **Ergebnis:** Das System zeigt korrekt "CelebrityResults": [] an, was bedeuted dass es "leer" ist und daher nichts gefunden hat.
* **Beweis (Screenshot):**
![Screenshot Terminal noPromi](./screenshots/Test.png)
* **Fazit:** Das System erkennt den Unterschied zwischen Prominenten und normalen Personen korrekt.
* **Massnahmen/Empfehlungen:** Es sollte darauf geachtet werden, dass das Gesicht frontal und ohne starke Schatten fotografiert wird, damit die AWS-Rekognition die Merkmale optimal mit der Promi-Datenbank abgleichen kann.

---

## 3. Unser Schlusswort
Alles läuft vollautomatisch über unser `init.sh` Script. Man muss nichts von Hand machen und sieht das Ergebnis sofort im Terminal.