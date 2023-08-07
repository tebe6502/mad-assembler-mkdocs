#

## Wstęp

Kod relokowalny to taki kod, który nie ma z góry określonego adresu ładowania do pamięci komputera, kod taki musi zadziałać niezależnie od adresu załadowania. W **Atari XE/XL** kod relokowalny udostępnia system **Sparta DOS X** (**SDX**), więcej na ten temat można przeczytać w rozdziale *Sparta DOS X - Programowanie*.

Kod relokowalny dla **SDX** posiada podstawowe ograniczenie jakim jest relokowanie tylko adresów typu `WORD`, nie ma także obsługi rozkazów *CPU 65816*. **MADS** udostępnia możliwość generowania kodu relokowalnego w formacie **SDX** jak i swoim własnym niekompatybilnym z **SDX**, który znosi wcześniej wymienione ograniczenia.

Format zapisu pliku z kodem relokowalnym **MADS** jest podobny do tego znanego z **SDX**, podobnie występuje tutaj blok główny i bloki dodatkowe z informacją o adresach które należy poddać relokacji. MADS stosuje prostszy zapis bloków aktualizacji, bez *kompresji* jaką stosuje **SDX**.

Zalety kodu relokowalnego **MADS**:

* uwzględnia rozmiar argumentów dla *CPU 6502*, *65816*
* można używać wszystkie rozkazy *CPU*, bez ograniczeń
* pozwala na relokacje młodszych i starszych bajtów adresu

Ograniczenia kodu relokowalnego **MADS**:

* deklaracji etykiet przez `EQU` dokonujemy przed blokiem `.RELOC`
* jeśli chcemy zdefiniować nową etykietę w bloku `.RELOC` musimy jej nazwę poprzedzić spacją lub tabulatorem (etykieta globalna)
* nie można używać pseudo rozkazów `ORG` `RMB` `LMB` `NMB` oraz dyrektywy `.DS`
* nie można relokować najstarszego bajtu ze słowa 24bit, np. `lda ^$121416`

Przykładem tego jak prosto można stworzyć kod relokowalny jest plik `..\EXAMPLES\TETRIS_RELOC.ASM`, który od strony użytej listy rozkazów *CPU* i pseudo rozkazów definiujących dane niczym nie różni się od wersji nierelokowalnej `..\EXAMPLES\TETRIS.ASM`.

## Blok relokowalny .RELOC

Blok relokowalny **MADS** zostanie wygenerowany po użyciu dyrektywy:

    .RELOC [.BYTE|.WORD]

Blok aktualizacji dla bloku relokowalnego **MADS** wywołujemy używając pseudo rozkazu `BLK`:

    BLK UPDATE ADDRESS

Po dyrektywie `.RELOC` możliwe jest podanie typu bloku relokowalnego `.BYTE` `.WORD`, domyślnie jest to typ `.WORD`. Typ `.BYTE` dotyczy bloku przeznaczonego do umieszczenia wyłącznie na stronie zerowej (będzie zawierał rozkazy strony zerowej), **MADS** będzie asemblował taki blok od adresu `$0000`. Typ `.WORD` oznacza że **MADS** będzie asemblował blok relokowalny od adresu `$0100` i będzie przeznaczony do umieszczenia w dowolnym obszarze pamięci (nie będzie zawierał rozkazów strony zerowej).

Nagłówek bloku `.RELOC` przypomina ten znany z **DOS**, dodatkowo został on rozszerzony o 10 nowych bajtów czyli w sumie zajmuje 16 bajtów, np.:

```
HEADER            .WORD = $FFFF
START_ADDRESS     .WORD = $0000
END_ADDRESS       .WORD = FILE_LENGTH-1
MADS_RELOC_HEADER .WORD = $524D
UNUSED            .BYTE = $00
CONFIG            .BYTE (bit0)
@STACK_POINTER    .WORD
@STACK_ADDRESS    .WORD
@PROC_VARS_ADR    .WORD
```

* `MADS_RELOC_HEADER`

Zawsze o wartości `$524D` co odpowiada znakom `MR` (M-ADS R-ELOC).

* `FILE_LENGTH`

To długość bloku relokowalnego bez 16 bajtowego nagłówka.

* `CONFIG`

Wykorzystany jest obecnie tylko `bit0` tego bajtu, `bit0=0` oznacza blok relokowalny asemblowany od adresu `$0000`, `bit0=1` blok relokowalny asemblowany od adresu `$0100`

