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

> **UWAGA:**
> _Umieszczenie znaku `\` na końcu wiersza oznacza dla **MADS** chęć kontynuowania aktualnego wiersza od następnego wiersza, np.:_

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

```JavaScript
    -100
    -2437325
    1743
```

#### zapis hexadecymalny

```JavaScript
    $100
    $e430
    $000001

    0x12
    0xa000
    0xaabbccdd
```

#### zapis binarny

```JavaScript
    %0001001010
    %000000001
    %001000
```

#### zapis kodami ATASCII:

```JavaScript
    'a'
    'fds'
    'W'*
```

#### zapis kodami INTERNAL:

```JavaScript
    "B"
    "FDSFSD"
    "."*
```

Tylko pierwszy znak ciągu *ATASCII*, *INTERNAL* jest znaczący. Znak `*` za apostrofem zamykającym powoduje `invers` znaku.

---

Dodatkowo możliwe są jeszcze dwie operacje `+` `-` dla ciągów znakowych, które powodują zwiększenie/zmniejszenie kodów znaków ograniczonych apostrofami.

```JavaScript
    "FDttrteSFSD"-12
    'FDSFdsldksla'+2
```

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

Każda definicja etykiety w obrębie makra `.MACRO`, procedury `.PROC` czy obszaru lokalnego `.LOCAL` domyślnie jest zasięgu lokalnego, innymi słowy jest lokalna. Takich etykiet użytkownik nie musi dodatkowo oznaczać.

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

```
    .DEF :label [= expression]
```

Dyrektywa `.DEF` umożliwia zdefiniowanie etykiety w aktualnym obszarze lokalnym, znak `:` na początku etykiety sygnalizuje etykietę globalną. Użycie dyrektywy o składni `.DEF :label` pozwala na zdefiniowanie etykiety globalnej z pominięciem aktualnego poziomu lokalności.

Znak dwukropka `:` na początku etykiety ma specjalne znaczenie, informuje że odwołujemy się do etykiety globalnej, czyli etykiety z głównego bloku programu z pominięciem wszystkich poziomów lokalności.

Więcej informacji na temat użycia dyrektywy `.DEF` w rozdziale [Dyrektywa .DEF](#def)

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

Definicja etykiety tymczasowej posiada tą właściwość, że jej wartość może ulegać zmianie wielokrotnie nawet podczas jednego przebiegu asemblacji. Normalnie próba ponownej definicji etykiety kończy się komunikatem _**Label declared twice**_. Nie będzie takiego komunikatu jeśli jest to etykieta tymczasowa.

Zasięg etykiet tymczasowych uzależniony jest od obszaru w jakim etykieta została zdefiniowana. Etykiety tymczasowe mogą posiadać zasięg lokalny ([Etykiety lokalne](#lokalne)) lub globalny ([Etykiety globalne](#globalne)).

Etykietę tymczasową definiuje użytkownik poprzez umieszczenie na początku nazwy etykiety znaku zapytania `?`, np.:

    ?label

Etykiet tymczasowych nie powinno używać się do nazw procedur `.PROC`, makr `.MACRO`, obszarów lokalnych `.LOCAL`, struktur `.STRUCT`, tablic `.ARRAY`.

Etykiety tymczasowe definiujemy używając n/w równoważnych pseudo rozkazów:

```
 EQU
  =
```

Dodatkowo możemy je modyfikować za pomocą znanych z **C** operatorów:

```
    -= expression
    += expression
    --
    ++
```

W/w operatory modyfikujące dotyczą tylko etykiet tymczasowych, próba ich użycia dla innego typu etykiety skończy się komunikatem błędu _**Improper syntax**_.

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

### [Zmiana opcji asemblacji](#opt)

### [Asemblacja warunkowa](#if_else)

### [Przerwanie asemblacji](#error)

### Asemblacja na stronie zerowej

W przeciwieństwie do dwu-przebiegowych asemblerów takich jak **QA** i **XASM**, **MADS** jest wielo-przebiegowy. Co to daje ?

Weźmy sobie taki przykład:

```
 org $00

 lda tmp+1

tmp lda #$00
```

Dwu-przebiegowy assembler nie znając wartości etykiety `TMP` przyjmie domyślnie, że jej wartość będzie dwu-bajtowa, czyli typu `WORD` i wygeneruje rozkaz `LDA W`.

Natomiast **MADS** uprzejmie wygeneruje rozkaz strony zerowej `LDA Z`. I to właściwie główna i najprostsza do wytłumaczenia właściwość większej liczby przebiegów.

Teraz ktoś powie, że woli gdy rozkaz odwołujący się do strony zerowej ma postać `LDA W`. Nie ma sprawy, wystarczy że rozszerzy mnemonik:

```
 org $00

 lda.w tmp+1

tmp lda #$00
Są dopuszczalne trzy rozszerzenia mnemonika
 .b[.z]
 .w[.a][.q]
 .l[.t]
```

czyli odpowiednio `BYTE`, `WORD`, `LONG`. Z czego ostatni generuje 24bitową wartość i odnosi się do *65816* i pamięci o ciągłym obszarze. Więcej informacji na temat mnemoników *CPU 6502*, *65816* oraz ich dopuszczalnych rozszerzeń w rodziale [Mnemoniki].
Innym sposobem na wymuszenie rozkazu strony zerowej jest użycie nawiasów klamrowych `{ }` np.

```
 dta {lda $00},$80    ; lda $80
```

W **MADS** możemy robić tak samo, ale po co, ostatni przebieg załatwi sprawę za nas :) Problem stanowi teraz umieszczenie takiego fragmentu kodu w pamięci komputera. Możemy spróbować załadować taki program bezpośrednio na stronę zerową i jeśli obszar docelowy mieści się w granicy `$80..$FF` to pewnie **OS** przeżyje, poniżej tego obszaru będzie trudniej.
Dlatego **MADS** umożliwia takie coś:

```
 org $20,$3080

 lda tmp+1

tmp lda #$00
```

Czyli asembluj od adresu `$0020`, ale załaduj pod adres `$3080`. Oczywiście późniejsze przeniesienie kodu pod właściwy adres (w naszym przykładzie `$0020`) należy już do zadań programisty.

Podsumowując:

```
 org adres1,adres2
```

Asembluj od adresu `adres1`, umieść w pamięci od adresu `adres2`. Taki `ORG` zawsze spowoduje stworzenie nowego bloku w pliku, czyli zostaną zapisane dodatkowe cztery bajty nagłówka nowego bloku.

Jeśli nie zależy nam na nowym adresie umiejscowienia danych w pamięci, adresem umiejscowienia danych ma być aktualny adres wówczas możemy skorzystać z właściwości bloków `.LOCAL` i `.PROC`, bajty nagłówka nie będą w takim przypadku zapisywane, np.:

```none
     1
     2                                  org $2000
     3
     4 FFFF> 2000-200D> A9 00           lda #0
     5 2002 EA                          nop
     6
     7 0060                     .local  temp, $60
     8
     9 0060 BD FF FF                    lda $ffff,x
    10 0063 BE FF FF                    ldx $ffff,y
    11
    12                          .endl
    13
    14 2009 A5 60                       lda temp
    15 200B AD 03 20                    lda .adr temp
    16
```

Dla w/w przykładu blok programu `TEMP` zostanie zasemblowany z nowym adresem `= $60` i umiejscowiony w pamięci pod adresem `$2003`.

Po dyrektywie kończącej blok (`.ENDL`, `.ENDP`, `.END`) przywracamy jest adres asemblacji sprzed bloku plus jeszcze długość tak zasemblowanego bloku, w naszym przykładzie adresem od którego będzie kontynuowana asemblacja po zakończeniu bloku `.LOCAL` będzie adres `$2009`.
Następnie wykorzystując dyrektywy `.ADR` i `.LEN` można dokonać skopiowania takiego bloku pod właściwy adres, np.:

```
      ldy #0
copy  mva .adr(temp),y temp,y+
      cpy #.len temp
      bne copy
```

Więcej informacji na temat działania dyrektyw [.ADR](#d_adr) i [.LEN](#d_len).



## Makro rozkazy

 [REQ, RNE, RPL, RMI, RCC, RCS, RVC, RVS](#req)

 [SEQ, SNE, SPL, SMI, SCC, SCS, SVC, SVS](#seq)

 [JEQ, JNE, JPL, JMI, JCC, JCS, JVC, JVS](#jeq)

 [ADD, SUB](#add)

 [ADB, SBB](#adb)

 [ADW, SBW](#adw)

 [PHR, PLR](#phr)

 [INW, INL, IND, DEW, DEL, DED](#inw)

 [MVA, MVX, MVY](#mva)

 [MWA, MWX, MWY](#mwa)

 [CPB, CPW, CPL, CPD](#cpb)

Zadaniem makro rozkazów jest skrócenie czasu pisania programu i samego listingu. Makro rozkazy zastępują grupy często powtarzających się mnemoników.

<a name="req"></a>
### REQ, RNE, RPL, RMI, RCC, RCS, RVC, RVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok do poprzednio asemblowanej instrukcji, np.:

```
   lda:cmp:req 20           ->      lda 20
                            -> wait cmp 20
                            ->      beq wait

   ldx #0                   ->      ldx #0
   mva:rne $500,x $600,x+   -> loop lda $500,x
                            ->      sta $600,x
                            ->      inx
                            ->      bne loop
```

<a name="seq"></a>
### SEQ, SNE, SPL, SMI, SCC, SCS, SVC, SVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok do następnej asemblowanej instrukcji, np.:

```
   lda #40         ->       lda #40
   add:sta  $80    ->       clc
   scc:inc  $81    ->       adc $80
                   ->       sta $80
                   ->       bcc skip
                   ->       inc $81
                   ->  skip
```

<a name="jeq"></a>
### JEQ, JNE, JPL, JMI, JCC, JCS, JVC, JVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok warunkowy pod wskazany adres, z ich pomocą możemy skakać nie tylko w zakresie -128..+127 bajtów ale w całym zakresie **64kB** np.:

```
 jne dest   ->  beq *+4
            ->  jmp dest
```

Jeśli skok jest krótki (zakres -128..+127) wówczas **MADS** użyje krótkiego skoku, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`.

<a name="addq"></a>
### ADD, SUB

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie bajtu pamięci bez zapisywania wyniku (wynik w akumulatorze *CPU*).

```
  ADD -> CLC         SUB -> SEC
      -> ADC ...         -> SBC ...
```

<a name="adb"></a>
### ADB, SBB

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie bajtu pamięci z zapisaniem wyniku.

```
  ADB SRC #$40 -> LDA SRC       ADB A B C  -> LDA A
               -> CLC                      -> CLC
               -> ADC #$40                 -> ADC B
               -> STA SRC                  -> STA C

  SBB SRC #$80 -> LDA SRC       SBB A B C  -> LDA A
               -> SEC                      -> SEC
               -> SBC #$80                 -> SBC B
               -> STA SRC                  -> STA C
```

<a name="adw"></a>
### ADW, SBW

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie słowa pamięci z zapisaniem wyniku.

```
  ADW SRC #$40 -> CLC             ADW A B C  -> CLC
               -> LDA SRC                    -> LDA A
               -> ADC #$40                   -> ADC B
               -> STA SRC                    -> STA C
               -> SCC                        -> LDA A+1
               -> INC SRC+1                  -> ADC B+1
                                             -> STA C+1

  ADW SRC #$40 SRC -> CLC
                   -> LDA SRC
                   -> ADC #$40
                   -> STA SRC
                   -> LDA SRC+1
                   -> ADC #$00
                   -> STA SRC+1

  SBW SRC #$4080 -> SEC           SBW A B C  -> SEC
                 -> LDA SRC                  -> LDA A
                 -> SBC <$4080               -> SBC B
                 -> STA SRC                  -> STA C
                 -> LDA SRC+1                -> LDA A+1
                 -> SBC >$4080               -> SBC B+1
                 -> STA SRC+1                -> STA C+1
```

<a name="phr"></a>
### PHR, PLR

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `PHA`, `PLA`, realizują odkładanie na stosie i zdejmowanie ze stosu rejestrów `A`, `X`, `Y`.

```
  PHR  -> PHA         PLR  -> PLA
       -> TXA              -> TAY
       -> PHA              -> PLA
       -> TYA              -> TAX
       -> PHA              -> PLA
```

<a name="inw"></a>
### INW, INL, IND, DEW, DEL, DED

Makro rozkazy `INW`, `INL`, `IND` realizują zwiększenie odpowiednio słowa pamięci (`.WORD`), długiego słowa pamięci (`.LONG`), podwójnego słowa pamięci (`.DWORD`).

