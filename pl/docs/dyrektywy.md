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


