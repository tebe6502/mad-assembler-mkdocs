#

## Komentarze

Znaki komentarza jednoliniowego powinniśmy poprzedzać znakiem `;` lub `*`. Do oznaczania komentarza jednoliniowego najbezpieczniej jest jednak używać średnika `;` ponieważ znak `*` ma też inne znaczenia, może oznaczać operację mnożenia, czy też aktualny adres podczas asemblacji. Średnik natomiast dedykowany jest tylko i wyłącznie do oznaczania komentarzy.

Do oznaczenia komentarza jednoliniowego możliwe jest też użycie znaków `//`, a dla wieloliniowego znaków `/* */`.

```
 * to jest komentarz
                 ; to jest komentarz
 lda #0      ; to jest komentarz
 dta  1 , 3     * BŁĘDNY KOMENTARZ, ZOSTANIE ŹLE ZINTERPRETOWANY

 org $2000 + 1      BŁĘDNY KOMENTARZ, ZOSTANIE ŹLE ZINTERPRETOWANY

 nop // to jest komentarz

 // to jest komentarz

 dta 1,2, /* komentarz */ 3,4

 lda /* komentarz */ #0

/*
  ...
  to jest komentarz wieloliniowy
  ...
*/

/*************************************
  to tez jest komentarz wieloliniowy
**************************************/
```

Znaki oznaczające komentarz wieloliniowy `/* */` i znaki oznaczające komentarz jednoliniowy `//` można stosować bez ograniczeń.

## Łączenie wierszy

Dowolną ilość wierszy listingu możemy połączyć (rozdzielić) w jeden wiersz używając znaku `\`, np.:

```
 lda 20\ cmp 20\ beq *-2

    lda 20   \ cmp  20   \   beq *-2

  lda #0  \lop  sta $a000,y  \ iny  \ bne lop     ; komentarz tylko na końcu takiego wiersza
```


Jeśli po znaku `\` nie umieścimy znaku spacji, wówczas mnemonik czy inny ciąg znakowy może zostać zinterpretowany jako etykieta, należy pamiętać że znak `\` oznacza początek nowej linii.

**MADS** kończy przetwarzać taki wiersz, aż do napotkania komentarza lub napotkania końca ciągu znakowego, dlatego komentarze możemy umieszczać tylko na końcu takiego wielo-wiersza.
**UWAGA!!!*** Umieszczenie znaku `\` na końcu wiersza oznacza dla **MADS** chęć kontynuowania aktualnego wiersza od następnego wiersza, np.:

```
lda\
#\
12
```

Dla w/w przykładu otrzymamy rozkaz `LDA #12`.

## Łączenie mnemoników

Możliwość łączenia dwóch mnemoników za pomocą znaku dwukropka `:` znana jest już z **XASM**. W **MADS** ta możliwość została rozszerzona o łączenie dowolnej liczby znanych **MADS** mnemoników, np.:

```
lda:cmp:req 20

lda:iny:sta:iny $600,y
```

## Wyrażenia

Termin wyrażenie oznacza sekwencję operatorów i operandów (argumentów), która określa operacje, tj. rodzaj i kolejność obliczeń. Wyrażeniem złożonym nazywa się takie wyrażenie, w którym występuje dwa lub więcej operatorów. Operatory, które oddziaływują tylko na jeden operand, nazywa się jednoargumentowymi (unarnymi). Operatory dwuargumentowe nazywa się binarnymi.

Wartościowanie wyrażenia przebiega w porządku, określonym pierwszeństwem operatorów i w kierunku, określonym przez kierunek wiązania operatorów.

### Liczby

**MADS** akceptuje zapis liczb w formacie decymalnym, hexadecymalnym, binarnym oraz w kodach **ATASCII** i **INTERNAL**.

#### zapis decymalny

    -100
    -2437325
    1743

#### zapis hexadecymalny

    $100
    $e430
    $000001

    0x12
    0xa000
    0xaabbccdd

#### zapis binarny

    %0001001010
    %000000001
    %001000