Makro rozkazy `DEW`, `DEL`, `DED` realizują zmniejszenie odpowiednio słowa pamięci (`.WORD`), długiego słowa pamięci (`.LONG`), podwójnego słowa pamięci (`.DWORD`) i wykorzystują w tym celu akumulator *CPU* (zawartość akumulatora ulega zmianie po wykonaniu makro rozkazów `DEW`, `DEL`, `DED`).

```
    inw dest  ->       inc dest    ->   inc dest
              ->       bne skip    ->   sne
              ->       inc dest+1  ->   inc dest+1
              ->  skip             ->

    dew dest  ->       lda dest    ->   lda dest
              ->       bne skip    ->   sne
              ->       dec dest+1  ->   dec dest+1
              ->  skip dec dest    ->   dec dest
```

<a name="mva"></a>
### MVA, MVX, MVY

Makro rozkazy `MVA`, `MVX`, `MVY` służą do przenoszenia bajtów (`.BYTE`) pamięci przy pomocy rejestrów *CPU* odpowiednio `A`, `X`, `Y`. Użycie opcji `OPT R+` pozwala na potencjalne skrócenie kodu wynikowego dla następujących po sobie makro rozkazów `MVA`, `MVX`, `MVY`.

```
    lda src    ->  mva src dst
    sta dst    ->

    ldy $10,x  ->  mvy $10,x $a0,x
    sty $a0,x  ->

    ldx #$10   ->  mvx #$10 dst
    stx dst    ->
```

<a name="mwa"></a>
### MWA, MWX, MWY

Makro rozkazy `MWA`, `MWX`, `MWY` służą do przenoszenia słów (`.WORD`) pamięci przy pomocy rejestrów *CPU* odpowiednio `A`, `X`, `Y`. Użycie opcji `OPT R+` pozwala na potencjalne skrócenie kodu wynikowego dla następujących po sobie makro rozkazów `MWA`, `MWX`, `MWY`.

```
    ldx <adr    ->  mwx #adr dst
    stx dst     ->
    ldx >adr    ->
    stx dst+1   ->

    mwa #0 $80  ->  lda #0           mwy #$3040 $80  ->  ldy <$3040
                ->  sta $80                          ->  sty $80
                ->  sta $81                          ->  ldy >$3040
                                                     ->  sty $81

    mwa ($80),y $a000,x  ->  lda ($80),y
                         ->  sta $a000,x
                         ->  iny
                         ->  lda ($80),y
                         ->  sta $a001,x
```

<a name="cpb"></a>
### CPB, CPW, CPL, CPD

Makro rozkazy `CPB`, `CPW`, `CPL`, `CPD` realizują porównanie wartości odpowiednich typów, odpowiednio `.BYTE`, `.WORD`, `.LONG`, `.DWORD`.

```
 cpw temp #$4080
 bcc skip

 cpd v0 v1
 beq skip
```