---

Ostatnie 6 bajtów zawiera informację o wartościach etykiet potrzebnych do działania stosu programowego `@STACK_POINTER`, `@STACK_ADDRESS`, `@PROC_VARS_ADR` jeśli zostały użyte podczas asemblacji bloków relokowalnych. Jeśli poszczególne bloki `.RELOC` zostały zasemblowane z różnymi wartościami tych etykiet i są one linkowane wystąpi wówczas komunikat ostrzeżenia **Incompatible stack parameters**. Jeśli stos programowy nie został użyty wartościami tych etykiet są zera.

Pseudo rozkaz `.RELOC` powoduje przełączenie **MADS** w tryb generowania kodu relokowalnego z uwzględnianiem rozmiaru argumentów rozkazów *CPU 6502*, *65816*. W obszarze takiego kodu niemożliwe jest używanie pseudo rozkazów `ORG` `LMB` `NMB` `RMB` oraz dyrektywy `.DS`. Niemożliwy jest powrót **MADS** do trybu generowania kodu nie relokowalnego, możliwe jest wygenerowanie więcej niż jednego bloku `.RELOC`.

Użycie dyrektywy `.RELOC` powoduje dodatkowo zwiększenie licznika wirtualnych banków **MADS** przez co taki obszar staje się lokalny i niewidoczny dla innych bloków. Więcej informacji na temat wirtualnych banków w rozdziale Wirtualne banki pamięci `OPT B-`.

Na końcu bloku `.RELOC` wymagane jest wygenerowanie bloku aktualizacji, realizuje to pseudo rozkaz `BLK` z identyczną składnią jak dla bloku relokowalnego **SDX** (**BLK UPDATE ADDRESS**). Format zapisu takiego bloku aktualizacji nie jest jednak identyczny z **SDX**, ma następującą postać:

```
HEADER       WORD ($FFEF)
TYPE         CHAR (B-YTE, W-ORD, L-ONG, D-WORD, <, >)
DATA_LENGTH  WORD
DATA         WORD [BYTE]
```

* `HEADER`

Zawsze o wartości `$FFEF`.

* `TYPE`

Typ danych zapisany jest na bitach `0..6` tego bajtu i określa typ modyfikowanych adresów, znak `<` oznacza młodszy bajt adresu, znak `>` oznacza starszy bajt adresu.

* `DATA_LENGTH`

To liczba 2-bajtowych danych (adresów) do modyfikacji.

* `DATA`

To właściwy ciąg danych służących modyfikacji głównego bloku relokowalnego. Pod wskazanym tutaj adresem należy odczytać wartość typu `TYPE` a następnie zmodyfikować na podstawie nowego adresu ładowania.

---

Wyjątek stanowi blok aktualizacji dla starszych bajtów adresów `>`, dla takiego bloku w `DATA` zapisywany jest jeszcze dodatkowy bajt `BYTE` (młodszy bajt modyfikowanego adresu). Aby dokonać aktualizacji starszych bajtów, musimy odczytać bajt spod adresu `WORD` w `DATA`, dodać go do aktualnego adresu relokacji i dodać jeszcze młodszy bajt z `BYTE` w `DATA`. Tak nowo obliczony starszy bajt umieszczamy pod adresem `WORD` z `DATA`.

## Symbole zewnętrzne .EXTRN

Symbole zewnętrzne informują, że zmienne i procedury które reprezentują będą znajdowały się gdzieś na zewnątrz, poza aktualnym programem. Nie musimy określać gdzie. Musimy jedynie podać ich nazwy oraz typy. W zależności od typu danych jakie reprezentuje symbol instrukcje asemblera tłumaczone są na odpowiednie kody maszynowe, asembler musi znać rozmiar używanych danych.

> **UWAGA:**
> _Aktualnie nie istnieje możliwość dokonywania operacji na symbolach external typu `^` (najstarszy bajt)._

Symbole zewnętrzne mogą być używane w blokach relokowalnych `.RELOC` jak i w zwykłych blokach **DOS**.

Symbole zewnętrzne **external** deklarujemy używając pseudo rozkazu `EXT` lub dyrektywy `.EXTRN`:

```
label EXT type

label .EXTRN type

.EXTRN label1,label2,label3... type

.extrn PlaySfx .proc (.byte PlaySfx.note, PlaySfx.fx) .var
```

