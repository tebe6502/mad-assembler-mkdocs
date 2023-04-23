#

## Budowa plików

Przedruk z **Serious Magazine**, autor: **Qcyk/Dial**.

Plik sam w sobie jest tylko niewiele wartym zbiorem bajtów. Mnóstwo liczb, które mogą oznaczać wszystko, a zarazem nic, jeśli nie wiadomo jak je zinterpretować. Większość plików wyposaża się z tego powodu w różnorodne nagłówki, w których pamiętane są informacje o tym co plik zawiera, ew. jak go potem traktować przy odczycie. Do takich należą również pliki wykonywalne, binarne, czy po prostu: przeznaczone do załadowania z poziomu **DOS**, wszak **DOS** to też program i jak każdy inny ma prawo oczekiwać danych o określonej, znanej mu strukturze.

Tradycyjne pliki binarne, rozpoznawane przez wszystkie **DOS'y** dla komputerów **Atari XL/XE**, mają budowę blokową, gdzie każdy blok posiada swój nagłówek. Istnieją dwa rodzaje nagłówków:

1. `dta a($ffff),a(str_adr),a(end_adr)`

2. `dta a(str_adr),a(end_adr)`

`str_adr` - adres, pod który zostanie załadowany pierwszy bajt danych

`end_adr` - adres, pod który zostanie załadowany ostatni bajt

Pierwszy blok w pliku musi mieć nagłówek typu `$ffff`, pozostałe bloki dowolnie. Za nagłówkiem oczywiście powinny znaleźć się dane w ilości:

    (end_adr-str_adr)+1

Tyle tytułem przypomnienia. Twórcy systemu **Sparta DOS X** zachowali powyższy standard, dodając jednocześnie kilka nowych typów nagłówków. Ciągle więc mamy do czynienia z plikiem podzielonym na bloki, z tym że rodzajów bloków jest teraz dużo więcej. Oto one:

### Blok nierelokowalny

    dta a($fffa),a(str_adr),a(end_adr)

Blok nierelokowalny (ładowany pod stały adres w pamięci). Jest to to samo co blok `$ffff` - nie ma znaczenia, który zostanie użyty. `$fffa` będzie jednak wyraźnie wskazywać, że program jest przeznaczony dla SDX - inny DOS takiego pliku nie odczyta.

### Blok relokowalny

    dta a($fffe),b(blk_num),b(blk_id)
    dta a(blk_off),a(blk_len)

Blok relokowalny (ładowany pod MEMLO we wskazany rodzaj pamięci).

#### `blk_num`

Numer bloku w pliku. Każdy blok relokowalny powinien posiadać swój własny numer. Ponieważ adresy ładowania bloków nie są znane, bloki identyfikowane są właśnie poprzez swoje numery. Mogą one przyjmować wartości z zakresu `0-7`, z tym że w praktyce stosuje się zwykle numerację od 1 w górę.

#### `blk_id`

Bity `1-5` stanowią indeks pamięci, do której blok ma zostać załadowany. Spotkałem się z dwoma wartościami:

    $00 - pamięć podstawowa
    $02 - pamięć rozszerzona

Ustawienie dodatkowo bitu `7` oznacza brak bloku danych. **SDX** nic wtedy nie ładuje, ale rezerwuje pamięć.

#### `blk_off`

Tzw. przesunięcie adresów w bloku, czyli po prostu adres, pod który był assemblowany kod. Jest to potrzebne przy uaktualnianiu adresów odwołujących się do zawartości bloku.

#### `blk_len`

Długość bloku. Tyle danych powinno być za nagłówkiem chyba, że jest to blok rezerwujący pamięć wtedy danych nie ma.

Pisząc kod relokowalny trzeba mieć na uwadze kilka ograniczeń jakie narzuca idea *przemieszczalnego* kodu. Wszystkie adresy odwołujące się do obszaru takiego programu muszą zostać uaktualnione podczas ładowania, w związku z tym nie można używać sekwencji takich jak np.:

    lda coś
    ...
    coś equ *
    ...

Zamiast tego, pozostaje np.:

    lda _coś
    ldx _coś+1
    ...
    _coś dta a(coś)
    ...
    coś equ *

