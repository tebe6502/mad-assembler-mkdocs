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