Blok aktualizacji dla symboli **external** wywołujemy używając pseudo rozkazu `BLK`:

    BLK UPDATE EXTERNAL

> **UWAGA:**
> _Zostaną zapisane symbole, które zostały użyte w programie._

Symbole external nie mają zdefiniowanej wartości tylko typ `.BYTE` `.WORD` `.LONG` `.DWORD` np.:

```
name EXT .BYTE

label_name EXT .WORD

 .EXTRN label_name .WORD

wait EXT .PROC (.BYTE delay)
```

Symbol external z deklaracją procedury `.PROC` przyjmuje domyślnie typ `.WORD`, próba odwołania się do nazwy takiej etykiety zostanie potraktowana przez **MADS** jako próba wywołania procedury, więcej na temat wywołań procedur `.PROC` w rozdziale *Procedury*.

W procesie asemblacji po napotkaniu odwołania do symbolu external zawsze podstawiane są zera.

Symbole **external** przydać się nam mogą wówczas gdy chcemy zasemblować program oddzielnie, niezależnie od reszty właściwego programu. W takim programie występują wówczas najczęściej odwołania do procedur, zmiennych które zostały zdefiniowane gdzieś indziej, na zewnątrz, a my nie znamy ich wartości tylko typ. W tym momencie z pomocą przychodzą symbole **external**, które umożliwiają asemblację takiego programu mimo braku właściwych procedur czy zmiennych.

Innym zastosowaniem symboli external mogą być tzw. *pluginy* programy zewnętrzne połączone z programem głównym i realizujące dodatkowe czynności. Są to swoistego rodzaje biblioteki, wykorzystujące procedury programu głównego, rozszerzające jego funkcjonalność. Aby stworzyć taki plugin należałoby określić jakie procedury udostępnia program główny (ich nazwy+parametry i typ) oraz stworzyć procedurę odczytu pliku z symbolami **external**, ta procedura realizowałaby dołączanie pluginów do głównego programu.

Poniżej format zapisu nagłówka w pliku z symbolami external typu **B**-YTE, **W**-ORD, **L**-ONG i **D**-WORD po wywołaniu przez `BLK UPDATE EXTERNAL`:

```
HEADER        WORD ($FFEE)
TYPE          CHAR (B-YTE, W-ORD, L-ONG, D-WORD, <, >)
DATA_LENGTH   WORD
LABEL_LENGTH  WORD
LABEL_NAME    ATASCII
DATA          WORD .. .. ..
```

* `HEADER`

Zawsze o wartości `$FFEE`.

* `TYPE`

Typ danych zapisany jest na bitach `0..6` tego bajtu i określa typ modyfikowanych adresów.

* `DATA_LENGTH`

To liczba 2-bajtowych danych (adresów) do modyfikacji.

* `LABEL_LENGTH`

To długość nazwy symbolu wyrażona w bajtach.

* `LABEL_NAME`

To nazwa symbolu w kodach **ATASCII**.

* `DATA`

Właściwy ciąg danych służących modyfikacji głównego bloku relokowalnego. Pod wskazanym tutaj adresem należy odczytać wartość typu `TYPE` a następnie zmodyfikować na podstawie nowej wartości symbolu.

---

Przykładem zastosowania symboli **external** i struktur `.STRUCT` jest przykładowa biblioteka prymitywów graficznych `PLOT` `LINE` `CIRCLE` z katalogu `..\EXAMPLES\LIBRARIES\GRAPHICS\LIB`. Poszczególne moduły wykorzystują tutaj dość sporą liczbę zmiennych na stronie zerowej, jeśli chcemy aby adresy tych zmiennych były relokowalne musielibyśmy każdą z osobna zmienną zadeklarować jako symbol zewnętrzny przez `EXT` `.EXTRN`. Możemy to uprościć wykorzystując tylko jeden symbol zewnętrzny i strukturę danych `.STRUCT`. Za pomocą struktur definiujemy *mapę* zmiennych `ZP`, potem jeden symbol external `ZPAGE` typu `.BYTE` bo chcemy aby zmienne były na stronie zerowej. Teraz odwołując się do zmiennej musimy zapisać to w sposób wymuszający relokowalność np. `ZPAGE+ZP.DX` i tak powstał moduł całkowicie relokowalny z możliwością zmiany adresu zmiennych w przestrzeni strony zerowej.

## Symbole publiczne .PUBLIC