### Blok aktualizacji (relokacja)

    dta a($fffd),b(blk_num),a(blk_len)

Blok aktualizacji adresów odnoszących się do bloku relokowalnego


#### `blk_num`

Numer bloku, do którego odnoszą się uaktualniane adresy.

#### `blk_len`

Długość bloku aktualizacji (bez nagłówka). Jest ona ignorowana.

Adresy są uaktualniane poprzez dodanie do adresu istniejącego różnicy pomiędzy adresem, pod który został załadowany wskazany blok relokowalny, a wartością `blk_off` (adresem asemblacji) tego bloku. Można to przedstawić wzorem:

    ADR=ADR+(blk_adr-blk_off)

*Ciało* bloku aktualizacji stanowią wskaźniki do poprawianych adresów oraz rozkazy specjalne. Wskaźnik jest liczbą z zakresu `$00-$fb` i oznacza przesunięcie względem miejsca poprzedniej aktualizacji. Miejsce to jest pamiętane przez program ładujący jako bezpośredni adres, nazwijmy go licznikiem aktualizacji. Licznik ten można zainicjować za pomocą funkcji specjalnych, którymi są liczby większe od `$fb`:

* `$fc` oznacza koniec bloku aktualizacji,

* `$fd,a(ADDR)` następuje aktualizacja adresu wskazanego bezpośrednio przez `ADDR`. Tym samym wartość `ADDR` jest wpisywana do licznika aktualizacji i od niej będą liczone kolejne przesunięcia,

* `$fe,b(blk_num)` do licznika aktualizacji wstawiany jest adres bloku wskazanego przez `blk_num`, czyli kolejne aktualizacje będą się odnosiły do kodu zawartego w tym bloku,

* `$ff` licznik aktualizacji zwiększany jest o `$fa` (bez aktualizacji adresu).

### Blok aktualizacji (symbole)

    dta a($fffb),c'SMB_NAME',a(blk_len)

Blok aktualizacji adresów procedur zdefiniowanych symbolami.

#### `MB_NAME`

Symboliczna nazwa procedury (lub tablicy, rejestru systemowego itp.) Osiem znaków w kodzie ATASCII

#### `blk_len`

Jak w bloku `$fffd`.

Po nagłówku występuje ciąg wskaźników określających położenie adresów do zaktualizowania - identycznie jak w bloku `$fffd`. Adresy są zmieniane poprzez dodanie do istniejącego adresu, adresu procedury określonej symbolem. Pozwala to na wykorzystywanie w programach procedur, których adresów nie znamy, np. procedur dodawanych przez inne programy uruchamiane w środowisku SDX. Także procedury systemowe powinny być wykorzystywane w ten sposób, przecież mogą one mieć różne adresy w różnych wersjach **Sparty**.

### Blok definicji

    dta a($fffc),b(blk_num),a(smb_off)
    dta c'SMB_NAME'

Blok definicji nowych symboli.

#### `blk_num`

Numer bloku, w którym znajduje się definiowana procedura. Wynika z tego, że procedura musi być załadowana jako blok relokowalny.

#### `smb_off`

Przesunięcie adresu procedury w bloku, czyli offset procedury względem początku bloku (pierwszy bajt ma numer 0) powiększony o wartość `blk_off` tego bloku. Inaczej jest to adres pod jaki procedura została zassemblowana, `SMB_NAME` - symboliczna nazwa definiowanej procedury.

Bloki typu `$fffb` `$fffc` `$fffd` nie są na stałe zatrzymywane w pamięci. System wykorzystuje je tylko podczas ładowania programu.

## Programowanie

Składnia dotycząca obsługi **Sparta DOS X**, zaczerpnięta została z **FastAssembler** autorstwa **Marka Goderskiego**, poniżej cytat z instrukcji dołączonej do **FA**. Pliki źródłowe `*.FAS` można obecnie bez większych problemów asemblować za pomocą **MADS**. Rozkazy relokowalne mają zawsze 2 bajtowy argument, nie ma możliwości relokowania 3 bajtowych argumentów (*65816*).