## Pseudo rozkazy

 [IFT _.IF_ expression](#ift)<br>
 [ELS _.ELSE_](#ift)<br>
 [ELI _.ELSEIF_ expression](#ift)<br>
 [EIF _.ENDIF_](#eif)<br>

 [ERT _ERT 'string'_ | ERT expression](#ert)

 [label SET expression](#set)<br>
 [label EXT type](#ext)<br>
 [label EQU expression](#equ)<br>
 [label  =  expression](#equ2)<br>

 [OPT [bcfhlmorst][+-]](#opt)<br>
 [ORG [[expression]]address[,address2]](#org)<br>
 [INS 'filename'["filename"][*][+-value][,+-ofset[,length]]](#ins)<br>
 [ICL 'filename'["filename"]](#icl)<br>

 [DTA [abfghltvmer](value1,value2...)[(value1,value2...)]](#dta)<br>
 [DTA [cd]'string'["string"]](#dta_s)<br>

 [RUN expression](#run)<br>
 [INI expression](#ini)<br>
 [END _.EN_](#end)<br>

 [SIN (centre,amp,size[,first,last])](#sin)<br>
 [COS (centre,amp,size[,first,last])](#cos)<br>
 [RND (min,max,length)](#rnd)

 [:repeat](#rep)

 [BLK N`one` X](#blk_n)<br>
 [BLK D`os` X](#blk_d)<br>
 [BLK S`parta` X](#blk_s)<br>
 [BLK R`eloc` M`ain`|E`xtended`](#blk_r)<br>
 [BLK E`mpty` X M`ain`|E`xtended`](#blk_e)<br>
 [BLK U`pdate` S`ymbols`](#blk_us)<br>
 [BLK U`pdate` E`xternal`](#blk_ue)<br>
 [BLK U`pdate` A`dress`](#blk_ua)<br>
 [BLK U`pdate` N`ew` X 'string'](#blk_un)<br>

 [label SMB 'string'](#smb)

 [NMB](#nmb)<br>
 [RMB](#rmb)<br>
 [LMB #expression](#lmb)<br>

Czyli w większości po staremu, chociaż parę zmian zaszło. W przypadku cudzysłowów można używać ' ' lub " ". Oba rodzaje cudzysłowów traktowane są jednakowo z wyjątkiem adresowania (dla ' ' zostanie wyliczona wartość `ATASCII` znaku, dla " " zostanie wyliczona wartość `INTERNAL` znaku).


### BLK

```
 BLK N[one] X                    - blok bez nagłówków, licznik programu ustawiany na X

 BLK D[os] X                     - blok DOS-a z nagłówkiem $FFFF lub bez nagłówka gdy
                                   poprzedni taki sam, licznik programu ustawiany na X

 BLK S[parta] X                  - blok o stałych adresach ładowania z nagłówkiem $FFFA,
                                   licznik programu ustawiany na X

 BLK R[eloc] M[ain]|E[xtended]   - blok relokowalny umieszczany w pamięci MAIN lub EXTENDED

 BLK E[mpty] X M[ain]|E[xtended] - blok relokowalny rezerwujący X bajtów w pamięci MAIN lub EXTENDED
                                   UWAGA: licznik programu jest natychmiastowo zwiększany o X bajtów

 BLK U[pdate] S[ymbols]          - blok aktualizujący w poprzednich blokach SPARTA lub
                                   RELOC adresy symboli SDX

 BLK U[pdate] E[xternal]         - blok aktualizujący adresy etykiet external (nagłówek $FFEE)
                                   UWAGA: nie dotyczy Sparta DOS X, jest to rozszerzenie MADS-a

 BLK U[pdate] A[dress]           - blok aktualizacji adresów w blokach RELOC

 BLK U[pdate] N[ew] X 'string'   - blok deklarujący nowy symbol 'string' w bloku RELOC
                                   o adresie X. Gdy nazwa symbolu poprzedzona jest znakiem @,
                                   a adres jest z pamięci podstawowej to taki symbol może być
                                   wywoływany z command.com
```

Więcej informacji na temat bloków w plikach **Sparta DOS X** w rozdziale [Budowa plików SPARTA DOS X](../sparta-dos/#budowa-plikow) oraz [Programowanie SPARTA DOS X](../sparta-dos/#programowanie).

<a name="set"></a>
### label SET expression

Pseudorozkaz `SET` pozwala redefiniować etykietę, ma podobne działanie jak etykiety tymczasowe zaczynające się znakiem `?`, np.:

```
temp set 12

     lda #temp

temp set 23

     lda #temp
```

<a name="smb"></a>
### label SMB 'string'

Deklaracja etykiety jako symbolu **SDX**. Symbol może mieć maksymalnie długość 8-iu znaków. Dzięki temu po użyciu `BLK UPDATE SYMBOLS` asembler wygeneruje poprawny blok aktualizacji symboli. Np:

```
       pf  smb 'PRINTF'
           jsr pf
           ...
```

sprawi że po instrukcji `JSR` system **SDX** wstawi adres symbolu.

> **UWAGA:**
> _Deklaracja ta nie jest przechodnia, to znaczy że poniższy przykład spowoduje błędy w czasie kompilacji:_

```
       cm  smb 'COMTAB'
       wp  equ cm-1       (błąd !)

           sta wp
```

Zamiast tego należy użyć:

```
       cm  smb 'COMTAB'

           sta cm-1       (ok !)
```

> **UWAGA:**
> _Wszystkie deklaracje symboli należy użyć przed deklaracjami etykiet, jak i programem właściwym !_


<a name="rep"></a>
### :repeat

```
           :4 asl @
           :2 dta a(*)
           :256 dta #/8

ladr :4 dta l(line:1)
hadr :4 dta h(line:1)
```

Znak `:` określa liczbę powtórzeń linii (w przypadku makr określa numer parametru pod warunkiem że wartość liczbowa zapisana została w systemie decymalnym). Liczba powtórzeń powinna być z zakresu `<0..2147483647>`. W powtarzanej linii `:repeat` możliwe jest skorzystanie z licznika pętli - znaku hash `#` lub z parametru `:1`.
Jeśli użyjemy znaku `:` w makrze w znaczeniu liczby powtórzeń linii, np.:

```
.macro test
 :2 lsr @
.endm
```

Wówczas dla w/w przykładu znak `:` zostanie zinterpretowany jako drugi parametr makra. Aby zapobiec takiej interpretacji przez **MADS**, należy po znaku dwukropka `:` umieścić znak który nic nie robi, np. znak plusa '+'.

```
.macro test
 :+2 lsr @
.endm
```

Teraz znak dwukropka `:` zostanie prawidłowo zinterpretowany jako `:repeat`

### OPT

Pseudo rozkaz `OPT` pozwala włączać/wyłączać dodatkowe opcje podczas asemblacji.

```
 b+  bank sensitive on
 b-  bank sensitive off                                               (default)
 c+  włącza obsługę CPU 65816 (16bit)
 c-  włącza obsługę CPU 6502 (8bit)                                   (default)
 f+  plik wynikowy w postaci jednego bloku (przydatne dla carta)
 f-  plik wynikowy w postaci blokowej                                 (default)
 h+  zapisuje nagłówek pliku dla DOS                                  (default)
 h-  nie zapisuje nagłówka pliku dla DOS
 l+  zapisuje listing do pliku (LST)
 l-  nie zapisuje listingu (LST)                                      (default)
 m+  zapisuje całe makra w listingu
 m-  zapisuje w listingu tylko tą część makra która zostaje wykonana  (default)
 o+  zapisuje wynik asemblacji do pliku wynikowego (OBX)              (default)
 o-  nie zapisuje wyniku asemblacji do pliku wynikowego (OBX)
 r+  optymalizacja długości kodu dla MVA, MVX, MVY, MWA, MWX, MWY
 r-  bez optymalizacji długości kodu dla MVA, MVX, MVY, MWA, MWX, MWY (default)
 s+  drukuje listing na ekranie
 s-  nie drukuje listingu na ekranie                                  (default)
 t+  track SEP REP on (CPU 65816)
 t-  track SEP REP off (CPU 65816)                                    (default)
 ?+  etykiety ze znakiem '?' na początku są lokalne (styl MAE)
 ?-  etykiety ze znakiem '?' na początku są tymczasowe                (default)
```

```
 OPT c+ c  - l  + s +
 OPT h-
 OPT o +
```

Wszystkie opcje `OPT` możemy używać w dowolnym miejscu listingu, czyli np. możemy włączyć zapis listingu w linii 12, a w linii 20 wyłączyć itd., wówczas plik z listingiem będzie zawierał tylko linie 12..20.

Jeśli chcemy użyć trybów adresowania *65816*, musimy o tym poinformować asembler przez `OPT C+`.

Jeśli używamy **CodeGenie** lub **NotePad++** możemy użyć `OPT S+`, dzięki temu nie musimy przechodzić do pliku z listingiem, bo listing wydrukowany został w dolnym okienku (Output Bar).


### ORG

Pseudo rozkaz `ORG` ustawia nowy adres asemblacji, a więc i lokalizację zasemblowanych danych w pamięci *RAM*.

```
 adr                 asembluj od adresu ADR, ustaw adres w nagłówku pliku na ADR
 adr,adr2            asembluj od adresu ADR, ustaw adres w nagłówku pliku na ADR2
 [b($ff,$fe)]        zmień nagłówek na $FFFE (zostaną wygenerowane 2 bajty)
 [$ff,$fe],adr       zmień nagłówek na $FFFE, ustaw adres w nagłówku pliku na ADR
 [$d0,$fe],adr,adr2  zmień nagłówek na $D0FE, asembluj od adresu ADR, ustaw adres w nagłówku pliku na ADR2
 [a($FFFA)],adr      nagłówek SpartaDOS $FAFF, ustaw adres w nagłówku pliku na ADR
```

```
 opt h-
 ORG [a($ffff),d'atari',c'ble',20,30,40],adr,adr2
```

Nawiasy kwadratowe `[ ]` służą określeniu nowego nagłówka, który może być dowolnej długości. Pozostałe wartości za zamykającym nawiasem kwadratowym `]`, rozdzielone znakiem przecinka `,` oznaczają odpowiednio: adres asemblacji, adres w nagłówku pliku.

Przykład nagłówka dla pliku w postaci jednego bloku, asemblowanego od adresu $2000, w nagłówku podany adres początkowy i adres końcowy bloku.

```
 opt h-f+
 ORG [a(start), a(over-1)],$2000

start
 nop
 .ds 128
 nop
over
```

<a name="ins"></a>
### INS 'filename'["filename"][*][+-value][,+-ofset[,length]]

Pseudo rozkaz `INS` pozwala na dołączenie dodatkowego pliku binarnego. Dołączany plik nie musi znajdować się w tym samym katalogu co główny asemblowany plik. Wystarczy, że odpowiednio wskazaliśmy **MADS**-owi ścieżki poszukiwań za pomocą przełącznika `/i` (patrz [Przełączniki assemblera](../sposob-uzycia/#przeaczniki-assemblera)).

Dodatkowo można przeprowadzić na dołączanym pliku binarnym operacje:

```
*          invers bajtów pliku binarnego
+-VALUE    zwiększenie/zmniejszenie wartości bajtów pliku binarnego o wartość wyrażenia VALUE

+OFSET     ominięcie OFSET bajtów z początku pliku binarnego (SEEK OFSET)
-OFSET     odczyt pliku binarnego od jego końca              (SEEK FileLength-OFSET)

LENGTH     odczyt LENGTH bajtów pliku binarnego
```

Jeśli wartość `LENGTH` nie została określona, domyślnie plik binarny zostanie odczytany aż do końca.

<a name="icl"></a>
### ICL 'filename'["filename"]

Pseudo rozkaz `ICL` pozwala na dołączenie dodatkowego pliku źródłowego i jego asemblację. Dołączany plik nie musi znajdować się w tym samym katalogu co główny asemblowany plik. Wystarczy, że odpowiednio wskazaliśmy **MADS**-owi ścieżki poszukiwań za pomocą przełącznika `/i` (patrz [Przełączniki assemblera](../sposob-uzycia/#przeaczniki-assemblera)).


### DTA

Pseudo rozkaz `DTA` służy do definicji danych określonego typu. Jeśli typ nie został określony wówczas domyślnie zostanie ustawiony typ `BYTE` (b).

```JavaScript
   b   wartość typu BYTE
   a   wartość typu WORD
   v   wartość typu WORD, relokowalna
   l   młodszy bajt wartości (BYTE)
   h   starszy bajt wartości (BYTE)
   m   najstarszy bajt wartości LONG (24bit)
   g   najstarszy bajt wartości DWORD (32bit)
   t   wartość typu LONG (24bit)
   e   wartość typu LONG (24bit)
   f   wartość typu DWORD (32bit)
   r   wartość typu DWORD w odróconej kolejności (32 bit)
   c   ciąg znaków ATASCII ograniczony apostrofami '' lub "", znak * na końcu spowoduje
       invers wartości ciągu, np. dta c'abecadlo'*
   d   ciąg znaków INTERNAL ograniczony apostrofami '' lub "", znak * na końcu spowoduje
       invers wartości ciągu, np. dta d'abecadlo'*
```

```JavaScript
  dta 1 , 2, 4
  dta a ($2320 ,$4444)
  dta d'sasasa', 4,a ( 200 ), h($4000)
  dta  c  'file' , $9b
  dta c'invers'*
```

<a name="sin"></a>
### SIN (centre,amp,size[,first,last])

```
centre     is a number which is added to every sine value
amp        is the sine amplitude
size       is the sine period
first,last define range of values in the table. They are optional.
           Default are 0,size-1.
```

```
   dta a(sin(0,1000,256,0,63))
```
defines table of 64 words representing a quarter of sine with amplitude of 1000.


<a name="cos"></a>
### COS (centre,amp,size[,first,last])

```
centre     is a number which is added to every cosine value
amp        is the cosine amplitude
size       is the cosine period
first,last define range of values in the table. They are optional.
           Default are 0,size-1.
```

```
   dta a(cos(0,1000,256,0,63))
```
defines table of 64 words representing a quarter of cosine with amplitude of 1000.


<a name="rnd"></a>
### RND (min,max,length)
Ten pseudo rozkaz umożliwia wygenerowanie LENGTH losowych wartości z przedziału <MIN..MAX>.

```
   dta b(rnd(0,33,256))
```

<a name="ift"></a>
### IFT, ELS, ELI, EIF

```
 IFT .IF expression
 ELS .ELSE
 ELI .ELSEIF expression
 EIF .ENDIF
```

W/w pseudo rozkazy i dyrektywy wpływają na przebieg asemblacji (można ich używać zamiennie).



## Dyrektywy generujące kod 6502

 [#IF type expression [.OR type expression] [.AND type expression]](#d_if)<br>
 [#ELSE](#d_if)<br>
 [#END](#d_if)<br>

 [#WHILE type expression [.OR type expression] [.AND type expression]](#d_while)<br>
 [#END](#d_while)<br>

 [#CYCLE #N](#d_cycle)

<a name="d_if"></a>
### #IF type expression [.OR type expression] [.AND type expression]

Dyrektywa `#IF` to skromniejszy odpowiednik instrukcji `IF` z języków wyższego poziomu (**C**, **Pascal**).

Dyrektywy `#IF`, `#ELSE` i `#END` pozwalają na wygenerowanie kodu maszynowego *CPU 6502* instrukcji warunkowej `IF` dla wyznaczonego bloku programu, możliwe jest ich zagnieżdżanie.

Dopuszczalne są wszystkie typy `.BYTE`, `.WORD`, `.LONG`, `.DWORD`, możliwe jest łączenie większej ilości warunków przy pomocy dyrektyw `.OR` i `.AND`, nie ma możliwości określenia kolejności wartościowania poprzez nawiasy.

Wykonanie dyrektywy `#IF` zaczyna się od obliczenia wartości wyrażenia prostego tzn. takiego które składa się z dwóch argumentów i jednego operatora (wyrażenia możemy łączyć dyrektywami `.OR` lub `.AND`).

Jeżeli wyrażenie ma wartość różną od zera (`TRUE`), to zostanie wykonywany blok programu występujący po dyrektywie `#IF`. Blok takiego programu automatycznie kończony jest instrukcją `JMP` realizującą skok do następnej instrukcji programu za dyrektywą `#END` w przypadku występowania bloku `#ELSE`.

Jeżeli wyrażenie ma wartość zero (`FALSE`), to wykonywany jest kod programu występujący po dyrektywie `#ELSE`, jeśli dyrektywa `#ELSE` nie występuje sterowanie przekazywane jest do następnej instrukcji programu za dyrektywą `#END`, np.:

```JavaScript
#if .byte label>#10 .or .byte label<#5
#end

#if .byte label>#100

#else

 #if .byte label<#200
 #end

#end

#if .byte label>#100 .and .byte label<#200 .or .word lab=temp
#end

#if .byte @
#end
```

<a name="d_while"></a>
### #WHILE type expression [.OR type expression] [.AND type expression]

Dyrektywa `#WHILE` jest odpowiednikiem instrukcji `WHILE` z języków wyższego poziomu (**C**, **Pascal**).

Dyrektywy `#WHILE` i `#END` pozwalają na wygenerowanie kodu maszynowego *CPU 6502* pętli dla wyznaczonego bloku programu, możliwe jest ich zagnieżdżanie.

Dopuszczalne są wszystkie typy `.BYTE`, `.WORD`, `.LONG`, `.DWORD`, możliwe jest łączenie większej ilości warunków przy pomocy dyrektyw `.OR` i `.AND`, nie ma możliwości określenia kolejności wartościowania poprzez nawiasy.

Sekwencja działań przy wykonywaniu dyrektywy `#WHILE` jest następująca:

1. Oblicz wartość wyrażenia i sprawdź, czy jest równe zeru (`FALSE`).
	- jeżeli tak, to pomiń krok 2;
	- jeżeli nie (`TRUE`), przejdź do kroku 2.
2. Wykonaj blok programu ograniczonego dyrektywami `#WHILE` i `#END`, następnie przejdź do kroku 1.

Jeżeli pierwsze wartościowanie wyrażenia wykaże, że ma ono wartość zero, to blok programu nigdy nie zostanie wykonany i sterowanie przejdzie do następnej instrukcji programu za dyrektywą `#END`

```JavaScript
#while .byte label>#10 .or .byte label<#5
#end

#while .byte label>#100
 #while .byte label2<#200
 #end
#end

#while .byte label>#100 .and .byte label<#200 .or .word lab=temp
#end
```

Wersja krótka pętli `#WHILE`, trwa dopóki `LABEL<>0`

```
#while .word label
#end
```

<a name="d_cycle"></a>
### #CYCLE #N

Dyrektywa `#CYCLE` pozwala wygenerować kod *6502* o zadanej liczbie cykli. Wygenerowany kod nie modyfikuje żadnej komórki pamięci, ani rejestru *CPU*, co najwyżej znaczniki.

```JavaScript
#cycle #17  ; pha      3 cycle
            ; pla      4 cycle
            ; pha      3 cycle
            ; pla      4 cycle
            ; cmp $00  3 cycle
                      ---------
                      17 cycle
```

## Tablice

### Deklaracja tablicy

Tablic dotyczą n/w dyrektywy:

```
label .ARRAY [elements0][elements1][...] [.type] [= init_value]
      .ARRAY label [elements0][elements1][...] [.type] [= init_value]
      .ENDA [.AEND] [.END]
```

Dostępne typy danych to `.BYTE`, `.WORD`, `.LONG`, `.DWORD`. W przypadku braku podania typu domyślnie przyjmowany jest typ `.BYTE`. Definicja tablicy lokalizuje ją in-place (w miejscu definicji).
`ELEMENTS` określa liczbę elementów tablicy, które będą indeksowane od `<0..ELEMENTS-1>`. Wartość `ELEMENTS` może być stałą lub wyrażeniem, powinna być z przedziału `<0..65535>`. W przypadku braku podania liczby elementów zostanie ona ustalona na podstawie liczby wprowadzonych danych.

W obszarze ograniczonym dyrektywami `.ARRAY` i `.ENDA` nie ma możliwości używania mnemoników *CPU*, jeśli je użyjemy lub użyjemy innych niedozwolonych znaków wówczas wystąpi błąd z komunikatem _**Improper syntax**_.

Dopuszczalne jest określenie indeksu od jakiego będziemy wpisywali wartości dla kolejnych pól tablicy. Nową wartość takiego indeksu określamy umieszczając na początku nowego wiersza w nawiasach kwadratowych wyrażenie `[expression]`. Możliwe jest określenie większej ilości indeksów, w tym celu rozdzielamy kolejne indeksy znakiem dwukropka `:`. Następnie wprowadzamy wartości dla pól tablicy po znaku równości `=`, np.:

```JavaScript
.array tab .word      ; tablica TAB o nieokreślonej z góry liczbie pól typu .WORD
 1,3                  ; [0]=1, [1]=3
 5                    ; [2]=5
 [12] = 1             ; [12]=1
 [3]:[7]:[11] = 9,11  ; [3]=9, [4]=11, [7]=9, [8]=11, [11]=9, [12]=11
.enda

.array scr [24][40]   ; tablica dwuwymiarowa SCR typu .BYTE
  [11][15] = "ATARI"
.enda
Przykład tablicy tłumaczącej kod naciśniętego klawisza na kod INTERNAL.

.array TAB [255] .byte = $ff   ; alokowanie 256 bajtów [0..255] o wartości początkowej $FF

 [63]:[127] = "A"              ; przypisanie nowej wartości TAB[63]="A", TAB[127]="A"
 [21]:[85]  = "B"
 [18]:[82]  = "C"
 [58]:[122] = "D"
 [42]:[106] = "E"
 [56]:[120] = "F"
 [61]:[125] = "G"
 [57]:[121] = "H"
 [13]:[77]  = "I"
 [1] :[65]  = "J"
 [5] :[69]  = "K"
 [0] :[64]  = "L"
 [37]:[101] = "M"
 [35]:[99]  = "N"
 [8] :[72]  = "O"
 [10]:[74]  = "P"
 [47]:[111] = "Q"
 [40]:[104] = "R"
 [62]:[126] = "S"
 [45]:[109] = "T"
 [11]:[75]  = "U"
 [16]:[80]  = "V"
 [46]:[110] = "W"
 [22]:[86]  = "X"
 [43]:[107] = "Y"
 [23]:[87]  = "Z"
 [33]:[97]  = " "

 [52]:[180] = $7e
 [12]:[76]  = $9b

.enda
```

W w/w przykładzie stworzyliśmy tablicę `TAB` o rozmiarze 256 bajtów `[0..255]`, typie danych `.BYTE` i wypełniliśmy pola wartością `= $FF`, dodatkowo zapisaliśmy wartości kodów literowych `INTERNAL` na pozycjach (indeksach tablicy) równych kodowi naciśnięcia klawisza (bez SHIFT-a i z SHIFT-em, czyli duże i małe litery).

Znak dwukropka `:` rozdziela poszczególne indeksy tablicy.

Przykład procedury detekcji ruchu joysticka, np.:

```JavaScript
.local HERO

  .pages

  lda $d300
  and #$0f
  tay
  lda joy,y
  sta _jmp

  jmp null
_jmp equ *-2

left
right
up
down

null

  rts

  .endpg

  _none     = 15
  _up       = 14
  _down     = 13
  _left     = 11
  _left_up  = 10
  _left_dw  = 9
  _right    = 7
  _right_up = 6
  _right_dw = 5

.array joy [16] .byte = .lo(null)

	[_left]     = .lo(left)
	[_left_up]  = .lo(left)
	[_left_dw]  = .lo(left)

	[_right     = .lo(right)
	[_right_up] = .lo(right)
	[_right_dw] = .lo(right)

	[_up]       = .lo(up)
	[_dw]       = .lo(down)
.enda

.endl
```

Innym przykładem może być umieszczenie wycentrowanego napisu, np.:

```JavaScript
 org $bc40

.array txt 39 .byte
 [17] = "ATARI"
.enda
Do tak stworzonej tablicy odwołujemy się następująco:
 lda tab,y
 lda tab[23],x
 ldx tab[200]
```

Jeśli w nawiasie kwadratowym podamy wartość indeksu przekraczającą zadeklarowaną dla danej tablicy, zostanie wygenerowany komunikat błędu _**Constant expression violates subrange bounds**+.


## Makra

Makra ułatwiają nam wykonywanie powtarzających się czynności, automatyzują je. Istnieją tylko w pamięci assemblera, dopiero w momencie wywołania są asemblowane. Przy ich pomocy **MADS** może odkładać i zdejmować z programowego stosu parametry dla procedur zadeklarowanych dyrektywą `.PROC` oraz przełączać banki rozszerzonej pamięci w trybie *BANK SENSITIVE* (`OPT B+`).

### Deklaracja makra
Makr dotyczą n/w pseudo rozkazy i dyrektywy:

```
name .MACRO [arg1, arg2 ...] ['separator'] ["separator"]
     .MACRO name [(arg1, arg2 ...)] ['separator'] ["separator"]
     .EXITM [.EXIT]
     .ENDM [.MEND]
     :[%%]parameter
     :[%%]label
```

#### name .MACRO [(arg1, arg2 ...)] ['separator'] ["separator"]

Deklaracja makra o nazwie name za pomocą dyrektywy `.MACRO`. Nazwa makra jest wymagana i konieczna, jej brak wygeneruje błąd. Do nazw makr nie można używać nazw mnemoników i pseudo rozkazów (błąd _**Reserved word**_).

Dopuszczalna jest lista z etykietami nazw argumentów jakie będą przekazywane do makra, taka lista może być ograniczona dodatkowo nawiasem okrągłym `( )`. Przedstawianie argumentów w postaci nazw etykiet ma na celu poprawienie przejrzystości kodu makra. W samym ciele makra można używać zamiennie nazw etykiet argumentów lub ich numerycznych odpowiedników.

```
.macro SetColor val,reg
 lda :val
 sta :reg
.endm
```

Na końcu deklaracji makra może wystąpić deklaracja separatora i zarazem trybu przekazywania parametrów do makra (pojedyńczy apostrof bez zmian, podwójny apostrof z rozbijaniem parametrów na tryb adresacji i argument).
Domyślnym separatorem, rozdzielającym parametry przekazywane do makra jest znak przecinka `,` oraz spacji `' '`.

```
name .MACRO 'separator'
```

Pomiędzy pojedyńczymi apostrofami `' '` możemy umieścić znak separatora, który będzie używany do oddzielenia parametrów przy wywołaniu makra (tylko do tego mogą służyć pojedyńcze apostrofy).

```
name .MACRO "separator"
```

Pomiędzy podwójnymi apostrofami `" "` możemy także umieścić znak separatora, który będzie używany do oddzielenia parametrów przy wywołaniu makra. Dodatkowo użycie podwójnego apostrofu sygnalizuje **MADS**-owi aby rozkładał przekazywane parametry na dwa elementy: tryb adresacji i argument, np.:

```
 test #12 200 <30

test .macro " "
.endm
```

Makro `TEST` ma zadeklarowany separator-spację przy użyciu apostrofu `"`, czyli po wywołaniu makra parametry zostaną rozłożone na dwa elementy: tryb adresacji i argument.

```
 #12   ->  tryb adresacji '#' argument 12
 200   ->  tryb adresacji ' ' argument 200
 <30   ->  tryb adresacji '#' argument 0   (obliczona wartość wyrażenia "<30")

 test '#' 12 ' ' 200 '#' 0
```

UAWAGA #1: Parametry ze znakiem operatora `<`, `>` zostają obliczone i dopiero ich wynik jest przekazywany do makra (podstawiany pod parametr).

UAWAGA #2: Jeśli parametrem makra jest licznik pętli `#`, `.R` (!!! pojedyńczy znak `#` lub dyrektywa `.R` a nie wyrażenie z udziałem tego znaku, tej dyrektywy !!!) wówczas do makra przekazywana jest wartość licznika pętli (podstawiana pod parametr).

Tą właściwość możemy wykorzystać do stworzenia "samopiszącego" się kodu, kiedy potrzebujemy tworzyć nowe etykiety typu "label0", "label1", "label2", "label3" ... itd. , np.:

```
 :32 find #

find .macro
      ift .def label:1
      dta a(label:1)
      eif
     .endm
```

W/w przykład zapisuje adres etykiety pod warunkiem że taka etykiety istnieje (została zdefiniowana).


#### .EXITM [.EXIT]
Zakończenie działania makra. Powoduje bezwzględne zakończenie działania makra.

#### .ENDM [.MEND]
Przy pomocy dyrektywy `.ENDM` lub `.MEND` kończymy deklarację aktualnego makra. Nie ma możliwości użycia dyrektywy `.END` jak ma to miejsce dla innych obszarów deklarowanych przez dyrektywy `.LOCAL`, `.PROC`, `.ARRAY`, `.STRUCT`, `.REPT`

#### :[%%]parameter

Parametr jest liczbą decymalną dodatnią (`>=0`), poprzedzoną znakiem dwukropka `:` lub dwoma znakami procentu `%%`. Jeśli w makrze chcemy aby znak `:` określał liczbę powtórzeń a nie numer parametru wystarczy że następny znak po dwukropku nie będzie z przedziału `'0'..'9'`, tylko np:

```
 :$2 nop
 :+2 nop
 :%10 nop
```

Parametr `:0` (`%%0`) ma specjalne znaczenie, zawiera liczbę przekazanych parametrów. Z jego pomocą możemy sprawdzić czy wymagana liczba parametrów została przekazana do makra, np.:

```
  .IF :0<2 || :0>5
    .ERROR "Wrong number of arguments"
  .ENDIF

  IFT %%0<2 .or :0>5
    ERT "Wrong number of arguments"
  EIF
```

Przykład makra:

```
.macro load_word

   lda <:1
   sta :2
   lda >:1
   sta :2+1
 .endm

 test ne
 test eq

.macro test
  b%%1 skip
.endm
```


### Wywołanie makra

Makro wywołujemy poprzez jego nazwę, po niej mogą wystąpić parametry makra, rozdzielone separatorem którym jest domyślnie znak przecinka `,` lub spacji `' '`.

Liczba parametrów uzależniona jest od wolnej pamięci komputera *PC*. Jeśli przekazana liczba parametrów jest mniejsza od liczby parametrów używanych w danym makrze, wówczas pod brakujące parametry zostanie podstawiona wartość `-1` (`$FFFFFFFF`). Tą właściwość można wykorzystać do sprawdzenia czy został przekazany parametr czy też nie, łatwiej jednak tego dokonać za pomocą parametru zerowego `%%0`.

```
 macro_name [Par1, Par2, Par3, 'Par4', "string1", "string2" ...]
```

Parametrem może być wartość, wyrażenie lub ciąg znaków ograniczony apostrofem pojedyńczym `' '` lub podwójnym `" "`.

* apostrofy pojedyńcze `' '` zostaną przekazane do makra razem ze znakami znajdującymi się pomiędzy nimi
* apostrofy podwójne `" "` oznaczają ciąg znaków i tylko ciąg znaków znajdujący się pomiędzy apostrofami zostanie przekazany do makra

Wszelkie definicje etykiet w obrębie makra mają zasięg lokalny.

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze makra, wówczas nastąpi jej szukanie w obszarze lokalnym (jeśli wystąpiła dyrektywa `.LOCAL`), następnie w procedurze (jeśli procedura jest aktualnie przetwarzana), na końcu w głównym programie.

Przykład wywołania makra:

```
 macro_name 'a',a,>$a000,cmp    ; dla domyślnego separatora ','
 macro_name 'a'_a_>$a000_cmp    ; dla zadeklarowanego separatora '_'
 macro_name 'a' a >$a000 cmp    ; dla domyślnego separatora ' '
```

Możliwe jest wywoływanie makr z poziomu makra, oraz rekurencyjne wywoływanie makr. W tym ostatnim przypadku należy być ostrożnym bo może dojść do przepełnienia stosu **MADS**-a. **MADS** zabezpiecza się przez rekurencją makr bez końca i zatrzymuje asemblacje gdy liczba wywołań makra przekroczy 4095 (błąd _**Infinite recursion**_).

Przykład makra, które spowoduje przepełnienie stosu **MADS**-a:

```
jump .macro

      jump

     .endm
```

Przykład programu, który przekazuje parametry do pseudo procedur ..\EXAMPLES\MACRO.ASM:

```
 org $2000

 proc PutChar,'a'-64    ; wywołanie makra PROC, jako parametr
 proc PutChar,'a'-64    ; nazwa procedury która będzie wywołana przez JSR
 proc PutChar,'r'-64    ; oraz jeden argument (kod znaku INTERNAL)
 proc PutChar,'e'-64
 proc PutChar,'a'-64

 proc Kolor,$23         ; wywołanie innej procedurki zmieniającej kolor tła

;---

loop jmp loop           ; pętla bez końca, aby zobaczyć efekt działania

;---

proc .macro             ; deklaracja makra PROC
 push =:1,:2,:3,:4      ; wywołanie makra PUSH odkładającego na stos argumenty
                        ; =:1 wylicza bank pamieci

 jsr :1                 ; skok do procedury (nazwa procedury w pierwszym parametrze)

 lmb #0                 ; Load Memory Bank, ustawia bank na wartosc 0
 .endm                  ; koniec makra PROC

;---

push .macro             ; deklaracja makra PUSH

  lmb #:1               ; ustawia wirtualny bank pamięci

 .if :2<=$FFFF          ; jeśli przekazany argument jest mniejszy równy $FFFF to
  lda <:2               ; odłóż go na stosie
  sta stack
  lda >:2
  sta stack+1
 .endif

 .if :3<=$FFFF
  lda <:3
  sta stack+2
  lda >:3
  sta stack+3
 .endif

 .if :4<=$FFFF
  lda <:4
  sta stack+4
  lda >:4
  sta stack+5
 .endif

 .endm


* ------------ *            ; procedura KOLOR
*  PROC Kolor  *
* ------------ *
 lmb #1                     ; ustawienie numeru wirtualnego banku na 1
                            ; wszystkie definicje etykiet będą teraz należeć do tego banku
stack org *+256             ; stos dla procedury KOLOR
color equ stack

Kolor                       ; kod procedury KOLOR
 lda color
 sta 712
 rts


* -------------- *          ; procedura PUTCHAR
*  PROC PutChar  *
* -------------- *
 lmb #2                     ; ustawienie numeru wirtualnego banku na 2
                            ; wszystkie definicje etykiet będą teraz należeć do tego banku
stack org *+256             ; stos dla procedury PUTCHAR
char  equ stack

PutChar                     ; kod procedury PUTCHAR
 lda char
 sta $bc40
scr equ *-2

 inc scr
 rts
```

Oczywiście stos w tym przykładowym programie jest programowy. W przypadku *65816* można byłoby użyć stosu sprzętowego. Dzięki temu, że zdefiniowane zmienne przypisywane są do konkretnego numeru banku, można stworzyć strukturę wywołania procedury czy funkcji podobną do tych z języków wyższego poziomu.

Prościej i efektywniej jednak skorzystać z deklaracji procedury `.PROC` jaką umożliwia **MADS**. Więcej o deklaracji procedury i operacjach jej dotyczących w rozdziale [Procedury].


## Obszar lokalny

Głównym zadaniem obszaru lokalnego w **MADS** jest stworzenie nowej przestrzeni nazw dla etykiet.

Wszelkie etykiety zdefiniowane w obszarze lokalnym `.LOCAL` są zasięgu lokalnego, można je też określić jako etykiety globalne zdefiniowane lokalnie o dostępie swobodnym, ponieważ można się do nich odwoływać co nie jest normalne w innych językach programowania.

Obszary lokalne są addytywne tzn. że może być wiele bloków `.LOCAL` o tej samej nazwie, nie zostanie wygenerowany komunikat błędu _**Label ... declared twice**_.

Addytywność obszarów lokalnych odbywa się na aktualnym poziomie przestrzeni nazw, jeśli chcemy połączyć się z wybranym obszarem lokalnym w innej przestrzeni nazw, poprzedzamy pełną nazwę prowadzącą do takiego obszaru znakiem `+`, np.:

```
  .local lvl

tmp = 3

  .endl



  .local temp

tmp = 7


    .local +lvl

      .print tmp

    .endl


  .endl

```

Dla w/w przykładu zostanie wyświetlona wartość etykiety `TMP` z obszaru lokalnego `LVL` o wartości `3`. Gdyby zabrakło znaku `+` w `.LOCAL +LVL` wówczas wartość `TMP` jaka zostanie wyświetlona to `7`.

W obszarze lokalnym `.LOCAL` istnieje możliwość zdefiniowania etykiet o zasięgu globalnym (patrz rozdział [Etykiety globalne](#globalne)).

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze lokalnym `.LOCAL`, wówczas **MADS** będzie poszukiwał ją w obszarze niższym aż dojdzie do obszaru globalnego. Aby odczytać natychmiastowo wartość etykiety globalnej z poziomu obszaru lokalnego `.LOCAL` (czy też innego obszaru lokalnego) poprzedzamy nazwę etykiety znakiem dwukropka `:`.

Obszarów lokalnych dotyczą n/w dyrektywy:

```
 [name] .LOCAL [,address]
 .LOCAL [name] [,address]
 .ENDL [.LEND] [.END]
```

### [name] .LOCAL [,address]

Deklaracja obszaru lokalnego o nazwie `name` za pomocą dyrektywy `.LOCAL`. Nazwa obszaru nie jest wymagana i nie jest konieczna. Do nazw obszarów lokalnych nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem _**Reserved word**_.

Po nazwie obszaru lokalnego (lub po dyrektywie `.LOCAL`) możemy podać nowy adres asemblacji bloku lokalnego. Po zakończeniu takiego bloku (`.ENDL`) przywracany jest poprzedni adres asemblacji zwiększony o długość bloku lokalnego.

```
label .local,$4000
.endl

.local label2,$8000
.endl

.local
.endl

.local label3
.endl
```

Wszelkie definicje etykiet w obszarze `.LOCAL` są typu lokalnego. Aby odwołać się do etykiety globalnej o tej samej nazwie co etykieta lokalna należy poprzedzić ją znakiem dwukropka `:`, np.:

```
lab equ 1

.local

lab equ 2

 lda #lab
 ldx #:lab

.endl
```

W w/w przykładzie do rejestru `A` zostanie załadowana wartość `2`, natomiast do rejestru `X` wartość `1`.

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze `.LOCAL`, wówczas nastąpi jej szukanie w obszarze makra (jeśli jest aktualnie przetwarzane), potem w procedurze (jeśli procedura jest aktualnie przetwarzana), na końcu w głównym programie.

W zadeklarowanym obszarze lokalnym wszystkie definicje etykiet rozróżniane są na podstawie nazwy obszaru lokalnego. Aby dotrzeć do zdefiniowanej etykiety w obszarze lokalnym spoza obszaru lokalnego musimy znać nazwę obszaru i etykiety w nim występującej, np.:

```
 lda #name.lab1
 ldx #name.lab2

.local name

lab1 = 1
lab2 = 2

.endl
```

W adresowaniu takiej struktury `.LOCAL` używamy znaku kropki `.`.

Obszary lokalne możemy zagnieżdżać, możemy je umieszczać w ciele procedur zadeklarowanych przez dyrektywę `.PROC`. Obszary lokalne są addytywne, tzn. może istnieć wiele obszarów lokalnych o tej samej nazwie, wszystkie symbole występujące w tych obszarach należeć będą do wspólnej przestrzeni nazw.

Długość wygenerowanego kodu w bloku `.LOCAL` można sprawdzić przy pomocy dyrektywy `.LEN` (`.SIZEOF`).

### .ENDL
Dyrektywa `.ENDL` kończy deklarację obszaru lokalnego.

Przykład deklaracji obszaru lokalnego:

```
 org $2000

tmp ldx #0   <-------------   etykieta w obszarze globalnym
                          |
 lda obszar.pole  <---    |   odwolanie do obszaru lokalnego
                     |    |
.local obszar        |    |   deklaracja obszaru lokalnego
                     |    |
 lda tmp   <---      |    |
              |      |    |
 lda :tmp     |      | <---   odwolanie do obszaru globalnego
              |      |
tmp nop    <---      |        definicja w obszarze lokalnym
                     |
pole lda #0       <---   <--- definicja w obszarze lokalnym
                            |
 lda pole  <----------------- odwolanie w obszarze lokalnym

.endl                        koniec deklaracji obszaru lokalnego
```


## Dyrektywy


 [.A8, .A16, .AI8, .AI16](#a8)<br>
 [.I8, .I16, .IA8, .IA16](#i8)<br>

 [.ASIZE](#asize)<br>
 [.ISIZE](#isize)<br>

 [.ALIGN N[,fill]](#align)

 [.ARRAY label [elements0][elements1][...] .type [= init_value]](#tablice)<br>
 [.ENDA, [.AEND]](#tablice)<br>

 [.DEF label [= expression]](#def)

 [.DEFINE macro_name expression](#define)<br>
 [.UNDEF macro_name](#undef)<br>

 [.ENUM label](../typy/#wyliczenia)<br>
 [.ENDE, [.EEND]](../typy/#wyliczenia)<br>

 [.ERROR [ERT] 'string'["string"] lub .ERROR [ERT] expression](#error)

 [.EXTRN label [,label2,...] type](../kod-relokowalny/#symbole-zewnetrzne)

 [.IF [IFT] expression](#if_else)<br>
 [.ELSE [ELS]](#if_else)<br>
 [.ELSEIF [ELI] expression](#if_else)<br>
 [.ENDIF [EIF]](#if_else)<br>

 [.IFDEF label](#ifdef)<br>
 [.IFNDEF label](#ifndef)<br>

 [.LOCAL label](#obszar-lokalny)<br>
 [.ENDL, [.LEND]](#obszar-lokalny)<br>

 [.LONGA ON|OFF](../kod-relokowalny/#dyrektywy-longa-longi)<br>
 [.LONGI ON|OFF](../kod-relokowalny/#dyrektywy-longa-longi)<br>

 [.LINK 'filename'](../kod-relokowalny/#linkowanie-link)

 [.MACRO label](#makra)<br>
 [.ENDM, [.MEND]](#makra)<br>
 [:[%%]parameter](#makra)<br>
 [.EXITM [.EXIT]](#makra)<br>

 [.NOWARN](#nowarn)

 [.PRINT [.ECHO] 'string1','string2'...,value1,value2,...](#print)

 [.PAGES [expression]](#pages)<br>
 [.ENDPG, [.PGEND]](#pages)<br>

 [.PUBLIC, [.GLOBAL], [.GLOBL] label [,label2,...]](../kod-relokowalny/#symbole-publiczne)

 [.PROC label](#deklaracja-procedury)<br>
 [.ENDP, [.PEND]](#deklaracja-procedury)<br>
 [.REG, .VAR](#deklaracja-procedury)<br>

 [.REPT expression [,parameter1, parameter2, ...]](#rept)<br>
 [.ENDR, [.REND]](#rept)<br>
 [.R](#rept)<br>

 [.RELOC [.BYTE|.WORD]](../kod-relokowalny/#blok-relokowalny-reloc)

 [.STRUCT label](../typy/#struktury)<br>
 [.ENDS, [.SEND]](../typy/#struktury)<br>

 [.SYMBOL label](#symbol)

 [.SEGDEF label address length [bank]](#seg)<br>
 [.SEGMENT label](#seg)<br>
 [.ENDSEG](#seg)<br>

 [.USING, [.USE] proc_name, local_name](#using)

 [.VAR var1[=value],var2[=value]... (.BYTE|.WORD|.LONG|.DWORD)](#var)<br>
 [.ZPVAR var1, var2... (.BYTE|.WORD|.LONG|.DWORD)](#zpvar)<br>

 [.END](#end)

 [.EN](#en)

 [.BYTE](#byte)<br>
 [.WORD](#byte)<br>
 [.LONG](#byte)<br>
 [.DWORD](#byte)<br>

 [.OR](#or_and)<br>
 [.AND](#or_and)<br>
 [.XOR](#or_and)<br>
 [.NOT](#or_and)<br>

 [.LO (expression)](#lohi)<br>
 [.HI (expression)](#lohi)<br>

 [.DBYTE words](#dbyte)<br>
 [.DS expression](#_ds)<br>

 [.BY [+byte] bytes and/or ASCII](#_by)<br>
 [.WO words](#_wo)<br>
 [.HE hex bytes](#_he)<br>
 [.SB [+byte] bytes and/or ASCII](#_sb)<br>
 [.CB [+byte] bytes and/or ASCII](#_cb)<br>
 [.FL floating point numbers](#_fl)<br>

 [.ADR label](#adr)

 [.LEN label ['filename']](#sizeof)<br>
 [.SIZEOF label](#sizeof)<br>
 [.FILESIZE 'filename'](#sizeof)<br>

 [.FILEEXISTS 'filename'](#fileexists)<br>

 [.GET [index] 'filename'["filename"][*][+-value][,+-ofset[,length]]](#get)<br>
 [.WGET [index]](#get)<br>
 [.LGET [index]](#get)<br>
 [.DGET [index]](#get)<br>
 [.PUT [index] = value](#put)<br>
 [.SAV [index] ['filename',] length](#sav)<br>


<a name="symbol"></a>
### .SYMBOL label
Dyrektywa `.SYMBOL` to odpowiednik pseudo rozkazu `SMB` z tą różnicą że nie trzeba podawać symbolu, symbolem jest etykieta label. Dyrektywę `.SYMBOL` można umieszczać w dowolnym miejscu bloku relokowalnego **SDX** (`BLK RELOC`) w przeciwieństwie do `SMB`.

Jeśli wystąpiła dyrektywa `.SYMBOL` zostanie wygenerowany odpowiedni blok aktualizacji:

```
BLK UPDATE NEW LABEL 'LABEL'
```

Więcej na temat deklaracji symboli SDX w rozdziale [Definiowanie symbolu SMB](#smb).


<a name="align"></a>
### .ALIGN N [,fill]
Dyrektywa `.ALIGN` pozwala wyrównać adres asemblacji do zadanej wartości `N`, oraz potencjalnie wypełnić pamięć zadaną wartością `FILL`. Możliwe jest wyrównanie adresu asemblacji dla kodu relokowalnego pod warunkiem że podamy wartość wypełnienia pamięci `FILL`.

Domyślne wartości to: `N=$0100`, `FILL=0`.

```
 .align

 .align $400

 .align $100,$ff
```

<a name="rept"></a>
### .REPT expression [,parameter1, parameter2, ...]
Dyrektywa `.REPT` jest rozwinięciem `:repeat` z tą różnicą, że nie jest powtarzana jedna linia, tylko zaznaczony blok programu. Początek bloku definiowany jest dyrektywą `.REPT`, po niej musi wystąpić wartość lub wyrażenie arytmetyczne określające liczbę powtórzeń z zakresu <0..2147483647>, po liczbie powtórzeń opcjonalnie mogą wystąpić parametry. W przeciwieństwie do makr parametry dla `.REPT` zawsze są najpierw obliczane i dopiero ich wynik jest podstawiany (tą właściwość można wykorzystać do definiowania nowych etykiet). Z parametrów w bloku `.REPT` korzystamy podobnie jak z parametrów w bloku `.MACRO`. Koniec bloku `.REPT` definiuje dyrektywa `.ENDR`, przed którą nie powinna znajdować się żadna etykieta.

Dodatkowo w obszarze bloku oznaczonego przez `.REPT` i `.ENDR` mamy możliwość skorzystania ze znaku hash `#` (lub dyrektywy `.R`), który zwraca aktualną wartość licznika pętli `.REPT` (podobnie jak dla `:repeat`).

```
 .rept 12, #*2, #*3        ; bloki .REPT możemy łączyć z :rept
 :+4 dta :1                ; :+4 aby odróżnić licznik powtórzeń od parametru :4
 :+4 dta :2
 .endr

 .rept 9, #                ; definiujemy 9 etykiet label0..label8
label:1 mva #0 $d012+#
 .endr
```

<a name="pages"></a>
### .PAGES [expression]
Dyrektywa `.PAGES` pozwala określić liczbę stron pamięci w których powinien zmieścić się nasz fragment kodu ograniczony przez `<.PAGES .. .ENDPG>` (domyślnie jest to wartość 1). Jeśli kod programu przekroczy zadeklarowaną liczbę stron pamięci wówczas zostanie wygenerowany komunikat błędu _**Page error at ????**_.

Dyrektywy te mogą nam pomóc gdy zależy nam aby fragment programu mieścił się w granicach jednej strony pamięci albo gdy piszemy program mieszczący się w dodatkowym banku pamięci (64 strony pamięci), np.:

```
 org $4000

 .pages $40
  ...
  ...
 .endpg
```

<a name="seg"></a>
### .SEGDEF label address length [attrib] [bank]
### .SEGMENT label
### .ENDSEG

Dyrektywa `.SEGDEF` definiuje nowy segment LABEL o adresie początkowym `ADDRESS` i długości `LENGTH`, dodatkowo możliwe jest określenie atrybutu dla segmentu (R-read, W-rite, RW-ReadWrite - domyślnie) oraz przypisanie numeru wirtualnego banku BANK (domyślnie BANK=0).

Dyrektywa `.SEGMENT` aktywuje zapis kodu wynikowego segmentu `LABEL`. W przypadku przekroczenia zadanej długości segmentu zostanie wygenerowany komunikat błędu _**Segment LABEL error at ADDRESS**_.

Dyrektywa `.ENDSEG` kończy zapis do aktualnego segmentu, przywraca zapis do głównego bloku programu.

```
	.segdef sdata adr0 $100
	.segdef test  adr1 $40

	org $2000

	nop

	.cb 'ALA'

	.segment sdata

	nop

	.endseg

	lda #0

	.segment test
	ldx #0
	clc

	dta c'ATARI'

	.endseg

adr0	.ds $100
adr1	.ds $40
```

### .END
Dyrektywa `.END` może być zamiennie używana z dyrektywami `.ENDP`, `.ENDM`, `.ENDS`, `.ENDA`, `.ENDL`, `.ENDR`, `.ENDPG`, `.ENDW`, `.ENDT`


<a name="var"></a>
### .VAR var1[=value1],var2[=value2]... (.BYTE|.WORD|.LONG|.DWORD) [=address]
Dyrektywa `.VAR` służy do deklaracji i inicjacji zmiennych w głównym bloku programu oraz w blokach `.PROC` i `.LOCAL`. **MADS** nie wykorzystuje informacji na temat takich zmiennych w dalszych operacjach z udziałem pseudo i makro rozkazów. Dopuszczalne typy zmiennych to `.BYTE`, `.WORD`, `.LONG`, `.DWORD` i ich wielokrotności, a także typy zadeklarowane przez `.STRUCT` i `.ENUM` np.:

```
 .var a,b , c,d   .word          ; 4 zmienne typu .WORD
 .var a,b,f  :256 .byte          ; 3 zmienne każda o wielkości 256 bajtów
 .var c=5,d=2,f=$123344 .dword   ; 3 zmienne .DWORD o wartościach 5, 2, $123344

 .var .byte i=1, j=3             ; 2 zmienne typu .BYTE o wartościach 1, 3

 .var a,b,c,d .byte = $a000      ; 4 zmienne typu .BYTE o adresach kolejno $A000, $A001, $A002, $A003

 .var .byte a,b,c,d = $a0        ; 4 zmienne typu bajt, ostatnia zmiennna 'D' o wartości $A0
                                 ; !!! dla takiego zapisu nie ma możliwości określenia adresu alokacji zmiennych

  .proc name
  .var .word p1,p2,p3            ; deklaracja trzech zmiennych typu .WORD
  .endp

 .local
  .var a,b,c .byte
  lda a
  ldx b
  ldy c
 .endl

 .struct Point                   ; nowy typ danych strukturalnych POINT
 x .byte
 y .byte
 .ends

  .var a,b Point                 ; deklaracja zmiennych strukturalnych
  .var Point c,d                 ; odpowiednik składni 'label DTA POINT'
```

Tak zadeklarowane zmienne zostaną fizycznie alokowane dopiero na końcu bloku w którym zostały zadeklarowane, po dyrektywie `.ENDP`, `.ENDL` (`.END`). Wyjątek stanowi blok `.PROC` gdzie zmienne zadeklarowane przez `.VAR` zawsze alokowane są przed dyrektywą `.ENDP` niezależnie czy w bloku procedury wystąpiły jakiekolwiek dodatkowe bloki `.LOCAL` ze zmiennymi deklarowanymi przez `.VAR`


<a name="zpvar"></a>
### .ZPVAR var1, var2... (.BYTE|.WORD|.LONG|.DWORD) [=address]
Dyrektywa `.ZPVAR` służy do deklaracji zmiennych strony zerowej w głównym bloku programu oraz w blokach `.PROC` i `.LOCAL`. Próba przypisania wartości (zaincjowania) takiej zmiennej spowoduje wygenerowanie komunikatu ostrzeżenia _**Uninitialized variable**_. **MADS** nie wykorzystuje informacji na temat takich zmiennych w dalszych operacjach z udziałem pseudo i makro rozkazów. Dopuszczalne typy zmiennych to `.BYTE`, `.WORD`, `.LONG`, `.DWORD` i ich wielokrotności, a także typy zadeklarowane przez `.STRUCT` i `.ENUM` np.:

```
 .zpvar a b c d  .word = $80    ; 4 zmienne typu .WORD o adresie początkowym $0080
 .zpvar i j .byte               ; dwie kolejne zmienne od adresu $0080+8

 .zpvar .word a,b               ; 2 zmienne typu .WORD
                                ; !!! dla takiej składni nie ma możliwości określenia adresu zmiennych

 .struct Point                  ; nowy typ danych strukturalnych POINT
 x .byte
 y .byte
 .ends

  .zpvar a,b Point              ; deklaracja zmiennych strukturalnych
  .zpvar Point c,d              ; odpowiednik składni 'label DTA POINT'
```

Tak zadeklarowanym zmiennym strony zerowej zostaną przypisane adresy dopiero na końcu bloku w którym zostały zadeklarowane, po dyrektywie `.ENDP`, `.ENDL` (`.END`). Wyjątek stanowi blok `.PROC` gdzie zmiennym zadeklarowanym przez `.ZPVAR` adresy przypisywane są przed dyrektywą `.ENDP` niezależnie czy w bloku procedury wystąpiły jakiekolwiek dodatkowe bloki `.LOCAL` ze zmiennymi deklarowanymi przez `.ZPVAR`.

Przy pierwszym użyciu dyrektywy `.ZPVAR` należy zaincjować adres jaki będzie przypisywany kolejnym zmiennym (domyślnym adresem jest $0080).

```
 .zpvar = $40
```

Z każdą kolejną zmienną adres ten jest automatycznie zwiększany przez **MADS**-a, w przypadku gdy adresy zmiennych powtórzą się zostanie wygenerowany komunikat ostrzeżenia _**Access violations at address $xxxx**_. W przypadku przekroczenia zakresu strony zerowej zostaje wygenerowany komunikat błędu _**Value out of range**_.


<a name="print"></a>
### .PRINT [.ECHO]
Powoduje wypisanie na ekranie podanej jako parametr wartości wyrażenia lub ciągu znakowego ograniczonego apostrofami `' '` lub `" "`, np.:

```
 .print "End: ",*,'..',$8000-*
 .echo "End: ",*,'..',$8000-*
```

<a name="error"></a>
### .ERROR [ERT] 'string'["string"] | .ERROR [ERT] expression

Dyrektywa `.ERROR` i pseudo rozkaz `ERT` mają to samo znaczenie. Zatrzymują asemblację programu oraz wyświetlają komunikat podany jako parametr, ograniczony apostrofami `' '` lub `" "`. Jeśli parametrem jest wyrażenie logiczne, wówczas asemblacja zostanie zatrzymana gdy wartość wyrażenia logicznego jest prawdą (komunikat _**User error**_), np.:

```
 ert "halt"            ; ERROR: halt
 .error "halt"

 ert *>$7fff           ; ERROR: User error
 .error *>$7fff
```

<a name="byte"></a>
### .BYTE, .WORD, .LONG, .DWORD
W/w dyrektywy służą do oznaczenia dopuszczalnych typów parametrów w deklaracji parametrów procedury (`.BYTE`, `.WORD`, `.LONG`, `.DWORD`). Możliwe jest także ich użycie w celu definicji danych, w zastępstwie pseudo rozkazu `DTA`.

```
.proc test (.word tmp,a,b .byte value)

 .byte "atari",5,22
 .word 12,$FFFF
 .long $34518F
 .dword $11223344
```

<a name="dbyte"></a>
### .DBYTE
Definicja danych typu `WORD` w odwrotnej kolejności tzn. najpierw starszy bajt, następnie młodszy bajt.

```
.DBYTE $1234,-1,1     ; 12 34 FF FF 00 01
```

<a name="_ds"></a>
### [label] .DS expression | label .DS [elements0][elements1][...] .type

Ta dyrektywa zapożyczona została z **MAC'65**, pozwala zarezerwować pamięć bez jej uprzedniej inicjalizacji. Jest to odpowiednik pseudo rozkazu `ORG *+expression`. Dyrektywy `.DS` nie można używać w kodzie relokowalnym podobnie jak `ORG`-a.
Użycie nawiasów kwadratowych w wyrażeniu umożliwia rezerwowanie pamięci jako tablicy, podobnie jak `.ARRAY`, wymagane jest wówczas podanie etykiety. Użycie dyrektywy `.DS` w bloku relokowalnym **Sparta DOS X** wymusi utworzenie bloku pustego `blk empty`.

purpose: reserves space for data without initializing then space to any particular value(s).

```
usage: [label] .DS expression
       label .DS [elements0][elements1][...] .TYPE
```

Using `.DS expression` is exactly equivalent of using `ORG *+expression`. That is, the label (if it is given) is set equal to the current value of the location counter. Then then value of the expression is added to then location counter.

```
         BUFFERLEN .DS 1     ;reserve a single byte
         BUFFER   .DS [256]  ;reserve 256 bytes as array [0..255]
```

<a name="_by"></a>
### .BY [+byte] bytes and/or ASCII
Store byte values in memory. *ASCII* strings can be specified by enclosing the string in either single or double quotes.

If the first character of the operand field is a `+`, then the following byte will be used as a constant and added to all remaining bytes of the instruction.

```
      .BY +$80 1 10 $10 'Hello' $9B

will generate:
        81 8A 90 C8 E5 EC EC EF 1B
```

Values in `.BY` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


<a name="_wo"></a>
### .WO words
Stores words in memory. Multiple words can be entered.

Values in `.WO` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


<a name="_he"></a>
### .HE hex bytes
Store hex bytes in memory. This is a convenient method to enter strings of hex bytes, since it does not require the use of the '$' character. The bytes are still separated by spaces however, which I feel makes a much more readable layout than the 'all run together' form of hex statement that some other assemblers use.

```
   .HE 0 55 AA FF
```

Values in `.HE` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


<a name="_sb"></a>
### .SB [+byte] bytes and/or ASCII
This is in the same format as the .BY pseudo-op, except that it will convert all bytes into *ATASCII* screen codes before storing them. The *ATASCII* conversion is done before any constant is added with the '+' modifier.

Values in `.SB` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


<a name="_cb"></a>
### .CB [+byte] bytes and/or ASCII
This is in the same format as the `.BY` pseudo-op, except that the last character on the line will be EOR'ed with $80.

Values in `.CB` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


<a name="_fl"></a>
### .FL floating point numbers
Stores 6-byte *BCD* floating point numbers for use with the *OS FP ROM* routines.

Values in `.FL` statements may also be separated with commas for compatibility with other assemblers. Spaces are allowed since they are easier to type.


### .EN
Dyrektywa `.EN` jest odpowiednikiem pseudo rozkazu `END`, oznacza koniec asemblowanego bloku programu.

This is an optional pseudo-op to mark the end of assembly. It can be placed before the end of your source file to prevent a portion of it from being assembled.


<a name="adr"></a>
### .ADR label
Dyrektywa `.ADR` zwraca wartość etykiety `LABEL` przed zmianą adresu asemblacji (możliwe jest umieszczenie nazwy etykiety `LABEL` pomiędzy nawiasami okrągłymi lub kwadratowymi), np.:

```
 org $2000

.proc tb,$1000
tmp lda #0
.endp

 lda .adr tb.tmp  ; = $2000
 lda tb.tmp       ; = $1000
```

<a name="sizeof"></a>
### .LEN label ['filename'], .SIZEOF label, .FILESIZE 'filename'
Dyrektywa `.LEN` zwraca długość (wyrażoną w bajtach) bloku `.PROC`, `.ARRAY`, `.LOCAL`, `.STRUCT` lub długość pliku o nazwie `'filename'`. Etykieta `LABEL` to nazwa bloku `.PROC`, `.ARRAY`, `.LOCAL` lub `.STRUCT` (możliwe jest umieszczenie nazwy etykiety `LABEL` pomiędzy nawiasami okrągłymi lub kwadratowymi), np.:

```
label .array [255] .dword
      .enda

      dta a(.len label)   ; = $400

.proc wait
 lda:cmp:req 20
 rts
.endp

 dta .sizeof wait    ; = 7
```

Dyrektywy `.SIZEOF` i `.FILESIZE` to alternatywne nazwy dla `.LEN`, można używać ich zamiennie zależnie od upodobań programującego.


<a name="fileexists"></a>
### .FILEEXISTS 'filename'
Dyrektywa `.FILEEXISTS` zwraca `'1'` gdy plik `'filename'` istnieje w przeciwnym wypadku zwraca wartość `'0'` np.:

```
 ift .fileexists 'filename'
   .print 'true'
  els
   .print 'false'
  eif
```

<a name="define"></a>
### .DEFINE macro_name expression
Dyrektywa `.DEFINE` pozwala zdefiniować jedno-liniowe makro `MACRO_NAME`. Dopuszczalnych jest dziewięć parametrów `%%1.%%9` (`:1..:9`) reprezentowanych w ten sam sposób jak dla makr `.MACRO`, poprzez znaki `%%` lub znak `:`. Nazwy literowe parametrów nie są akceptowane, nie ma możliwości użycia znaku podziału linii `\`.

```
 .define poke mva #%%2 %%1

 poke(712, 100)
```

Makro jedno-liniowe `.DEFINE` można wielokrotnie definiować w trakcie jednego przebiegu asemblacji.

```
 .define pisz %%1+%%2

 .print pisz(712, 100)

 .define pisz %%1-%%2

 .print pisz(712, 100)
```

<a name="undef"></a>
### .UNDEF macro_name
Dyrektywa `.UNDEF` usuwa definicję jedno-liniowego makra `MACRO_NAME`.

```
 .define poke mva #%%2 %%1

 .undef poke
```

<a name="def"></a>
### .DEF label [= expression]
Dyrektywa `.DEF` pozwala sprawdzić obecność definicji etykiety `LABEL` lub ją zdefiniować. Jeśli etykieta została zdefiniowana zwraca wartość `1` czyli `TRUE`, w przeciwnym wypadku zwraca `0` czyli `FALSE`. Możliwe jest umieszczenie nazwy etykiety `LABEL` pomiędzy nawiasami okrągłymi lub kwadratowymi, np.:

```
 ift .not(.def label)
 .def label
 eif
```

Definiowane etykiety są zasięgu aktualnego obszaru lokalnego, jeśli chcemy zdefiniować etykiety globalne stawiamy przed etykietą znak `:`, np.

```
.local test
 :10 .def :label%%1
.endl
```

This unary operator tests whether the following label has been defined yet, returning TRUE or FALSE as appropriate.

> _CAUTION:_
> _Defining a label AFTER the use of a .DEF which references it can be dangerous, particularly if the .DEF is used in a .IF directive._


<a name="ifdef"></a>
### .IFDEF label
Dyrektywa `.IFDEF` jest krótszym odpowiednikiem warunku `.IF .DEF LABEL`

```
.ifdef label
       jsr proc1
.else
       jsr proc2
.endif
```

<a name="ifndef"></a>
### .IFNDEF label
Dyrektywa `.IFNDEF` jest krótszym odpowiednikiem warunku `.IF .NOT .DEF LABEL`

```
.ifndef label
      clc
.else
      sec
.endif
```

Dla n/w przykładu asemblacja bloku `.IFNDEF` (`.IF`) będzie miała miejsce tylko w pierwszym przebiegu, jeśli umieścimy w takim bloku jakikolwiek kod programu na pewno nie zostanie on wygenerowany do pliku, definicje etykiet zostaną przeprowadzone tylko w pierwszym przebiegu, jeśli wystąpiły jakiekolwiek błędy związane z ich definiowaniem dowiemy się o nich dopiero w momencie próby odwołania do takich etykiet, będzie to komunikat błędu _**Undeclared label LABEL_NAME**_

```
 .ifndef label
 .def label
 lda #0               ; ten rozkaz nie zostanie zasemblowany, tylko ostatni przebieg asemblacji generuje kod
 temp = 100           ; etykieta TEMP zostanie zdefiniowana tylko w 1 przebiegu asemblacji
 .endif
```

<a name="nowarn"></a>
### .NOWARN
Dyrektywa `.NOWARN` wyłącza komunikat ostrzeżenia dla aktualnie asemblowanego wiersza programu.

```
.nowarn .proc temp       ; nie zostanie wygenerowane ostrzeżenie 'Unreferenced procedure TEMP'
        .endp
```

<a name="using"></a>
### .USING, [.USE]
Dyrektywa `.USING` (`.USE`) pozwala określić dodatkową ścieżkę poszukiwań dla nazw etykiet. Działanie `.USING` (`.USE`) obowiązuje w aktualnej przestrzeni nazw jak i kolejnych zawierających się w tej przestrzeni.

```
.local move

tmp    lda #0
hlp    sta $a000

.local move2

tmp2   ldx #0
hlp2   stx $b000

.endl

.endl

.local main

.use move.move2

       lda tmp2

.use move

       lda tmp

.endl
```

<a name="get"></a>
### .GET [index] 'filename'... [.BYTE, .WORD, .LONG, .DWORD]
### .WGET [index] | .LGET [index] | .DGET [index]

`.GET` jest odpowiednikiem pseudo rozkazu `INS` (podobna składnia), z tą różnicą że plik nie jest dołączany do asemblowanego pliku tylko ładowany do pamięci **MADS**-a. Ta dyrektywa pozwala wczytać określony plik do pamięci **MADS**-a i odwoływać się do bajtów tego pliku jak do tablicy jednowymiarowej.

```
 .get 'file'                    ; wczytanie pliku do tablicy MADS-a
 .get [5] 'file'                ; wczytanie pliku do tablicy MADS-a od indeksu = 5

 .get 'file',0,3                ; wczytanie do tablicy MADS-a 3-ech wartości

 lda #.get[7]                   ; odczytanie 7 bajtu z tablicy MADS-a
 adres = .get[2]+.get[3]<<8     ; 2 i 3 bajt w nagłówku pliku DOS zawiera informacje o adresie ładowania

 adres = .wget[2]              ; word
 tmp = .lget[5]                ; long
 ?x = .dget[11]                ; dword
```

Przy pomocy dyrektyw `.GET`, `.PUT` można odczytać np moduł **Theta Music Composer** (*TMC*) i dokonać jego relokacji. Realizuje to załączone do **MADS**-a makro z katalogu ../EXAMPLES/MSX/TMC_PLAYER/tmc_relocator.mac.

Dopuszczalny zakres wartości dla `INDEX` = `<0..65535>`. Wartości odczytywane przez `.GET` są typu `BYTE`. Wartości odczytywane przez `.WGET` są typu `WORD`. Wartości odczytywane przez `.LGET` są typu `LONG`. Wartości odczytywane przez `.DGET` są typu `DWORD`.


<a name="put"></a>
### .PUT [index] = value
Dyrektywa `.PUT` pozwala odwołać się do tablicy jednowymiarowej w pamięci **MADS**-a i zapisać w niej wartość typu `BYTE`. Jest to ta sama tablica do której dyrektywa `.GET` zapisuje plik.
Dopuszczalny zakres wartości dla INDEX = <0..65535>.

```
 .put [5] = 12       ; zapisanie wartosci 12 w talicy MADS-a na pozycji 5-ej
```

<a name="sav"></a>
### .SAV [index] ['filename',] length
Dyrektywa `.SAV` pozwala zapisać bufor używany przez dyrektywy `.GET`, `.PUT` do pliku zewnętrznego lub dołączenie do aktualnie asemblowanego.

```
 .sav ?length            ; dołączenie do asemblowanego pliku zawartości bufora [0..?length-1]
 .sav [200] 256          ; dołączenie do asemblowanego pliku zawartości bufora [200..200+256-1]
 .sav [6] 'filename',32  ; zapisanie do pliku FILENAME zawartości bufora [6..6+32-1]
```

Dopuszczalny zakres wartości dla INDEX = <0..65535>.


<a name="or_and"></a>
### .OR, .AND, .XOR, .NOT
W/w dyrektywy to odpowiedniki operatorów logicznych `||` (`.OR`), `&&` (`.AND`), `^` (`.XOR`), `!` (`.NOT`).


<a name="lohi"></a>
### .LO (expression), .HI (expression)
W/w dyrektywy to odpowiedniki operatorów odpowiednio `<` (młodszy bajt) i `>` (starszy bajt).

<a name="if_else"></a>
### .IF, .ELSE, .ELSEIF, .ENDIF

```
 .IF     [IFT] expression
 .ELSE   [ELS]
 .ELSEIF [ELI] expression
 .ENDIF  [EIF]
```

W/w dyrektywy i pseudo rozkazy wpływają na przebieg asemblacji (można ich używać zamiennie), np.:

```
 .IF .NOT .DEF label_name
   label_name = 1
 .ENDIF

 .IF [.NOT .DEF label_name] .AND [.NOT .DEF label_name2]
   label_name = 1
   label_name2 = 2
 .ENDIF
```

W w/w przykładzie nawiasy (kwadratowe lub okrągłe) są koniecznością, ich brak spowodowałby że dla pierwszej dyrektywy `.DEF` parametrem byłaby nazwa etykiety `label_name.AND.NOT.DEFlabel_name2` (spacje są pomijane, a znak kropki akceptowany w nazwie etykiety).



## Procedury

**MADS** wprowadza nowe możliwości w obsłudze procedur z parametrami. Nowe możliwości upodabniają ten mechanizm do tych znanych z języków wysokiego poziomu i są tak samo łatwe w użyciu dla programisty.

Aktualnie dołączone do **MADS**-a deklaracje makr (`@CALL.MAC`, `@PULL.MAC`, `@EXIT.MAC`) umożliwiają obsługę stosu programowego o wielkości 256 bajtów, czyli tej samej wielkości jak stos sprzętowy, udostępniają mechanizm zdejmowania ze stosu programowego i odkładania na stos programowy parametrów potrzebnych podczas wywoływania procedur, jak i wychodzenia z takich procedur. **MADS** uwzględnia możliwość rekurencji takich procedur.

Programista nie jest zaangażowany w ten mechanizm, może skupić uwagę na swoim programie. Musi tylko pamiętać o potrzebie zdefiniowania odpowiednich etykiet i dołączeniu odpowiednich makr podczas asemblacji programu.

Dodatkowo istnieje możliwość pominięcia "mechanizmu" stosu programowego **MADS**-a i skorzystanie z klasycznego sposobu ich przekazywania, za pomocą rejestrów *CPU* (dyrektywa `.REG`) lub przez zmienne (dyrektywa `.VAR`).

Inną właściwością procedur `.PROC` jest możliwość pominięcia ich podczas asemblacji jeśli nie wystąpiło żadne odwołanie do nich, czyli zostały zdefiniowane ale nie są wykorzystane. Wystąpi wówczas komunikat ostrzeżenia _**Unreferenced procedure ????**_. Pominięcie takiej procedury podczas asemblacji możliwe jest poprzez podanie parametru do **MADS**-a w linii poleceń `-x 'Exclude unreferenced procedures'`.

Wszelkie etykiety zdefiniowane w obszarze procedury `.PROC` są zasięgu lokalnego, można je też określić jako etykiety globalne zdefiniowane lokalnie o dostępie swobodnym, ponieważ można się do nich odwoływać co nie jest normalne w innych językach programowania.

W obszarze procedury `.PROC` istnieje możliwość zdefiniowania etykiet o zasięgu globalnym (patrz rozdział [Etykiety globalne](#globalne)).

Jeśli chcemy dostać się do etykiet zdefiniowanych w procedurze spoza obszaru procedury, wówczas adresujemy z użyciem znaku kropki `.`, np.:

```
 lda test.pole

.proc test

pole nop

.endp
```

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze procedury `.PROC`, wówczas **MADS** będzie poszukiwał ją w obszarze niższym aż dojdzie do obszaru globalnego. Aby odczytać natychmiastowo wartość etykiety globalnej z poziomu procedury `.PROC` (czy też innego obszaru lokalnego) poprzedzamy nazwę etykiety znakiem dwukropka `:`.

**MADS** wymaga dla procedur wykorzystujących stos programowy, trzech globalnych definicji etykiet o konkretnych nazwach (adres stosu, wskaźnik stosu, adres parametrów procedury):

 - @PROC_VARS_ADR
 - @STACK_ADDRESS
 - @STACK_POINTER

Brak definicji w/w etykiet i próba użycia bloku `.PROC` wykorzystującego stos programowy spowoduje że **MADS** przyjmie swoje domyślne wartości tych etykiet: `@PROC_VARS_ADR = $0500`, `@STACK_ADDRESS = $0600`, `@STACK_POINTER = $FE`

**MADS** dla procedur wykorzystujących stos programowy wymaga także deklaracji makr o konkretnych nazwach. Dołączone do **MADS**-a deklaracje tych makr znajdują się w plikach:

 - @CALL    ..\EXAMPLES\MACROS\@CALL.MAC
 - @PUSH    ..\EXAMPLES\MACROS\@CALL.MAC
 - @PULL    ..\EXAMPLES\MACROS\@PULL.MAC
 - @EXIT    ..\EXAMPLES\MACROS\@EXIT.MAC

W/w makra realizują przekazywanie i odkładanie na programowy stos parametrów, oraz zdejmowanie i odkładanie parametrów dla procedur wykorzystujących stos programowy i wywoływanych z poziomu innych procedur wykorzystujących stos programowy.


### Deklaracja procedury

Procedur dotyczą n/w dyrektywy:

```
 name .PROC [(.TYPE PAR1 .TYPE PAR2 ...)] [.REG] [.VAR]
 .PROC name [,address] [(.TYPE PAR1 .TYPE PAR2 ...)] [.REG] [.VAR]
 .ENDP [.PEND] [.END]
```

#### name .PROC [(.TYPE Par1,Par2 .TYPE Par3 ...)] [.REG] [.VAR]

Deklaracja procedury name przy użyciu dyrektywy `.PROC`. Nazwa procedury jest wymagana i konieczna, jej brak wygeneruje błąd. Do nazw procedur nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem _**Reserved word**_.

Jeśli chcemy wykorzystać jeden z mechanizmów **MADS**-a do przekazywania parametrów do procedur, musimy je wcześniej zadeklarować. Deklaracja parametrów procedury mieści się pomiędzy nawiasami okrągłymi `( )`. Dostępne są cztery typy parametrów:

 - .BYTE  (8-bit)  relokowalne
 - .WORD  (16-bit) relokowalne
 - .LONG  (24-bit) nierelokowalne
 - .DWORD (32-bit) nierelokowalne

> _W obecnej wersji **MADS**-a nie ma możliwości przekazywania parametrów za pomocą struktur `.STRUCT`._

Bezpośrednio po deklaracji typu, oddzielona minimum jedną spacją, następuje nazwa parametru. Jeśli deklarujemy więcej parametrów tego samego typu możemy rozdzielić ich nazwy znakiem przecinka ','.

Przykład deklaracji procedury wykorzystującej stos programowy:

```
name .PROC ( .WORD par1 .BYTE par2 )
name .PROC ( .BYTE par1,par2 .LONG par3 )
name .PROC ( .DWORD p1,p2,p3,p4,p5,p6,p7,p8 )
```

Dodatkowo używając dyrektyw `.REG` lub `.VAR` mamy możliwość określenia sposobu i metody przekazywania parametrów do procedur **MADS**-a. Przez rejestry *CPU* (`.REG`) lub przez zmienne (`.VAR`). Dyrektywy określające sposób przekazywania parametrów umieszczamy na końcu naszej deklaracji procedury `.PROC`

Przykład deklaracji procedury wykorzystującej rejestry *CPU*:

```
name .PROC ( .BYTE x,y,a ) .REG
name .PROC ( .WORD xa .BYTE y ) .REG
name .PROC ( .LONG axy ) .REG
```

Dyrektywa `.REG` wymaga aby nazwy parametrów składały się z liter `A`, `X`, `Y` lub ich kombinacji. Litery te odpowiadają nazwom rejestrów *CPU* i wpływają na kolejność użycia rejestrów. Ograniczeniem w liczbie przekazywanych parametrów jest ilość rejestrów *CPU*, przez co możemy przekazać do procedury w sumie maksimum 3 bajty. Zaletą takiego sposobu jest natomiast szybkość i małe zużycie pamięci *RAM*.

Przykład deklaracji procedury wykorzystującej zmienne:

```
name .PROC ( .BYTE x1,x2,y1,y2 ) .VAR
name .PROC ( .WORD inputPointer, outputPointer ) .VAR
name .PROC ( .WORD src+1, dst+1 ) .VAR
```

Dla `.VAR` nazwy parametrów wskazują nazwy zmiennych do których będą ładowane przekazywane parametry. Metoda ta jest wolniejsza od `.REG` jednak nadal szybsza od metody ze stosem programowym.

Procedurę opuszczamy w standardowy sposób, czyli przy pomocy rozkazu `RTS`. Dodanie rozkazu `RTS` w ciele procedury przy wyjściu z każdej ścieżki jest obowiązkiem programującego, a nie assemblera.

Podobnie jak w przypadku bloku `.LOCAL` mamy możliwość określenia nowego adresu asemblacji dla bloku `.PROC`, np.:

```
.PROC label,$8000
.ENDP

.PROC label2,$a000 (.word ax) .reg
.ENDP
```

W przypadku procedur wykorzystujących stos programowy po zakończeniu procedury przez `.ENDP` **MADS** wywołuje makro `@EXIT`, którego zadaniem jest modyfikacja wskaźnika stosu programowego `@STACK_POINTER`, jest to konieczne dla prawidłowego działania stosu programowego. Użytkownik może sam zaprojektować swoje makro `@EXIT`, albo skorzystać z dołączonego do **MADS**-a (plik ..\EXAMPLES\MACROS\@EXIT.MAC), ma ono obecnie następującą postać:

```
.macro @EXIT

 ift :1<>0

  ift :1=1
   dec @stack_pointer

  eli :1=2
   dec @stack_pointer
   dec @stack_pointer

  els
   pha
   lda @stack_pointer
   sub #:1
   sta @stack_pointer
   pla

  eif

 eif

.endm
```

Makro `@EXIT` nie powinno zmieniać zawartości rejestrów *CPU* jeśli chcemy zachować możliwość zwrócenie wyniku działania procedury `.PROC` poprzez rejestry *CPU*.

#### .ENDP

Dyrektywa `.ENDP` kończy deklarację bloku procedury.


### Wywołanie procedury

Procedurę wywołujemy poprzez jej nazwę (identycznie jak makro), po niej mogą wystąpić parametry, rozdzielone separatorem w postaci znaku przecinka `,` lub spacji `' '` (nie ma możliwości zadeklarowania innych separatorów).

Jeśli typ parametru nie będzie zgadzał się z typem zadeklarowanym w deklaracji procedury wystąpi komunikat błędu _**Incompatible types**_.

Jeśli przekazana liczba parametrów różni się od liczby zadeklarowanych parametrów w deklaracji procedury to wystąpi komunikat błędu _**Improper number of actual parameters**_. Wyjątkiem jest procedura do której parametry przekazywane są przez rejestry *CPU* (`.REG`) lub zmienne (`.VAR`), w takich przypadkach możemy pominąć parametry, w domyśle są one już załadowane do odpowiednich rejestrów czy też zmiennych.

Możliwe są trzy sposoby przekazania parametru:

- '#' przez wartość
- ' ' przez wartość spod adresu (bez znaku poprzedzającego)
- '@' przez akumulator (parametry typu .BYTE)
- "string" przez ciąg znakowy, np. "label,x"

Przykład wywołania procedury:

```
 name @ , #$166 , $A400  ; dla stosu programowego
 name , @ , #$3f         ; dla .REG lub .VAR
 name "(hlp),y" "tab,y"	 ; dla .VAR lub dla stosu programowego (stos programowy korzysta z regX)
```

**MADS** po napotkaniu wywołania procedury, która korzysta ze stosu programowego wymusza wykonanie makra `@CALL`. Jeśli jednak procedura nie korzysta ze stosu programowego, zamiast makra `@CALL` zostanie wygenerowany zwykły rozkaz `JSR PROCEDURE`.

Do makra `@CALL` **MADS** przekazuje parametry wyliczone na podstawie deklaracji procedury (rozbija każdy parametr na trzy składowe: tryb adresacji, typ parametru, wartość parametru).

```
@CALL_INIT 3\ @PUSH_INIT 3\ @CALL '@','B',0\ @CALL '#','W',358\ @CALL ' ',W,"$A400"\ @CALL_END PROC_NAME
```

Makro `@CALL` odłoży na stos zawartość akumulatora, następnie wartość $166 (358 dec), następnie wartość spod adresu $A400. Więcej informacji na temat sposobu przekazywania parametrów do makr (znaczenia apostrofów `' '` i `" "`) w rozdziale [Wywołanie makra](../skladnia/#wywoanie-makra).

Parametr przekazywany przez akumulator `@` powinien być zawsze pierwszym parametrem przekazywanym do procedury, jeśli wystąpi w innym miejscu zawartość akumulatora zostanie zmodyfikowana (domyślne makro `@CALL` nakłada takie ograniczenie). Oczywiście użytkownik może to zmienić pisząc swoją wersję makra `@CALL`. W przypadku procedur `.REG` lub `.VAR` kolejność wystąpienia parametru `@` nie ma znaczenia.

Wyjście z procedury `.PROC` następuje poprzez rozkaz `RTS`. Po powrocie z procedury **MADS** wywołuje makro `@EXIT` które zawiera program modyfikujący wartość wskaźnika stosu `@STACK_POINTER`, jest to niezbędne w celu prawidłowego działania stosu programowego. Od wskaźnika stosu odejmowana jest liczba bajtów które zostały przekazane do procedury, liczba bajtów przekazywana jest do makra jako parametr.

Dodanie rozkazu `RTS` w ciele procedury przy wyjściu z każdej ścieżki jest obowiązkiem programującego, a nie assemblera.


### Parametry procedury

Odwołania do parametrów procedury z poziomu procedury nie wymagają dodatkowych operacji ze strony programisty, np.:

```
@stack_address equ $400
@stack_pointer equ $ff
@proc_vars_adr equ $80

name .PROC (.WORD par1,par2)

 lda par1
 clc
 adc par2
 sta par1

 lda par1+1
 adc par2+1
 sta par1+1

.endp

 icl '@call.mac'
 icl '@pull.mac'
 icl '@exit.mac'
```

**MADS** w momencie napotkania deklaracji `.PROC` z parametrami, dokonuje automatycznej definicji tych parametrów przypisując im wartości na podstawie `@PROC_VARS_ADR`. W w/w przykładzie **MADS** dokona automatycznej definicji parametrów `PAR1 = @PROC_VARS_ADR`, `PAR2 = @PROC_VARS_ADR + 2`.

Programista odwołuje się do tych parametrów po nazwie jaka została im nadana w deklaracji procedury, czyli podobnie jak ma to miejsce w językach wyższego poziomu. W **MADS** istnieje możliwość dostępu do parametrów procedury spoza procedury co nie jest już normalne w językach wyższego poziomu. Możemy odczytać z w/w przykładu zawartość `PAR1`, np.:

```
 lda name.par1
 sta $a000
 lda name.par1+1
 sta $a000+1
```

Wartość `PAR1` została przepisane pod adres $A000, wartość PAR1+1 pod adres $A000+1. Oczywiście możemy tego dokonać tylko bezpośrednio po zakończeniu tej konkretnej procedury. Trzeba pamiętać że parametry takich procedur odkładane są pod wspólnym adresem `@PROC_VARS_ADR`, więc z każdym nowym wywołaniem procedury wykorzystującej stos programowy zawartość obszaru `<@PROC_VARS_ADR .. @PROC_VARS_ADR + $FF>` ulega zmianom.

Jeśli procedura ma zadeklarowane parametry typu `.REG` programista powinien zatroszczyć się o to aby je zapamiętać czy też właściwie wykorzystać zanim zostaną zmodyfikowane przez kod procedury. W przypadku parametrów typu `.VAR` nie trzeba się o nic martwić ponieważ parametry zostały zapisane do konkretnych komórek pamięci skąd zawsze możemy je odczytać.