Symbole publiczne udostępniają zmienne i procedury występujące w bloku relokowalnym pozostałej części asemblowanego programu. Dzięki symbolom publicznym możemy odwoływać się do zmiennych i procedur *zaszytych* np. w bibliotekach.

Symbole publiczne mogą być używane w blokach relokowalnych `.RELOC` jak i w zwykłych blokach **DOS**.

**MADS** sam rozpoznaje czy podana do upublicznienia etykieta jest zmienną, stałą czy też procedurą zadeklarowną przez `.PROC`, nie jest wymagana żadna dodatkowa informacja jak w przypadku symboli zewnętrznych.

Symbole publiczne deklarujemy używając n/w dyrektyw:

```
.PUBLIC label [,label2,...]
.GLOBAL label [,label2,...]
.GLOBL label [,label2,...]
```

Dyrektywy `.GLOBAL` `.GLOBL` zostały dodane z myślą o kompatybilności z innymi assemblerami, ich znaczenie jest identyczne z dyrektywą `.PUBLIC`.

Blok aktualizacji dla symboli publicznych wywołujemy używając pseudo rozkazu `BLK`:

    BLK UPDATE PUBLIC

Poniżej format zapisu nagłówka w pliku z symbolami publicznymi po wywołaniu przez `BLK UPDATE PUBLIC`:

```
HEADER        WORD ($FFED)
LENGTH        WORD
TYPE          BYTE (B-YTE, W-ORD, L-ONG, D-WORD)
LABEL_TYPE    CHAR (C-ONSTANT, V-ARIABLE, P-ROCEDURE, A-RRAY, S-TRUCT)
LABEL_LENGTH  WORD
LABEL_NAME    ATASCII
ADDRESS       WORD
```

**MADS** automatycznie dobiera odpowiedni typ dla upublicznianej etykiety:

* `C-ONSTANT` etykieta nie poddająca się relokacji
* `V-ARIABLE` etykieta poddająca się relokacji
* `P-ROCEDURE` procedura zadeklarowana przez .PROC, podlega relokacji
* `A-RRAY` tablica zadeklarowana przez .ARRAY, podlega relokacji
* `S-TRUCT` struktura zadeklarowana przez .STRUCT, nie podlega relokacji

Jeśli symbol dotyczy struktury `.STRUCT` wówczas zapisywane są dodatkowe informacje (typ pola struktury, nazwa pola struktury, liczba powtórzeń pola struktury):

```
STRUCT_LABEL_TYPE    CHAR (B-YTE, W-ORD, L-ONG, D-WORD)
STRUCT_LABEL_LENGTH  WORD
STRUCT_LABEL_NAME    ATASCII
STRUCT_LABEL_REPEAT  WORD
```

Jeśli symbol dotyczy tablicy `.ARRAY` wówczas zapisywane są dodatkowe informacje (maksymalny zadeklarowany indeks tablicy, typ zadeklarowanych pól tablicy):

```
ARRAY_MAX_INDEX  WORD
ARRAY_TYPE       CHAR (B-YTE, W-ORD, L-ONG, D-WORD)
```

Jeśli symbol dotyczy procedury .PROC wówczas zapisywane są dodatkowe informacje, niezależnie od tego czy procedura miała czy też nie miała zadeklarowane parametry:

```
PROC_CPU_REG  BYTE (bits 00 - regA, 01 - regX, 10 - regY)
PROC_TYPE     BYTE (D-EFAULT, R-EGISTRY, V-ARIABLE)
PARAM_COUNT   WORD
```

Dla symboli dotyczących procedur `.REG` zapisywane są już teraz tylko typy tych parametrów w ilości `PARAM_COUNT`:

```
PARAM_TYPE    CHAR (B-YTE, W-ORD, L-ONG, D-WORD)
...
...
```

Dla symboli dotyczących procedur .VAR zapisywane są typy parametrów i ich nazwy. `PARAM_COUNT` określa całkowitą długość tych danych:

```
PARAM_TYPE    CHAR (B-YTE, W-ORD, L-ONG, D-WORD)
PARAM_LENGTH  WORD
PARAM_NAME    ATASCII
...
...
```

* `HEADER`

Zawsze o wartości `$FFED`.

* `LENGTH`

To liczba symboli zapisanych w bloku aktualizacji.

* `TYPE`

Typ symbolizowanych danych **B**-YTE, **W**-ORD, **L**-ONG, **D**-WORD.