#### zapis kodami ATASCII:

    'a'
    'fds'
    'W'*

#### zapis kodami INTERNAL:

    "B"
    "FDSFSD"
    "."*

Tylko pierwszy znak ciągu ATASCII, INTERNAL jest znaczący. Znak `*` za apostrofem zamykającym powoduje invers znaku.

---

Dodatkowo możliwe są jeszcze dwie operacje `+` `-` dla ciągów znakowych, które powodują zwiększenie/zmniejszenie kodów znaków ograniczonych apostrofami.

    "FDttrteSFSD"-12
    'FDSFdsldksla'+2

### Operatory

#### binarne

    +   Addition
    -   Subtraction
    *   Multiplication
    /   Division
    %   Remainder
    &   Bitwise and
    |   Bitwise or
    ^   Bitwise xor
    <<  Arithmetic shift left
    >>  Arithmetic shift right
    =   Equal
    ==  Equal (same as =)
    <>  Not equal
    !=  Not equal (same as <>)
    <   Less than
    >   Greater than
    <=  Less or equal
    >=  Greater or equal
    &&  Logical and
    ||  Logical or


#### jednoargumentowe

    +  Plus (does nothing)
    -  Minus (changes sign)
    ~  Bitwise not (complements all bits)
    !  Logical not (changes true to false and vice versa)
    <  Low (extracts low byte)
    >  High (extracts high byte)
    ^  High 24bit (extracts high byte)
    =  Extracts memory bank
    :  Extracts global variable value


#### kolejność wykonywania

    first []             (brackets)
    + - ~ < >            (unary)
    * / % & << >>        (binary)
    + - | ^              (binary)
    = == <> != < > <= >= (binary)
    !                    (unary)
    &&                   (binary)
    last  ||             (binary)

## Etykiety

 Etykiety zdefiniowane w programie mogą posiadać zasięg lokalny lub globalny, w zależności od miejsca w jakim zostały zdefiniowane. Oprócz tego można zdefiniować etykiety tymczasowe, które także mogą posiadać zasięg lokalny lub globalny.

* zasięg globalny etykiety oznacza, że jest ona widoczna z każdego miejsca w programie, niezależnie czy jest to makro `.MACRO`, procedura `.PROC` czy obszar lokalny `.LOCAL`.

* zasięg lokalny etykiety oznacza, że jest ona widoczna tylko w konkretnie zdefiniowanym obszarze, np. przez dyrektywy: `.MACRO`, `.PROC`, `.LOCAL`.

* etykiety muszą zaczynać się znakiem `['A'..'Z','a'..'z','_','?','@']`
* pozostałe dopuszczalne znaki etykiety to `['A'..'Z','a'..'z','0'..'9','_','?','@']`
* etykiety występują zawsze na początku wiersza
* etykiety poprzedzone "białymi znakami" powinny kończyć się znakiem `:` aby uniknąć błędnej interpretacji takiej etykiety jako makra
* w adresowaniu etykieta może być poprzedzona znakiem `:` informuje to asembler że odwołujemy się do etykiety w bloku głównym programu (odwołujemy się do etykiety globalnej)

Przykład definicji etykiet:

```
?nazwa   EQU  $A000    ; definicja etykiety tymczasowej globalnej
nazwa     =   *        ; definicja etykiety globalnej
nazwa2=12              ; definicja etykiety globalnej
@?nazwa  EQU  'a'+32   ; definicja etykiety globalnej
  name: equ 12         ; definicja etykiety globalnej nie zaczynającej się od pierwszego znaku wiersza
         nazwa: = 'v'  ; definicja etykiety globalnej nie zaczynającej się od pierwszego znaku wiersza
```

W porównaniu do **QA/XASM** doszła możliwość użycia znaku zapytania `?` i `@` w nazwach etykiet.
Użycie znaku kropki `.` w nazwie etykiety jest dopuszczalne, jednak nie zalecane. Znak kropki zarezerwowany jest do oznaczania rozszerzenia mnemonika, do oznaczenia dyrektyw assemblera, w adresowaniu nowych struktur **MADS**.

