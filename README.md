# Take Home Task - Aleksandra Lazarević

## Opis
Aplikacija urađena prema zahtevima dobijenim u PDF-u i prema screenshotu UI-a.
Podržava preuzimanje podataka sa servera, keširanje i offline uptorebu.
Napravljena je u SwiftUI-u, a za perzistenciju je korišćen CoreData.

## Arhitektura i funkcionalnosti

### MVVM + Repository
- **ViewModel**: State i biznis logika
- **Repository Pattern**: Centralizovano upravljanje podacima
- **Core Data**: Offline keširanje i perzistencija
- **Async/Await**

### Funkcionalnosti
  - **Paralelno učitavanje podataka** - sports, competitions i matches
  - **Cache-first** - instant prikaz keširanih podataka, zatim refresh sa servera
  - **Offline podrška** - aplikacija radi bez interneta sa keširanim podacima

## **Korišćene tehnologije**
 - **SwiftUI**
 - **Core Data**
 - **URLSession**
 - **Combine**
 - **Swift Concurrency**

### **Napomena za učitavanje SVG slika**
**Korišćena su 2 rešenja**
1. Custom WebView SVG Render
   - razlog korišćenja: da izbegnemo upotrebu eksternih biblioteka (ako nisu dozvoljene)
   - mane: nisu optimalne performanse jer se koristi webview i ne bih se inače odlučila za njega
2. Eksterna biblioteka SDWebImage
   - razlog: optimalnije rešenje i ovo je slučaj ako su dozvoljene biblitoeke

U projektu su primenjena oba načina.

### **Entiteti u CoreData**
  - SportEntity - sportovi
  - CompetitionEntity - lige
  - MatchEntity - mečevi sa statusom i rezultatima

## **Utrošeno vreme na implementaciju**

  | Komponenta | Vreme | Opis |
  |------------|--------|------|
  | **Setup projekta, osnovna struktura** | 0.75h | Inicijalni setup, boje, resources |
  | **Networking** | 1.25h | URLSession, DTO, refaktor osnovnog api poziva |
  | **Core Data** | 1.25h | Entiteti, logika za keširanje |
  | **Repository** | 1.0h | Data abstraction layer |
  | **ViewModel** | 1.25h | MVVM, filtriranje |
  | **UI komponente** | 2.0h | kartice, tabovi, sekcije |
  | **Rešavanje za SVG slike** | 1h | Primena custom WebView-based renderovanja i upotrebe SPM biblioteke |
  | **Ispravke bugova i dodatno sređivanje** | 0.5h | Sortiranje, UI izmene, prepakovanje koda |

  **Ukupno: 9h**