* `LABEL_TYPE`
    * Typ symbolu: V-ARIABLE, C-ONSTANT, P-ROCEDURE, A-RRAY, S-TRUCT
    * Dla typu P zapisywane są dodatkowe informacje: PROC_CPU_REG, PROC_TYPE, PARAM_COUNT, PARAM_TYPE
    * Dla typu A zapisywane są dodatkowe informacje: ARRAY_MAX_INDEX, ARRAY_TYPE
    * Dla typu S zapisywane są dodatkowe informacje: STRUCT_LABEL_TYPE, STRUCT_LABEL_LENGTH, STRUCT_LABEL_NAME, STRUCT_LABEL_REPEAT

Typ symbolizowanych danych **B**-YTE, **W**-ORD, **L**-ONG, **D**-WORD.

* `LABEL_LENGTH`

Długość etykiety symbolu publicznego wyrażona w bajtach

* `LABEL_LENGTH`

Długość etykiety symbolu publicznego wyrażona w bajtach

* `LABEL_NAME`

Etykieta symbolu publicznego zapisana w kodach **ATASCII**

* `ADDRESS`

Adres przypisany symbolowi w bloku relokowalnym `.RELOC`. Ta wartość zostaje poddana relokacji poprzez dodanie do niej aktualnego adresu asemblacji.

* `PROC_CPU_REG`

Informacja o kolejności użycia rejestrów *CPU* dla procedury typu `.REG`

* `PROC_TYPE`
    * **D**-EFAULT domyślny typ wykorzystujący do przekazywania parametrów stos programowy **MADS**
    * **R**-EGISTRY parametry do procedury przekazywane są przez rejestry **CPU** `.REG`
    * **V**-ARIABLE parametry do procedury przekazywane są przez zmienne `.VAR`

* `PARAM_COUNT`

Informacja o liczbie parametrów procedury `.REG` lub całkowitej długości danych zawierających informację o typie parametrów i ich nazwach `.VAR`.

* `PARAM_TYPE`

Typ parametrów zapisany za pomocą znaków `B` `W` `L` `D`

* `PARAM_LENGTH`

Długość nazwy parametru `.VAR`.

* `PARAM_NAME`

Nazwa parametru w kodach ATASCII `.VAR`.

## Dyrektywy `.LONGA` `.LONGI`

```
.LONGA ON|OFF
.LONGI ON|OFF
```

* Dyrektywa `.LONGA` informuje assembler o rozmiarze rejestru akumulatora, 16bit gdy ON, 8bit gdy OFF.

* Dyrektywa `.LONGI` informuje assembler o rozmiarze rejestrów indeksowych `XY`, 16bit gdy ON, 8bit gdy OFF.

* Dyrektywy wpływają na rozmiar argumentu przy adresowaniu absolutnym *CPU 65816*.

## Linkowanie `.LINK`

    .LINK 'filename'

Dyrektywa `.LINK` wymaga podania jako parametru nazwy pliku do relokacji. Akceptowane są tylko pliki **DOS Atari**, pliki **SDX** nie są akceptowane.

Jeśli adres ładowania pliku jest inny niż `$0000` oznacza to że plik nie zawiera kodu relokowalnego, jednak może zawierać bloki aktualizacji dla symboli zewnętrznych i publicznych. Dyrektywa `.LINK` akceptuje pliki o dowolnym adresie ładowania, jednak relokacji poddawane są tylko te o adresie ładowania `$0000`, więcej szczegółów na temat budowy takiego pliku zostało zawartych w rozdziale Blok relokowalny `.RELOC`.

Dyrektywa `.LINK` pozwala na łączenie kodu relokowalnego z nierelokowalnym. **MADS** na podstawie bloków aktualizacji dokonuje automatycznej relokacji takiego pliku. Uwzględniane są wszystkie 3 rodzaje bloków aktualizacji `ADDRESS` `EXTERNAL` `PUBLIC`.
Nie ma ograniczeń co do adresu pod którym umieszczany jest plik relokowalny.

Jeśli blok relokowalny do działania wymaga stosu programowego **MADS** wówczas etykiety `@STACK_POINTER` `@STACK_ADDRESS` `@PROC_VARS_ADR` zostaną automatycznie zaktualizowane na podstawie nagłówka bloku `.RELOC`. Wymagane jest aby bloki `.RELOC` i program główny operowały na tym samym stosie programowym jeśli jest on konieczny.