Znak kropki `.` na początku nazwy etykiety sugeruje że jest to dyrektywa assemblera, natomiast znak zapytania `?` na początku etykiety oznacza **etykietę tymczasową**, taką której wartość może się zmieniać wielokrotnie w trakcie asemblacji.

### Anonimowe

W celu zapewnienia przejrzystości kodu użycie etykiet anonimowych ograniczone jest tylko dla skoków warunkowych oraz do 10-u wystąpień w przód/tył.

Dla etykiet anonimowych został zarezerwowany znak `@`, po takim znaku musi wystąpić znak określający skok w przód `+` lub w tył `-`. Dodatkowo można określić numer wystąpienia etykiety anonimowej z zakresu `[0..9]`, brak numeru wystąpienia oznacza domyślnie `0`.

```
 @+[0..9]     ; forward
 @-[0..9]     ; backward

 @+           ; @+0
 @-           ; @-0

@ dex   ---- -------
  bne @+   |  --   |
  stx $80  |   |   |
@ lda #0   |  --   |
  bne @- ---       |
  bne @-1  ---------

  ldx #6
@ lda:cmp:req 20
@ dex
  bne @-1
```

### Lokalne

Każda definicja etykiety w obrębie makra .MACRO, procedury .PROC czy obszaru lokalnego `.LOCAL` domyślnie jest zasięgu lokalnego, innymi słowy jest lokalna. Takich etykiet użytkownik nie musi dodatkowo oznaczać.

Etykiety lokalne definiujemy używając n/w równoważnych pseudo rozkazów:

```
 EQU
  =
```

Aby mieć dostęp do etykiet o zasięgu globalnym (czyli zdefiniowanych poza makrem `.MACRO`, procedurą `.PROC`, obszarem lokalnym `.LOCAL`) i o takich samych nazwach jak lokalne, należy użyć operatora `:`, np.:

```
lp   ldx #0         ; definicja globalna etykiety LP

     test
     test

test .macro

      lda :lp       ; znak ':' przed etykietą odczyta wartość etykiety globalnej LP

      sta lp+1      ; odwołanie do etykiety lokalnej LP w obszarze makra
lp    lda #0        ; definicja etykiety lokalnej LP w obszarze makra

     .endm
```

W w/w przykładzie występują definicje etykiet o tych samych nazwach (LP), lecz każda z nich ma inną wartość i jest innego zasięgu.

### Globalne

Każda definicja etykiety dokonana w głównym bloku programu poza obszarem makra `.MACRO`, procedury `.PROC` czy obszaru lokalnego `.LOCAL` jest zasięgu globalnego, innymi słowy jest globalna.

Etykiety globalne definiujemy używając n/w równoważnych pseudo rozkazów:

```
 EQU
  =
```

lub dyrektywy `.DEF` o składni:

    .DEF :label [= expression]

Dyrektywa `.DEF` umożliwia zdefiniowanie etykiety w aktualnym obszarze lokalnym, znak `:` na początku etykiety sygnalizuje etykietę globalną. Użycie dyrektywy o składni `.DEF :label` pozwala na zdefiniowanie etykiety globalnej z pominięciem aktualnego poziomu lokalności.
Znak dwukropka `:` na początku etykiety ma specjalne znaczenie, informuje że odwołujemy się do etykiety globalnej, czyli etykiety z głównego bloku programu z pominięciem wszystkich poziomów lokalności.

Więcej informacji na temat użycia dyrektywy `.DEF` w rozdziale *Dyrektywa .DEF*

Przykład definicji etykiet globalnych:

```
lab equ *
   lab2 equ $4000

    ?tmp = 0
    ?tmp += 40

.proc name

      .def :?nazwa   = $A000
           .def :nazwa=20

      .local lok1
        .def :@?nazw   = 'a'+32
      .endl

.endp
```