Najważniejszą nowością w **SDX** dla programisty jest możliwość prostego pisania programów relokowalnych. Ponieważ procesor *MOS 6502* nie posiada adresowania względnego, (prócz krótkich skoków warunkowych) programiści z **ICD** zastosowali specjalne mechanizmy ładowania bloków programu. Cały proces polega na załadowaniu bloku, a następnie specjalnego bloku aktualizacji adresów. Wszystkie adresy w bloku programu są liczone od zera. Wystarczy więc dodać do nich wartość `memlo` aby otrzymać adres właściwy. Które adresy zwiększyć, a które pozostawić? Właśnie po to jest specjalny blok aktualizacji który zawiera wskaźniki (specjalnie kodowane) do tychże adresów. Tak więc po bloku lub blokach `RELOC` obowiązkowe jest wykonanie `UPDATE ADRESS` dla poprawnego działania programu. Również po blokach `SPARTA` w których rozkazy (lub wektory) odwołują się do bloków `RELOC` lub `EMPTY` obowiązkowe jest wykonanie `UPDATE ADRESS`.

Następną innowacją jest wprowadzenie symboli. Otóż niektóre procedury usługowe **SDX** zostały zdefiniowane za pomocą nazw! Nazwy te maja zawsze 8 liter (podobnie jak nazwy plików). Zamiast korzystać z tablic wektorów lub skoków (jak w **OS**) korzystamy z symboli definiowanych **SMB**. Po wczytaniu bloku lub bloków programu **SDX** ładuje blok aktualizacji symboli i w podobny sposób jak przy blokach relokowalnych zamienia adresy w programie. Symbole mogą być używane dla bloków `RELOC` i `SPARTA`.

Programista może zdefiniować własne symbole zastępujące **SDX** lub zupełnie nowe dla wykorzystania przez inne programy. Robi się to poprzez blok `UPDATE NEW`. Trzeba jednak wiedzieć że nowy symbol musi być zawarty w bloku `RELOC`.

Liczba bloków `RELOC` i `EMPTY` jest ograniczona do 7 przez **SDX**.

Bloki takie można łączyć w łańcuchy np:

```
blk sparta $600
...

blk reloc main
...

blk empty $100 main
...

blk reloc extended
...

blk empty $200 extended
```

Oznacza to że rozkazy w tych blokach mogą odwoływać się do wszystkich bloków w łańcuchu.

Łańcuch taki nie jest przerywany przez aktualizację adresów, lub symboli ale jest niszczony przez definicję nowego symbolu, oraz inne bloki, np.: `dos`.

**UWAGI**:

* Łańcuch taki ma sens tylko wtedy gdy wszystkie jego bloki ładują się do tej samej pamięci, lub gdy program przy odpowiednich odwołaniach przełącza pamięć.

* Rozkazy i wektory w blokach `RELOC` i `EMPTY` nie powinny odwoływać się do bloków `SPARTA`! Może to spowodować błąd gdy użytkownik załaduje program komendą `LOAD`, a użyje go po dłuższym czasie. O ile bloki `RELOC` i `EMPTY` były bezpieczne to nigdy nie wiadomo co jest w pamięci tam gdzie ostatnio był blok `SPARTA`! Równie niebezpieczne jest używanie odwołań do bloków `RELOC` i `EMPTY` przez bloki `SPARTA` (powód jak wyżej), jednakże podczas instalowania nakładek `*.sys` z użyciem `INSTALL` jest to czasem niezbędne, stąd jest dopuszczalne. Można także inicjować blok `SPARTA` - porzez `$2E2` - będzie on wtedy zawsze uruchomiony, a potem już zbędny.

* Pomiędzy blokami `SPARTA`, a `RELOC` i `EMPTY` może dojść do kolizji adresów! **FA** rozpoznaje odwołania do innych bloków poprzez adresy, przyjmując `PC` dla `RELOC` i `EMPTY` od `$1000`, tak więc gdy mieszamy te bloki należy mieć pewność ze `SPARTA` leży poniżej `$1000` (np.: `$600`) lub powyżej ostatniego bloku relokowalnego, zazwyczaj wystarcza `$4000`. Błąd taki nie jest przez kompilator wykrywany!