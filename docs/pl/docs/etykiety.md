## Etykiety

 Etykiety zdefiniowane w programie mogą posiadać zasięg lokalny lub globalny, w zależności od miejsca w jakim zostały zdefiniowane. Oprócz tego można zdefiniować etykiety tymczasowe, które także mogą posiadać zasięg lokalny lub globalny.

* zasięg globalny etykiety oznacza, że jest ona widoczna z każdego miejsca w programie, niezależnie czy jest to makro `.MACRO`, procedura `.PROC` czy obszar lokalny `.LOCAL`.

* zasięg lokalny etykiety oznacza, że jest ona widoczna tylko w konkretnie zdefiniowanym obszarze, np. przez dyrektywy: `.MACRO`, `.PROC`, `.LOCAL`.

* etykiety muszą zaczynać się znakiem `'A'..'Z','a'..'z','_','?','@'`
* pozostałe dopuszczalne znaki etykiety to `'A'..'Z','a'..'z','0'..'9','_','?','@'`
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

#### ?label

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

#### label SET value

Pseudorozkaz [SET](#set) umożliwia redefinicję etykiety `LABEL`, działa ze zwykłymi etykietami tzn. takimi które nie mają pierwszego znaku w nazwie `?`. Etykiet zdefiniowanych przez `SET` nie można później definiować inaczej niż przez `SET`.

```
 tmp set 1

 tmp = 2
```

Dla w/w przykładu powstanie nieskończona pętla **Infinite loop**, prawidłowo powinno być :

```
 tmp set 1

 tmp set 2
```


### Automodyfikacji

Etykieta dłuższa niż 1 znak, umieszczona po mnemoniku i zakończona znakiem `:` definiuje adres automodyfikacji kodu.

```
  lda label:#$00

  add plus:#$00

  lda src:$ff00,y
  sta dst:$ff00,y
```

W/w przykłady są odpowiednikiem kodu:

```
  lda #$00
label equ *-1

  add #$00
plus equ *-1

  lda $ff00,y
src equ *-2

  sta $ff00,y
dst equ *-2
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