Przykładem zastosowania definicji etykiety globalnej tymczasowej jest m.in. makro `@CALL`, przykład w pliku `..\EXAMPLES\MACROS\@CALL.MAC`, w którym występuje definicja etykiety tymczasowej `?@STACK_OFFSET`. Jest ona później wykorzystywana przez pozostałe makra wywoływane z poziomu makra `@CALL`, a służy do optymalizacji programu odkładającego parametry na stos programowy.

```
@CALL .macro

  .def ?@stack_offset = 0    ; definicja etykiety globalnej tymczasowej ?@stack_offset

  ...
  ...


@CALL_@ .macro

  sta @stack_address+?@stack_offset,x
  .def ?@stack_offset = ?@stack_offset + 1    ; modyfikacja etykiety ?@stack_offset

 .endm
```

### Tymczasowe

Definicja etykiety tymczasowej posiada tą właściwość, że jej wartość może ulegać zmianie wielokrotnie nawet podczas jednego przebiegu asemblacji. Normalnie próba ponownej definicji etykiety kończy się komunikatem Label declared twice. Nie będzie takiego komunikatu jeśli jest to etykieta tymczasowa.

Zasięg etykiet tymczasowych uzależniony jest od obszaru w jakim etykieta została zdefiniowana. Etykiety tymczasowe mogą posiadać zasięg lokalny (Etykiety lokalne) lub globalny (Etykiety globalne).

Etykietę tymczasową definiuje użytkownik poprzez umieszczenie na początku nazwy etykiety znaku zapytania `?`, np.:

    ?label

Etykiet tymczasowych nie powinno używać się do nazw procedur `.PROC`, makr `.MACRO`, obszarów lokalnych `.LOCAL`, struktur `.STRUCT`, tablic `.ARRAY`.

Etykiety tymczasowe definiujemy używając n/w równoważnych pseudo rozkazów:

```
 EQU
  =
```

Dodatkowo możemy je modyfikować za pomocą znanych z **C** operatorów:

    -= expression
    += expression
    --
    ++

W/w operatory modyfikujące dotyczą tylko etykiet tymczasowych, próba ich użycia dla innego typu etykiety skończy się komunikatem błędu **Improper syntax**.

Przykład użycia etykiet tymczasowych:

```
?loc = $567
?loc2 = ?loc+$2000

     lda ?loc
     sta ?loc2

?loc = $123

     lda ?loc
```

### Lokalne w stylu MAE

Opcja `OPT ?+` informuje **MADS** aby etykiety zaczynające się znakiem `?` interpretował jako etykiety lokalne tak jak robi to **MAE**. Domyślnie etykiety zaczynające się znakiem `?` traktowane są przez **MADS** jako etykiety tymczasowe.

Przykład użycia etykiet lokalnych w stylu **MAE**:

```
       opt ?+
       org $2000

local1 ldx #7
?lop   sta $a000,x
       dex
       bpl ?lop

local2 ldx #7
?lop   sta $b000,x
       dex
       bpl ?lop
```

## Kontrola asemblacji
### Zmiana opcji asemblacji
### Asemblacja warunkowa
### Przerwanie asemblacji
### Asemblacja na stronie zerowej
## Makro rozkazy
## Pseudo rozkazy
### Definiowanie bloku SDX
### Definiowanie symbolu SDX
### Definiowanie danych
## Dyrektywy
### Definiowanie powtórzeń `.REPT`
### Definiowanie symbolu SDX `.SYMBOL`
### Definiowanie tablic `.ARRAY`
### Definiowanie segmentów `.SEGDEF`
## Dyrektywy generujące kod 6502
### Definiowanie iteracji `#WHILE`
### Definiowanie decyzji `#IF`
### #CYCLE
## Tablice
### Deklaracja tablicy
## Makra
### Deklaracja makra
### Wywołanie makra
### Definiowanie makra
## Procedury
### Deklaracja procedury
### Wywołanie procedury
### Parametry procedury
## Obszar lokalny
### Deklaracja obszaru lokalnego
