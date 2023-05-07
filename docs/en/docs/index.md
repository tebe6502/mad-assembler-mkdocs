# Mad-Assembler

**Mad-Assembler (MADS)** is a MOS 6502/MOS 65C02/WDC 65816 cross-assembler by [Tomazs Biela (tebe)](https://github.com/tebe6502).

The latest releases for Windows is available on [Github](https://github.com/tebe6502/Mad-Assembler/releases). Releases for other operating systems platform are published periodically as part of the [WUDSN IDE Tools](https://github.com/peterdell/wudsn-ide-tools/tree/main/ASM/MADS).

# Change Log

## [2.1.5](https://github.com/tebe6502/Mad-Assembler/releases/tag/2.1.5)  <a name="2.1.5"></a> 

- fixed implementation of `.UNDEF` and `.IFDEF`
- fixed implementation of nested `.REPT` loops
- added ability to combine local areas, `.LOCAL +full_path_to_local`
- added coloring of console messages
- added labels for self-modifying code, e.g. `lda label:#$40`

## [2.1.3](https://github.com/tebe6502/Mad-Assembler/releases/tag/2.1.3)  <a name="2.1.3"></a> 

- added directive `.RND` returning a random value in the range 0..255
- added warning message **'Register A is changed'** for pseudo commands `DEW`, `DEL`, `DED`
- added command line option `-bc` for **'Branch condition test'**. It activates warning messages in case the branch target is out of range or exceeds a memory page boundary

## [2.1.0](https://github.com/tebe6502/Mad-Assembler/releases/tag/2.1.0)  <a name="2.1.0"></a> 

- added warning message **'Buggy indirect jump'** when using the command `JMP(ABS)`
- added directive `.FILEEXISTS('filename')` returning 1 if file in specified path exists, 0 if it does not exist
- extended message **'Value out of range (VALUE must be between X and Y)'**

## 2.0.9  <a name="2.0.9"></a> 

- added `.CBM 'text'` directive to define text in Commodore C64 screen code
- fixed an error when a `.PROC` procedure located in a `.LOCAL` block was not marked 'for assembly' even though it was referenced from a `.MACRO` macro in a `.LOCAL` block
- fixed that temporary labels `?label` were marked 'for relocation'

## 2.0.8 <a name="2.0.8"></a> 

- generate shorter object code for `#CYCLE`
- fixes for `.BY` `.WO` `.HE` `.SB` `.CB` `.FL`
- added error message **'Improper syntax'** when using `.BY` `.WO` `.HE` `.SB` `.CB` `.FL` in a `.STRUCT` block
- added directives `.LONGA ON|OFF` `.LONGI ON|OFF` for **WDC 65816** 
- fixed register size tracking for **WDC 65816** when `OPT T+` is set
- added command line option `-fv:value` to set the memory fill value when `OPT F+` is set.
- added option to specify an immediate argument as a string of two characters (previously only 1 character), e.g. `lda #'AB'` , `mwa #'XY' $80`

## 2.0.7 <a name="2.0.7"></a> 

- fixed object code generation for illegal opcodes `DOP` and `SHA`
- added **WDC 65816** directives `.A8` `.A16` `.I8` `.I16` `.AI8` `.IA8` `.AI16` `.IA16` to set the size of `AXY` registers
- added **WDC 65816** directives `.ASIZE` `.ISIZE` returning the current size of `AXY` registers
- in **WDC 65816** mode, the command `JMP` is changed to `JML` only when the jump concerns a different 64KB bank than the current one
<!-- TODO Should be 'Set left margin'-->
- added command line option `-ml:value` for **'margin-left property'** to change the left margin of the generated listing to a value in the range of 32 to 128 characters

## 2.0.6 <a name="2.0.6"></a> 

- fixed parsing of macro parameters used in labels

```
.macro test currentRow, previousRow
    .print Tmp%%currentRowAllowed
    .print Tmp%%previousRowAllowed
.endm
```

- fixed the `.ARRAY` memory allocation in case there is no size specified or it is a multi-dimensional array
- increased number of passes for `.PROC` to prevent that for `xa .reg` the parameter is misinterpreted under certain conditions
- added directive `.DEFINE` to define sinlge-line macros (can be defined multiple times in the same pass)

```
.DEFINE macro_name expression

.DEFINE write .print %%1+%%2
write (5,12)

.DEFINE text .sb
text 'atari'
```

- added directive `.UNDEF macro_name` to remove the definition of the single-line macro `macro_name`.

## 2.0.5 <a name="2.0.5"></a> 

- array definitions with `.ARRAY` in unused `.PROC` block are omitted if the `-x` **Exclude unreferenced procedures** option is specified
- using `.ARRAY` in `.STRUCT` blocks will no longer generate zeros in the resulting file
- added directive `.XGET` to read a file into the **MADS** memory buffer and further modify its bytes provided they are different from zero (useful for **VBXE**)

## 2.0.4 <a name="2.0.4"></a> 

- fixed bug causing incorrect writing of the update block for the high byte of the address in a `.RELOC` block
- removed directives `.DB`  and `.DW`
- added directive `.DBYTE <word>` which stores the bytes of a word in high / low order (MSB/LSB)
- added direcvivs `.WGET` to read **WORD** values, `.LGET` to read **LONG** values and `.DGET` to read **DWORD** values from **MADS** memory buffer
- fixed implementation of `ADW` and `SBW` macro commands, e.g.:

```
adw (tmp),y #1 posx
adw (tmp),y ptr2 ptr4
```

## 2.0.2 <a name="2.0.2"></a>
- fixed data allocation for `.SB [+<byte>],<bytes|string|char>`

## 2.0.1 <a name="2.0.1"></a>

- fixed data allocation for `.ARRAY` when type is larger than `.BYTE`
- directive `.SIZEOF` now also returns the size for built-in types `.BYTE` `.WORD` `.LONG` `.DWORD`
- added relocatable version of **MPT** player `examples_players_player_reloc.asm`
- fixed implementation of `.DS` directive in **SDX** `blk sparta $xxx` blocks that are not relocatable

<!-- TODO Continue from here -->
## 1.9.8 <a name="1.9.8"></a>

- naprawione działanie rozkazów **WDC 65816** `PEA` `PEI` `PER`
- dodana możliwość podania kodu dla `.RELOC` [.BYTE|WORD] [TYPE]

## 1.9.7 <a name="1.9.7"></a>

- dyrektywa `.DEF` definiuje etykiety o zasiegu lokalnym, jeśli poprzedzić ją znakiem `:` to globalne
- poprawki dla liczb zmiennoprzecinkowych .FL, poprawione kodowane zera, dokonywane zaokrąglenie do 10 miejsc po przecinku
- dla bloków **Sparta DOS X** `blk reloc` i `blk empty` dodana możliwość określenia innego typu pamięci niż `$00` (main), `$02` (extended), np.:

```
blk reloc $40
```
- poprawka umożliwiająca użycie dyrektywy `.PRINT` po `blk empty`
- dodana możliwość definiowania wielowymiarowych tablic `.ARRAY`, np.:

```
.array scr [24][40]
  [11][16] = "atari"
.enda

  mva #"!" scr[11][22]
```

- dodana możliwość definiowania tablicy `.ARRAY` poprzez dyrektywę `.DS`, np.:

```
tmp .ds .array [5][12][4] .word
```

- dodana możliwość definiowania tablicy `.ARRAY` poprzez pseudorozkaz `EQU` (=), np.:

```
fnt = $e000 .array [128] [8] .byte
```

- naprawione działanie makrorozkazu `ADW` w połączeniu z makrorozkazem `SCC` itp.
- poprawki dla `.REPT`, m.in. komentarz wieloliniowy `/* */` jest teraz właściwie rozpoznawany

## 1.9.6 <a name="1.9.6"></a>

- poprawione działanie etykiet anonimowych dla mnemoników łączonych znakiem `:`, np.:

```
       ldx #8
@      lda:cmp:req 20
       dex
       bne @-
```

- dodany pseudo rozkaz `COS` (centre,amp,size[,first,last]) generujący wartości dla funkcji cosinus
- dodany komunikat błędu **Improper syntax** w przypadku użycia dyrektywy `.DS` w bloku `.STRUCT`
- naprawione działanie pseudo rozkazu `ORG`, np.:

```
opt h-
ORG [a($ffff),d'atari',c'ble',20,30,40],$8000,$a000
```

- addytywne bloki `.LOCAL` otrzymują kolejne adresy, poprzednio adres ustalany był na podstawie pierwszego wystąpienia takiego bloku
- dodany komunikat ostrzeżenia w przypadku stworzenia kolejnego addytywnego bloku `.LOCAL` o tej samej nazwie **Ambiguous label LOCAL_NAME**
- dodane mnemoniki `PER` (PEA rell), `PEI` (PEA (zp)) dla **WDC 65816**
- dodane nowy typ danych M (najstarszy bajt **LONG**) i G (najstarszy bajt **DWORD**) dla pseudorozkazu `DTA`, np.:

```
dta m($44556677)   ; -> $55
dta g($44556677)   ; -> $44
```

- dyrektywa `.LEN` `.SIZEOF` rozszerzona o obsługę danych alokowanych poprzez `DTA STRUCT_NAME`, np.:

```
.STRUCT free_ptr_struct
  prev .WORD
  next .word
.ENDS

free_ptr_t dta free_ptr_struct [3]

.print .sizeof(free_ptr_t)    ; free_ptr_struct [0..3] = 16 bytes
```

- zmiany dla operacji odczytu plików poprzez `ICL`, `INS` itp. plik do odczytu/zapisu będzie poszukiwany najpierw w ścieżce, która prowadzi do obecnie otwartego pliku, następnie ze ścieżki z której został uruchomiony główny asemblowany plik i na końcu ze ścieżek podanych parametrem -i (additional include directories)
- poprawione rozpoznawanie wielkości znaków gdy aktywowany jest przełącznik `-c` (char sensitive) dla struktur, np.:

```
.struct fcb
sEcbuf  .byte
.ends

data dta fcb [1] (0)

    lda     data[0].sEcbuf
```


- rozszerzone działanie dyrektywy `.REPT` o możliwość jej zagnieżdżania np.:

```
.rept 2,#*2              ;  1 - $0000
                         ;  2 - $0000
.print '1 - ',#          ;  1 - $0001
                         ;  2 - $0000
.rept :1                 ;  2 - $0001
.print '2 - ',.r         ;  2 - $0002
.endr                    ;
                         ;
.endr
```
- krótsza wersja pętli `#WHILE` bez wyrażenia, pętla trwa dopóki `LABEL <> 0`

```
#while .word label
#end
```

## 1.9.5 <a name="1.9.5"></a>

- added pseudo command `SET` to redefine a label, similar action to temporary labels starting with `?`, e.g.:

```
temp set 12
     lda #temp

temp set 23
     lda #temp
```

- added ability to force **XASM** style addressing mode `a:` and `z:`, e.g.:

```
XASM        MADS
lda a:0     lda.a 0
ldx z:0     lda.z 0
```

- added ability to specify a new code relocation address in  **XASM** style `r:`, e.g.:

```
XASM        MADS
org r:$40   org $40,*
```

- fixed implementation of the `-x` option **Exclude unreferenced procedures**, so `.VAR` variables are not allocated when the procedure is not used

- added extended syntax for single-line `:rept` loops, so it is now possible use of loop counter as `:1` or `%%1` parameter, e.g.:

```
line0
line1
line2
line3

ladr1 :4 dta l(line:1)
hadr1 :4 dta h(line:1)

ladr2 :4 dta l(line%%1)
hadr2 :4 dta h(line%%1)
```

- added warning message when using unstable illegal **6502** opcodes like `CIM`
- added new functionality for `RUN` and `INI` pseudo commands, so they now retain the current assembly address. Previously they switched the assembly address to `$2E0` (RUN) or `$2E2` (INI)
- added support for **anonymous labels** `@` `@+[1..9]` (forward) `@-[1..9]` (backward), in the interest of code clarity use such labels is restricted to conditional branches and up to 10 forward/backward occurrences, e.g..:

```
@ dex   <------+---+
  bne @+ --+   |   |
  stx $80  |   |   |
@ lda #0 <-+   |   |
  bne @- ------+   |
  bne @-1  --------+
```

- extended directives `#IF` and `#WHILE` to include variables declared by `.VAR`, previously it was required to specify the type of the variable, e.g.:

```
 .var temp .word

 #if temp>#2100       ;Now
 #end

 #if .word temp>#2100 ;Before
 #end
```

## 1.9.4 <a name="1.9.4"></a>

- dodana normalizacja ścieżek dla plików, tak aby działały pod **Unixami**, znaki `\` zamieniane są na `/`
- poprawione przekazywanie dyrektyw jako parametrów do procedur i makr, dyrektywy nie były rozpoznawane przy włączonym przełączniku `-c` (case sensitive)
- poprawione działanie `.USE` `.USING`
- dodana informacja w postaci ostrzeżenia **WARNING** o etykiecie powodującej nieskończoną ilość przebiegów asemblacji **INFINITE LOOP**
- dodany zapis dwóch bajtów nagłówka `FF FF` dla pliku zawierającego blok o adresie ładowania `$FFFF`
- komentarze po mnemonikach nie wymagających argumentu zostaną potraktowane jako błąd, wyjątkiem jest łączenie rozkazów w stylu **xasm** poprzez znak `:`, np.:

```
 pla $00          ->  ERROR: Extra characters on line
 pha:pla $00      ->  OK
```

- rozszerzona składnia makr o możliwość używania parametrów w postaci nazw a nie tylko wartości numerycznych-decymalnych, np.:

```
.macro SetColor val,reg
 lda :val
 sta :reg
.endm

.macro SetColor2 (arg1, arg2)
 lda #:arg1
 sta :arg2
.endm
```

- naprawione definiowanie etykiet dla n/w sytuacji, pierwsza etykieta nie zostanie zignorowana

```
temp  label = 100
```

## 1.9.3 <a name="1.9.3"></a>

- poprawione przetwarzanie bloków `.PROC`, które w pewnych okolicznościach mogły zostać pominięte podczas asemblacji
- poprawiony zapis `BLK EMPTY` dla plików **SDX** jeśli zastosowaliśmy deklarację takiego bloku przez `.DS`
- poprawki dotyczące testowania końca linii
- dodane dyrektywy `.FILESIZE`, `.SIZEOF` jako odpowiednik dotychczasowej dyrektywy `.LEN`
- rozszerzona składnia dla pól struktury `.STRUCT`, np.:

```
.struct name
 .byte label0
 .byte :5 label1
 label2 .byte
 label3 :2 .word
.ends
```

## 1.9.2 <a name="1.9.2"></a>

- możliwość określenia adresu dla `.ZPVAR = $XX`
- usprawnione odwołania do etykiet wyliczeniowych `.ENUM`, np. `enum_label(field0, field1)`
- dodana możliwość generowania bloku dla symboli zewnętrznych BLK UPDATE EXTRN dla plików **DOS-a**, poprzednio tylko dla plików `.RELOC`, np.:

```
.extrn vbase .word
org $2000
lda #$80
sta vbase+$5d

blk update extrn
```

- dodany komunikat błędu **Could not use NAME in this context** w przypadku rozkazów odwołań do bloków `.MACRO` `.ENUM` `.STRUCT`
- poprawiony błąd który uniemożliwiał użycie `EQU` w nazwie etykiety
- dodana dyrektywa `.CB +byte,.....`, ostatni bajt ciągu znakowego zapisywany jest w inwersie
- dodana obsługa segmentów poprzez dyrektywy `.SEGDEF` `.SEGMENT` `.ENDSEG`
- dodana nowa dyrektywa`#CYCLE #N` generująca kod **6502** o zadanej liczbie cykli `N`
- dodana obsługa nielegalnych rozkazów **CPU 6502**, przykład w pliku `.\examples\test6502_illegal.asm`
- uaktualnione pliki konfiguracyjne dla Notepad++ `..\syntax\Notepad++`
- poprawiony zapis pliku `LST`
- naprawiona alokacja pamięci dla zmiennych strukturalnych, rozszerzona składnia dla `.STRUCT`

```
.struct LABEL
 x,y,z .word     // wiele zmiennych tego samego typu w jednej linii
 .byte a,b
.ends

.enum type
  a=1,b=2
.ende

.struct label2
  x type
  type y
.ends
```


## 1.9.0 <a name="1.9.0"></a>

- naprawiony zapis linii z komentarzem `/* */` do pliku listingu `*.LST`, poprzednio takie linie nie były zapisywane
- poprawka dla etykiet deklarowanych z linii komend `-d:label`, poprzednio takie etykiety widziane były tylko w pierwszym przebiegu
- w przypadku addytywności bloków `.LOCAL` tylko pierwszy adres z takich bloków jest zapisywany
- poprawki dotyczące parsowania makr, poprzednio etykiety zaczynające się od `END` mogły zostać zinterpretowane jako pseudo rozkaz `END`
- poprawka odczytu dla pustego pliku relokowalnego, poprzednio występował błąd **Value out of range**
- poprawki dla `.USING` `.USE`

## 1.8.8 - 1.8.9 <a name="1.8.8_1.8.9"></a>

- uaktualniony silnik duchów programowych `..\EXAMPLES\SPRITES\CHARS` o duchy 8x24
- w przypadku braku podania rozszerzenia pliku i braku istnienia takiego pliku dla `ICL 'filename'` zostanie domyślnie przyjęte rozszerzenie `*.ASM` `ICL 'filename.asm'`
- poprawione działanie komentarzy `/* */` w blokach `.MACRO` `.REPT`
- usunięty błąd uniemożliwiający poprawną asemblację bloku `#IF` `#WHILE` dla wyrażeń łączonych przez `.OR` `.AND`
- przełączniki w linii komend mogą być poprzedzone tylko znakiem `-`, poprzednio także `/` jednak były problemy z działaniem tego znaku na **MacOSX**
- poprawiony zakres działania dyrektywy `.USING`, dla aktualnej przestrzeni nazw i kolejnych zawierających się w tej przestrzeni nazw

## 1.8.6 - 1.8.7 <a name="1.8.6_1.8.7"></a>

- usprawnione rozpoznawanie komentarzy `/* */` w wyrażeniach
- domyślny adres dla `.ZPVAR` ustawiony na `$0080`, poprzednio `$0000`
- dodana nowa dyrektywa `.ELIF` jako krótszy odpowiednik dyrektywy `.ELSEIF`
- rozszerzone działanie dyrektywy `.LEN` o możliwość podania jako parametru nazwy pliku, zwracana jest wówczas długość takiego pliku
- usprawnione działanie dyrektywy `.DEF` w wyrażeniach warunku `.IF` `.IFDEF` `IFNDEF`

## 1.8.5 <a name="1.8.5"></a>

- dodane makro relokujące moduły **RMT** `...\EXAMPLES\MSX\RMT_PLAYER_RELOCATOR\`
- dodany test składni dla nie asemblowanych procedur .PROC gdy aktywny jest przełącznik `-x` **Exclude unreferenced procedures**
- poprawione działanie przełącznika `-d:label[=value]`, podanie wartości dla etykiety jest teraz opcjonalne, domyślnie mads przypisze wartość 1
- dyrektywy `.DS` `.ALIGN` nie spowodują alokacji zmiennych zdefiniowanych przez `.VAR`
- alokacja zmiennych `.VAR` przed nowym blokiem `ORG` nie nastąpi jeśli blok `ORG` znajduje się w bloku `.LOCAL` lub `.PROC`
- poprawione łamanie wierszy znakiem `\` w ciągach ograniczonych nawiasami `()`
- usunięty błąd powodujący relokowanie adresu dla wyrażenia dyrektywy `.ERROR` `ERT`
- usunięte zauważone błędy przy parsowaniu parametrów linii komend
- usunięte zauważone błędy dotyczące optymalizacji długości kodu makro rozkazów `MVA` `MWA` itp.
- poprawiony kod realizujący zagnieżdżanie bloków `.PROC`
- poprawiony kod realizujący działanie pseudo rozkazów warunku `IFT ELI ELS EIF`
- dodany komunikat **'#' is allowed only in repeated lines** dla przypadków użycia licznika pętli `# (.R)` poza pętlą
- usunięty błąd powodujący błędne alokowanie zmiennych zadeklarowanych przez dyrektywę `.VAR` podczas wykonywania makra
- w celu ujednolicenia składni odwołania do etykiet typów wyliczeniowych możliwe są tylko poprzez znak kropki `.`, poprzednio także przez `::`
- możliwe krótsze odwołania do typów wyliczeniowych `enum_label(fields)`, np. :

```
.enum typ
 val0 = 1
 val1 = 5
 val2 = 9
.ende

 lda #typ(val0|val2)  ; == "lda #typ.val0|typ.val2"
```

- rozszerzona składnia dyrektywy `.SAV`, np.:

```
.sav 'filename',offset,length
.sav 'filenema',length
.sav [offset] 'filename',offset2,length
.sav length
.sav offset,length
```

- rozszerzona składnia dyrektywy `.ARRAY`, w przypadku braku podania maksymalnego indeksu tablicy zostanie on obliczony na podstawie ilości wprowadzonych elementów, elementy można wprowadzać bez konieczności poprzedzenia ich indeksem [expression], np.:

```
.array temp .byte
 1,4,6                  ; [0..2]   = 1,4,6
 [12] = 9,3             ; [12..13] = 9,3
 [5]:[8] = 10,16        ; [5..6]   = 10,16 ; [8..9] = 10,16
 0,0,\                  ; [14..17] = 0,0,1,1
 1,1
.enda                   ; 18 elementów, TEMP [0..17]
```

- dodana możliwość alokacji zmiennej typu strukturalnego przy pomocy dyrektyw `.VAR` `.ZPVAR`, np.:

```
.struct Point
 x .byte
 y .byte
.ends

 .var a,b,c Point
 .zpvar Point f,g,i

```
- dodana możliwość alokacji zmiennej typu wyliczeniowego przy pomocy dyrektyw `.VAR` `.ZPVAR`, np.:

```
.enum Boolean
 false = 0
 true = 1
.ende

 .var test Boolean
 .zpvar Boolean test
```

- dodana możliwość deklaracji pól struktury przy pomocy typów wyliczeniowych, np.:

```
.enum EState
  DONE, DIRECTORY_SEARCH, INIT_LOADING, LOADING
.ende

.struct SLoader
    m_file_start .word
    m_file_length .word

    m_state EState
.ends
```

## 1.8.3 - 1.8.4 <a name="1.8.3_1.8.4"></a>

- nowy silnik duchów programowych z minimalnymi wymaganiami pamięci, bez dodatkowych buforów pamięci obrazu `...EXAMPLES\SPRITES\CHARS_NG`
- nowa wersja pakera **Huffmana** (kompatybilna z **Free Pascal Compiler-em**, `fpc -MDelphi sqz15.pas`) i dekompresora **Huffmana** SQZ15 `...EXAMPLES\COMPRESSION\SQUASH`
- poprawiony kod generowany dla rozkazów `MVP` `MVN` `PEA` `BRA` (**WDC 65816**)
- dodane nowe rozkazy `BRL` `JSL` `JML` (**WDC 65816**), jako odpowiedniki rozkazów długich skoków `BRA` `JSR` `JMP`
- blok aktualizacji etykiet zewnętrznych (external) został rozszerzony o zapis młodszego i starszego bajtu adresu takiej etykiety
- poprawione działanie dyrektywy `.USE` `.USING`, działa niezależnie od przestrzeni nazw w której zostanie użyta
- usunięty błąd, który powodował w pewnych sytuacjach pomijanie asemblacji bloku `#IF` `#WHILE`
- dodana możliwość definiowania zmiennych poprzez dyrektywę `.DS` lub pseudo rozkaz ORG przed blokiem `.RELOC`
- dodana dodatkowa forma składni dla dyrektywy `.VAR`, z tym że dla takiego przypadku nie ma możliwości określenia adresu umiejscowienia zmiennych w pamięci

```
 .VAR .TYPE lab1 lab2 lab3 .TYPE lab4 .TYPE lab5 lab6 ...

 .var .byte a,b,c .dword i j
```

- dodana możliwość definicji pojedyńczych zmiennych typu strukturalnego w krótszy sposób aniżeli dotąd przez `DTA`

```
.struct @point
 x .byte
 y .byte
.ends

pointA  @point    ; pointA dta @point [0] <=> pointA dta @point
pointB  @point    ; pointB dta @point [0] <=> pointB dta @point

points  dta @point [100]
```

- dodana nowa dyrektywa `.ZPVAR` umożliwiająca automatyczne przydzielenie miejsca zmiennym na stronie zerowej

```
 .ZPVAR TYPE label1, label2 label3 = $80  ; LABEL1=$80, LABEL2=LABEL1+TYPE, LABEL3=LABEL2+TYPE
 .ZPVAR label4, label5 TYPE     ; LABEL4=LABEL3+TYPE, LABEL5=LABEL4+TYPE

 .print .zpvar
```

- poprawione działanie dyrektywy `.ERROR` i pseudo rozkazu `ERT`, możliwe jest umieszczenie dodatkowych informacji w wierszu podobnie jak dla `.PRINT` `.ECHO` np.:

```
  ERT *>$6000 , BUUU przekroczyliśmy zakres pamięci o ' , *-$6000 , ' bajtów'
```


- dodana możliwość zagnieżdżania bloków procedur .PROC, ten sam kod może być wywoływany z różnymi parametrami np.:

```
.proc copySrc (.word src+1) .var

 .proc ToDst (.word src+1, dst+1) .var
 .endp

  ldy #0
src lda $ffff,y
dst sta $ffff,y
  iny
  bne src

  rts
.endp

  copySrc.ToDst #$a080 #$b000

  copySrc #$a360
```

- dodane nowe dyrektywy `.ENUM` `.ENDE` `.EEND`

```
.enum dni_tygodnia

  poniedzialek = 1
  wtorek, sroda = 5, czwartek = 7
  piatek
  sobota
  niedziela

.ende

ift dzien==dni_tygodnia::wtorek
.print 'wtorek'
eif
```

- rozszerzona funkcjonalność komentarzy wieloliniowych `/* */` o możliwość umieszczania ich gdziekolwiek

```
lda #12+ /* komentarz */ 23
```

- umożliwiona relokacja adresów definiowanych dyrektywą `.DEF`

```
.reloc
.def label=*
lda label
```

- dodana możliwość użycia znaków `{ }` do oznaczenia bloku (z wyjątkiem bloków `.MACRO`), znak `{` `}` zostaje rozpoznany na początku nowego wiersza, np.:

```
#while .word ad+1<=#$bc40+39
{
ad  sta $bc40

  inw ad+1
}

.proc lab
{
  .local temp2
  {
  }

  .array tab [255] .long
  {}
}
```

## 1.8.2 <a name="1.8.2"></a>

- zniesione ograniczenie długości pliku dla pseudo rozkazu `INS` (poprzednio długość wczytywanego pliku ograniczona była do 65536 bajtów)
- dodany komunikat błędu **The referenced label ... has not previously been defined properly** w przypadku etykiet, które nie zostały zdefiniowane do końca, np. tylko w pierwszym przebiegu wartością nieokreśloną
- dodana nowa dyrektywa `.ECHO` jako odpowiednik dyrektywy .PRINT, dodatkowo informacje generowane przez `.PRINT` `.ECHO` zapisywane są teraz także w listingu `*.LST`
- dodana nowa dyrektywa `.ALIGN` pozwalająca na wyrównanie do zadanego zakresu pamięci, dodatkowo można określić wartość jaką wypełnić pamięć

```
[label] .ALIGN N[,fill]
```

- dodany nowy przełącznik `-U` (Warn of unused labels)


## 1.8.1 <a name="1.8.1"></a>

- rozszerzone działanie znaku backslash `\`, umieszczenie go na końcu wiersza oznacza kontynuację aktualnego wiersza od nowego wiersza, np.:

```
macro_temp \

_____________________________________parametr1_________________________________________________\
_____________________________________parametr2_________________________________________________\
_____________________________________parametr3_________________________________________________

lda\
 #____________________________________label________________________________________\
 +__________________________________expression___________________________________
```

- zmienione testowanie niekończącego wywoływania się makr po którym wystąpi błąd **Infinite loop**
- naprawiony zapis etykiet do pliku `*.LAB`, błąd powstał po dodaniu addytywności obszarów `LOCAL`
- poprawione działanie pseudo rozkazu `SIN` (kod zapożyczony z **XASM**)
- poprawione rozpoznawanie dyrektyw przy włączonym przełączniku -C (Case sensitive)
- usprawniony odczyt bloków `.REPT` (wskazanie prawidłowej linii z błędem) i `.MACRO`
- zablokowane użycie `.VAR` w bloku `.REPT`
- umożliwione zagnieżdżanie oraz wielokrotne uruchamianie (poprzez makra) pętli `.REPT` `:repeat` (poprzednio występował komunikat **Use .REPT directive**)
- umożliwione przekazywanie parametrów do bloku .REPT, np.

```
.REPT 10, #
label:1           ; LABEL0, LABEL1, LABEL2 ... LABEL9
.ENDR

.REPT 5, $12,$33,$44,$55,$66
 dta :1,:2,:3,:4,:5            ; $12,$33,$44,$55,$66
 dta :5,:4,:3,:2,:1            ; $66,$55,$44,$33,$12
.ENDR
```

## 1.7.9 - 1.8.0 <a name="1.7.9_1.8.0"></a>

- poprawiony błąd w opisie przełącznika `-F`, poprzednio **Label at first column**, prawidłowy opis to **CPU command at first column**
- przepisana od nowa obsługa dyrektywy `.DS` i opcji `OPT F+` (dodana możliwość użycia bloków RUN i INI)
- przepisana od nowa obsługa opcji `OPT ?+` (etykiety lokalne w standardzie **MAE**)
- dodana możliwość upublicznienia w blokach PUBLIC tablic zadeklarowanych przez .ARRAY oraz deklaracji struktur `.STRUCT`
- dyrektywa generująca kod **6502** dla decyzji `.TEST` zastąpiona została przez dyrektywę `#IF`, dyrektywa `.ENDT` przez `#END`, dodatkowo możliwe jest użycie dyrektywy `#ELSE` np.:

```
 # if .byte i>#8 .and .byte i<#200
 # else
       #if .word j = #12
       #end
 # end
```

- dyrektywa generująca kod **6502** dla iteracji `.WHILE` zastąpiona została przez dyrektywę `#WHILE`, dyrektywa `.ENDW` przez `#END`, np.:

```
 lda 20               ->       lda 20
 # while .byte @=20   ->  wait cmp 20
 # end                ->       sne
                      ->       jmp wait
```

- dyrektywy `#IF` `#WHILE` akceptują dwa dodatkowe operatory `==` `!=`
- dodana dyrektywa `.EXITM` jako odpowiednik `.EXIT`
- dodana dyrektywa `.FI` jako odpowiednik `.ENDIF`
- dodana dyrektywa `.IFDEF` jako krótszy odpowiednik dyrektyw `.IF` `.DEF`
- dodana dyrektywa `.IFNDEF` jako krótszy odpowiednik dyrektyw `.IF` `.NOT` `.DEF`
- umożliwione zostało definiowanie makr w obszarze procedury `.PROC`, podsumowując aktualnie dopuszczalne jest zdefiniowanie makra w obszarze `.LOCAL` `.PROC`
- wystąpienie jakiegokolwiek ostrzeżenia podczas asemblacji nie zmieni kodu wyjścia (exit_code=0), zmiana podyktowana potrzebą kompatybilności z linuxowym makefile
- ujednolicony sposób deklaracji etykiet lokalnych i globalnych, "białe znaki" przed nazwą etykiety nie wymuszą zdefiniowania takiej etykiety jako globalnej, umożliwi to tylko dyrektywa `.DEF :LABEL`
- poprawione makra `@CALL.MAC` `@CALL_2.MAC`, zmienna tymczasowa globalna `?@stack_offset` modyfikowana jest teraz przez dyrektywę `.DEF`
- rezygnacja z opcji `-E` (Eat White spaces), aktualnie jest ta opcja zawsze włączona
- poprawione wyświetlanie numeru linii z błędem w aktualnie wykonywanym makrze
- skrócone nazwy etykiet tworzonych podczas wykonywania makr (łatwiejsza ich identyfikacja w pliku `*.LAB`)
- poprawione działanie opcji `OPT H-`
- dodane nowe makro rozkazy `INL` (increse LONG), `IND` (increse DWORD), `DEL` (decrese LONG), `DED` (decrese DWORD)
- dodane nowe makro rozkazy `CPB` (compare BYTE), `CPW` (compare WORD), `CPL` (compare LONG), `CPD` (compare DWORD)
- usprawnione i rozszerzone działanie dyrektyw `#TEST` `#WHILE` w oparciu o kod generowany przez makro rozkazy `CPB` `CPW` `CPL` `CPD`, dyrektywy `#TEST` `#WHILE` dla wyrażeń `=#0` `<>#0` generują najkrótszy kod wynikowy
- dodana optymalizacja długości generowanego kodu dla makro rozkazów `MWA` `MWX` `MWY`
- dodana nowa opcja OPT R optymalizująca kod makro rozkazów `MWA` `MWX` `MWY` `MVA` `MVX` `MVY` ze względu na zawartość rejestrów, np.:

```
                opt r-        opt r+
mva #0 $80  ->  lda #$00  ->  lda #0
mva #0 $81  ->  sta $80   ->  sta $80
                lda #$00  ->  sta $81
                sta $81   ->
```

- rozszerzona funkcjonalność dyrektywy `.DEF` o możliwość przypisania wartości nowo deklarowanej etykiecie, np.:

```
.def label = 1
```
- rozszerzona funkcjonalność dyrektywy `.DEF` o możliwość zdefiniowania etykiety globalnej niezależnie od aktulnego obszaru lokalnego, np.:

```
.def :label
```

- umożliwiona została addytywność obszarów `.LOCAL`, tzn. może istnieć wiele obszarów lokalnych o tej samej nazwie, symbole zawarte w takich obszarach należeć będą do wspólnej przestrzeni nazw, np.:

```
.local namespace

 .proc proc1
 .endp

.endl

.local namespace

 .proc proc2
 .endp

.endl
```

## 1.7.8 <a name="1.7.8"></a>

- dodane dyrektywy `.MEND` `.PGEND` `.REND` jako odpowiedniki `.ENDM` `.ENDPG` `.ENDR`
- obecnie deklaracja makra musi kończyć się dyrektywą `.ENDM` lub `.MEND` (poprzednio dopuszczalne było użycie dyrektywy `.END`)
- poprawiony sposób wykonywania makr dzięki czemu umożliwione zostało wykonanie dyrektywy `.ENDL` z poziomu wykonywanego makra
- poprawione zauważone błędy dotyczące starszych bajtów relokowanego adresu oraz bloku aktualizacji symboli publicznych
- dodana nowa dyrektywa `.USING` `.USE` pozwalająca określić ścieżkę poszukiwań dla nazw etykiet
- poprawione działanie dyrektyw `.LOCAL` `.DEF`, których błędne działanie objawiało się w szczególnych przypadkach
- poprawione działanie makro rozkazów skoków (`SNE` `RNE` itp.), których błędne działanie objawiało się w szczególnych przypadkach
- rozszerzona składnia dyrektywy `.TEST` (kod **6502** dla warunku) o dowolną ilość wyrażeń połączonych przez `.OR` lub `.AND` (brak możliwości zmiany piorytetu wartościowania przy pomocy nawiasów), np.:

```
.test .byte k>#10+1 .or .word j>#100 .and .word j<#105 .or .byte k<=#5
...
...
.endt
```

- rozszerzona składnia dyrektywy `.WHILE` (kod **6502** dla pętli) o dowolną ilość wyrażeń połączonych przez `.OR` lub `.AND` (brak możliwości zmiany piorytetu wartościowania przy pomocy nawiasów), np.:

```
.while .byte k>#4 .and .byte k<#39
...
...
.endw
```

## 1.7.6 - 1.7.7 <a name="1.7.6_1.7.7"></a>

- dodany nowy przełącznik `-B:ADDRESS` umożliwiający asemblacje od zadanego adresu
- dodany nowa opcja `OPT F+-` pozwalająca tworzyć bloki ciągłej pamięci (przydatne dla cartów)
- dodana obsługa parametrów typu `.LONG` `.DWORD` przekazywanych do procedur `.PROC` typu `.VAR` (poprzednio akceptowanymi typami parametrów był tylko `.BYTE` `.WORD`)
- dodana nowa dyrektywa `.FL` realizująca zapis liczb rzeczywistych `REAL` w formacie **FP Atari**, np.:

```
pi .fl 3.1415926535897932384626433832795  ; 40 03 14 15 92 65
tb .fl 0.5 12.34 -2.30 0.00002
tb .fl 0.5, 12.34, -2.30, 0.00002
```

- umożliwiony został zapis wartości innych typów niż tylko `.BYTE` w bloku `.ARRAY`
- dodana obsługa typów wielokrotnych dla `.STRUCT`, poprzednio takie typy były akceptowane jednak pamięć nie była właściwie dla nich rezerwowana, np.:

```
.struct test
  x :200 .byte
  y :999 .long
.ends

buf dta test [0]
```
- poprawione błędy dotyczące generowania kodu relokowalnego zauważone przez **Laoo**, np.:

```
    .reloc
    lda temp

temp .long $aabbcc
```

- błąd **Addres relocation overload** wystąpi teraz tylko gdy wyrażenie będzie dotyczyć więcej niż jednej etykiety relokowalnej, poprzednio każde wyrażenie z udziałem etykiety relokowalnej powodowało wyświetlenie tego komunikatu błędu
- blok aktualizacji symboli plublicznych rozszerzony został o możliwość przekazywania stałych różnych typów B-YTE, W-ORD, L-ONG, D-WORD, poprzednio przekazywanym typem był tylko W-ORD
- zmienione działanie dyrektywy `.VAR` w blokach `.LOCAL` znajdujących się w bloku `.PROC`, zmienne takie zawsze odkładane są na końcu bloku przed dyrektywą `.ENDP`, w pozostałych przypadkach na końcu bloku `.LOCAL` przed dyrektywą `.ENDL`
- umożliwiona została relokowalność kodu generowanego przez dyrektywy `.WHILE` `.TEST`
- poprawione działanie testowania wartości typu `.WORD` w kodzie generowanym przez dyrektywy `.WHILE` `.TEST`
- dodana nowa dyrektywa `.ADR` zwracająca adres etykiety przed zmianą adresu asemblacji
- dodana nowa dyrektywa `.LEN` zwracająca długość bloków zdefiniowanych przez `.PROC` `.ARRAY`
- poprawione działanie operacji dzielenia, mnożenia i modulo, poprzednio błędnie był interpretowany piorytet dla tych operacji
- komentarze z końca linii nie poprzedzone znakiem komentarza będą powodować wystąpienie błędu **Unexpected end of line**
- dodana możliwość przypisania zmiennej pól zdefiniowanych przez strukture, np.:

```
@point .struct
       x .byte
       y .byte
       .ends

a @point
b @point
c @point
```

- rozszerzona składnia `.STRUCT` o możliwość dodania nowych pól bez definiowania nazwy pola, np.:

```
.struct @id
 id .word
.ends
.struct @mem
 @id
 adr .word
.ends
```

- rozszerzona składnia makro rozkazu `MWA` o możliwość użycia adresowania pośredniego strony zerowej postindeksowanego `Y`, np.:

```
mwa ($80),y $a000,x
mwa $bc40,y ($f0),y
mwa ($80),y ($82),y
```

- rozszerzona składnia dyrektywy `.EXTRN`, obecnie możliwe jest zapowiedzenie większej ilości etykiet różnych typów w jednym wierszu, zapowiedzenie procedury `.PROC` w takim wierszu musi znajdować się na jego końcu, np.:

```
.extrn a,b,c,d .byte  x y z .word  line .proc(.byte x,y) .reg
```

- rozszerzona składnia dyrektywy `.VAR`, obecnie możliwe jest zadeklarowanie większej ilości etykiet różnych typów w jednym wierszu oraz przypisanie im adresu od którego zostaną odłożone w pamięci, np.:

```
.var x y z .byte bit :2 .dword = $80
```

- rozszerzona składnia dla parametrów procedur przekazywanych przez zmienne `.VAR`, możliwe jest podanie przesunięcia np.:

```
move .proc (.word src+1,dst+1) .var

src lda $ffff
dst sta $ffff

     .endp
```

- dodana nowa dyrektywa `.NOWARN` wyłączająca wyświetlenie ostrzeżenia dla aktualnie asemblowanego wiersza, np.:

```
.nowarn PROCNAME
```

- dodane nowe makro rozkazy `PHR` `PLR` realizujące odkładanie i zdejmowanie wartości rejestrów z udziałem stosu sprzętowego, np.:

```
PHR -> PHA         PLR -> PLA
       TXA                TAY
       PHA                PLA
       TYA                TAX
       PHA                PLA
```

- dodane nowe makro rozkazy `ADB`, `SBB` realizujące dodawanie i odejmowanie wartości typu `.BYTE`, np.:

```
ADB $80 #12 $b000  ->  lda $80
                       clc
                       adc #12
                       sta $b000
SBB #200 $a000     ->  lda #200
                       sec
                       sbc $a000
                       sta $a000
```

- dodana możliwość użycia składni C dla liczb szestnastkowych, np.:

```
lda 0x2000
ldx #0x12

temp = 0x8000
```

## 1.7.5 <a name="1.7.5"></a>

- dyrektywa `.DS` w blokach relokowalnych **SDX** `RELOC` i **MADS** `RELOC` deklaruje od teraz pusty blok
- dodany nowy przełącznik -F, który umożliwia umieszczanie rozkazów CPU i pseudo rozkazów od pierwszej kolumny w wierszu
- przepisane od nowa procedury odczytu bloków `.MACRO` `.REPT` oraz procedura realizująca dzielenie wiersza przy pomocy znaku `\`
- dodane nowe pseudo rozkazy `ADW`, `SBW` realizujące dodawanie i odejmowanie wartości typu `WORD` dla **CPU6502**, np.:

```
adw hlp #40        ; hlp=hlp+40
adw hlp #20 pom    ; pom=hlp+20
```

- rozszerzone działanie dyrektywy `.DEF` o możliwość zdefiniowania etykiety, np.: `.DEF label`
- zwiększona liczba przebiegów dla deklaracji etykiet przez EQU dla pewnych szczególnych przypadków

## 1.7.4 <a name="1.7.4"></a>

- naprawione działanie dyrektywy `.PRINT`, dotąd mogła nie wyświetlić wartości etykiet zaczynającej się na literę `A` `B` `C` `D` `E` `F` `G` `H` `L` `T` `V`
- zablokowane działanie dyrektywy `.DS` w blokach `.RELOC` **SDX** oraz naprawione jej działanie z instrukcją warunkową `.IF` `IFT`
- usprawnione przeszukiwanie ścieżek dostępu `-i:path` (można odwoływać się do podkatalogów tam zawartych)
- w przypadku wystąpienia błędów podczas asemblacji wyświetlane są one wszystkie a nie tylko pierwszy z błędów
- poprawione zauważone błędy, m.in. użycie makra w pliku `.RELO`C mogło spowodować w pewnych sytuacjach zapis błędnej informacji o relokownych adresach
- uproszczony został sposób kończenia procedur wykorzystujących stos programowy **MADS**, nie ma potrzeby używania dyrektywy `.EXIT`, a dyrektywa `.ENDP` nie powoduje już dodatkowych działań na stosie programowym
- dodana nowa dyrektywa `.SYMBOL` jako odpowiednik bloku aktualizacji `BLK UPDATE NEW SYMBOL 'SYMBOL'`, dyrektywę `.SYMBOL` można użyć w dowolnym miejscu programu
- dodane automatyczne wywoływanie bloków aktualizacji `ADDRESS` `EXTERNAL` `PUBLIC` `SYMBOL` dla `.RELOC` i **SDX**
- dodane nowe dyrektywy `.BY` `.WO` `.HE` `.EN` `.SB` (zapożyczone z **MAE**)
- dodany nowy przełącznik `OPT ?-` (domyślnie) etykiety ze znakiem zapytania (?labels) traktowane są jako etykiety tymczasowe, `OPT ?+` etykiety ze znakiem zapytania `?labels` traktowane są jako lokalne i tymczasowe, nazwą obszaru lokalnego jest ostatnio użyta etykieta bez znaku zapytania
- dodane dyrektywy `.LEND` `.PEND` `.AEND` `.WEND` `.TEND` `.SEND` jako odpowiedniki dyrektyw `.ENDL` `.ENDP` `.ENDW` `ENDW` `.ENDT` `.ENDS`
- dodane nowe dyrektywy `.GLOBAL` `.GLOBL` jako odpowiednik (zamiennik) dyrektywy `.PUBLIC`
- dodana optymalizacja skoków warunkowych `JEQ` `JNE` `JPL` `JMI` `JCC` `JCS` `JVC` `JVS` jeśli jest taka możliwość wybierany jest skok krótki typu `BEQ` `BNE` `BPL` `BMI` `BCC` `BCS` `BVC` `BVS`
- dodany nowy domyślny separator znak spacji dla przekazywanych parametrów do `.PROC` `.MACRO` dotąd był to tylko znak przecinka
- usprawnienia dotyczące przekazywania parametrów do makr i procedur, np. paramatrem makra może być dyrektywa zwracająca wartość wyrażenia lub symbol licznika pętli `#`

```
:12 makro #
```

- dodana możliwość użycia znaku spacji jako separatora dla `.VAR` `.EXTRN` np.

```
.EXTRN a b c d .word
.VAR i = 1  j = 2 .byte
.VAR a b c d .byte
```

- rozszerzona składnia dla `.VAR` umożliwiająca zaincjowanie zmiennych stałą, np.:

```
.var i = 10  j = 12 .byte
.var a , b = 2 .byte
```

- dodane nowe dyrektywy `.WHILE` `.ENDW` pozwalające na automatyczne wygenerowanie kodu dla pętli `WHILE`, np.:

```
        ldx #$ff
.while .word adr < #$bc40+40*24
        stx $bc40
   adr: equ *-2
        inw adr
.endw
```

- dodane nowe dyrektywy `.TEST` `.ENDT` pozwalające na automatyczne wygenerowanie kodu dla warunku, np.:

```
.test .byte (@>=#'a')
  .test .byte (@<=#'z')

  .endt
.endt
```

## 1.7.3 <a name="1.7.3"></a>

- dodana możliwość zmiany adresu asemblacji `.PROC` lub `.LOCAL` bez zmiany adresu ładowania
- usunięto optymalizację kodu dla makro rozkazów `MWA` itp., która mogła powodować w szczególnych przypadkach zapętlenie się **MADS**
- dodane dyrektywy `.REG` `.VAR` pozwalające określić sposób przekazywania parametrów do procedur (`.REG` przez rejestry **CPU**, `.VAR` przez zmienne)
- dodana dyrektywa `.VAR` pozwalająca na deklarację zmiennych w blokach `.PROC` `.LOCAL`, zadeklarowane zmiennne są fizycznie odkładane na końcu takiego bloku
- rozszerzona składnia dla dyrektywy `.EXTRN`, np. `EXTRN label1,label2,label3... TYPE`
- jesli brak deklaracji etykiet dla stosu programowego **MADS**, przyjmowane są domyślne wartości `@PROC_VARS_ADR=$0500` `@STACK_ADDRESS=$0600` `@STACK_POINTER=$FE`
- dodany `repeat_counter #`, który można używać zamiennie z dyrektywą `.R`
- wystapi błąd *^ not relocatable* przy próbie relokacji rozkazu `lda ^label`
- dodana obsługa symboli publicznych dla stałych `CONSTANT` w blokach `PUBLIC`
- poprawiona relokowalnosc dla tablic `.ARRAY`, danych stworzonych przez `.STRUCT`, parametrów przekazywanych do procedur przez stała `#`

## 1.7.2 <a name="1.7.2"></a>

- przepisana na nowo obsługa pseudo rozkazów `REQ` `RNE` `RPL` `RMI` `RCC` `RCS` `RVC` `RVS` `SEQ` `SNE` `SPL` `SMI` `SCC` `SCS` `SVC` `SVS`
- poprawione działanie dyrektywy `.LINK` dla bloków o stałych adresach
- poprawione testowanie słów zarezerwowanych (można używać nazw zarezerwowanych dla **WDC 65816** gdy używamy tylko **6502**)
- zmiany w listingu, wyświetla informacje o numerze banku tylko gdy bank > 0
- dodana obsługa makro rozkazów `MWA` `MWX` `MWY` `MVA` `MVX` `MVY` `ADD` `SUB` `INW` `DEW` (do ich obsługi nie są już potrzebne makra)

## 1.7.1 <a name="1.7.1"></a>

- dodana możliwość używania nazw mnemoników **WDC 65816** w trybie pracy **6502**, w trybie **WDC 65816** wystąpi już błąd **Reserved word**
- poprawione działanie pseudo rozkazów skoków `SCC` `RNE` itp. w makrach
- usprawnione wykonywanie wielu makr rozdzielonych znakiem dwukropka `:`

## 1.7.0 <a name="1.7.0"></a>

- usunięty błąd, który powodował zbyt mała liczbę przebiegów asemblacji
- dodana obsługa pseudo rozkazów `JEQ` `JNE` `JPL` `JMI` `JCC` `JCS` `JVC` `JVS` (makra nie są już potrzebne do ich obsługi)

## 1.6.9 <a name="1.6.9"></a>

- rozszerzona składnia dla `.ARRAY` `.PUT`
- dodany pseudo rozkaz `EXT` pozwalający na deklaracje etykiety external
- dodane makra `JEQ` `JNE` `JPL` `JMI` `JCC` `JCS`
- dodane dyrektywy `.PAGES` `.ENDPG`
- dodana dyrektywa `.END` zastepujaca inne dyrektywy `.END?`
- przełącznik `-H` zastąpiony został przez `-HC` (generuje plik nagłówkowy dla **CC65**)
- dodany nowy przełącznik `-HM` generujący plik nagłówkowy dla **MADS** z sortowaniem na etykiety typu `CONSTANTS` `VARIABLES` `PROCEDURES`
- dodana nowa dyrektywa `.RELOC` generująca kod relokowalny w formacie **MADS**

## 1.6.8 <a name="1.6.8"></a>

- dodana nowa dyrektywa `.PUT` oraz rozszerzona składnia dla dyrektywy `.GET` (../EXAMPLES/MSX/MPT_PLAYER/MPT_RELOCATOR.MAC , ../EXAMPLES/MSX/TMC_PLAYER/TMC_RELOCATOR.MAC)
- dodana obsługa pseudo rozkazów **XASM** `REQ` `RNE` `RPL` `RMI` `RCC` `RCS` `RVC` `RVS` `SEQ` `SNE` `SPL` `SMI` `SCC` `SCS` `SVC` `SVS`
- dodana możliwość łączenia dowolnej liczby znanych **MADS** mnemoników przy pomocy znaku `:` (styl **XASM**), np.:

```
lda:cmp:req 20
ldx:ldy:lda:iny label
```

## 1.6.6 - 1.6.7 <a name="1.6.6_1.6.7"></a>

- źródło **MADS** kompatybilne z **Free Pascal Compiler**, po kompilacji możliwe jest jego używanie na innych platformach systemowych, jak np. **Linux**, **Mac OS**, **OS/2** itp.
- od teraz **MADS** sam dobiera odpowiednią liczbę przebiegów asemblacji, przełącznik `/3` nie jest już potrzebny
- poprawiony i rozbudowany został mechanizm przekazywania parametrów do **MADS** (rozdział *Przełączniki assemblera*)
- poprawione zostało wywołanie makra w linii rozdzielanej znakiem `\` oraz usprawnione rozpoznawanie i wykonywanie linii rozdzielanych znakami `\`
- poprawiony błąd, w którym **MADS** mylił dyrektywę `.ENDM` z pseudorozkazem `IFT`
- poprawione działanie instrukcji warunkowych `.ELSEIF` `.ELSE`
- poprawione testowanie poprawności instrukcji warunkowych w makrach
- obsługa procedur `.PROC` została rozbudowana o nowe makra i mechanizmy, dzięki którym podobna jest w działaniu jak i łatwości użycia do procedur z języków wyższego poziomu
- dla procedur `.PROC` z zadeklarowanymi parametrami potrzebna jest teraz dodatkowa deklaracja `@PROC_VARS_ADR`
- brak ograniczeń w liczbie parametrów przekazywanych do procedur, jedynym ograniczeniem jest dostępna pamięć
- dodany nowy przełącznik `/d:label=value` pozwalający zdefiniować nową etykietę **MADS** z poziomu linii poleceń
- dodany nowy przełącznik `/x` **Exclude unreferenced procedures** pozwalający pominąć podczas asemblacji nie używane w programie procedury zadeklarowane dyrektywą `.PROC`
- nowa opcja `OPT T+` (track sep, rep) śledząca zmiany rozmiaru rejestrów `A` `X` `Y` dokonywane przez rozkazy `SEP`, `REP` **WDC 65816**
- nowe biblioteki w katalogu `..\EXAMPLES\LIBRARIES`
- w deklaracji obszaru lokalnego `.LOCAL` nie jest wymagane podanie nazwy obszaru
- nowe operatory `-=` `+=` `++` `--` pozwalające zmniejszyć/zwiększyć wartość etykiety tymczasowej, np.:

```
?label --      ->   ?label=?label-1
?lab ++        ->   ?lab=?lab+1
?temp += 3     ->   ?temp=?temp+3
?ofset -= 5    ->   ?ofset=?ofset-5
```

- rozszerzona o znak przecinka składnia deklaracji parametrów procedur, np.:

```
.proc nazwa (.byte a,b,c .word d,e)
.endp
```