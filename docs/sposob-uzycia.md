#

## Przełączniki assemblera

```none
Syntax: mads source [switches]

-b:address      Generate binary file at specific address
-c              Label case sensitivity
-d:label=value  Define a label
-f              CPU command at first column
-fv:value       Set raw binary fill byte to [value]
-hc[:filename]  Header file for CC65
-hm[:filename]  Header file for MADS
-i:path         Additional include directories
-l[:filename]   Generate listing
-m:filename     File with macro definition
-ml:value       margin-left property
-o:filename     Set object file name
-p              Print fully qualified file names in listing and error messages
-s              Silent mode
-t[:filename]   List label table
-u              Warn of unused labels
-vu             Verify code inside unreferenced procedures
-x              Exclude unreferenced procedures
```

Domyślne nazwy plików to:

* `source.lst`
* `source.obx`
* `source.lab`
* `source.h`
* `source.hea`
* `source.mac`

Jeśli nie podamy rozszerzenia dla pliku source, wówczas MADS domyślnie przyjmie rozszerzenie `.ASM`.

Parametry możemy podawać w dowolnej kolejności uprzednio poprzedzając je znakiem `/` lub `-`, wielkość liter nie ma znaczenia. Parametry możemy łączyć ze sobą, np.:

```
mads -lptd:label=value -d:label2=value source.asm
mads -l  -p  -t  source
mads source.asm  -lpt
mads.exe "%1" -ltpi:"d:\!atari\macro\"
mads -i:"c:\atari\macros\" -c source.asm  -lpt
```

Domyślnie **MADS** po asemblacji zapisze plik z rozszerzeniem `.OBX`, możemy to zmienić z poziomu **BAT**:

```
mads "%1" -o:%~n1.xex
```

Więcej na temat operatorów możemy dowiedzieć się wykonując `CALL /?` z poziomu **Microsoft DOS**.

### `b:address`

Użycie przełącznika `-b` pozwala nadać nowy adres asemblacji dla pliku w którym nie określono adresu asemblacji (adres asemblacji określamy przy pomocy pseudo rozkazu `ORG`).

### `c`

Użycie przełącznika `-c` spowoduje rozróżnianie wielkości liter w nazwach etykiet, zmiennych, stałych. Dyrektywy assemblera i rozkazy **CPU 6502**, **65816** są zawsze rozpoznawane bez względu na wielkość liter.

### `d:label=value`

Użycie przełącznika `-d` pozwala na wprowadzenie nowej etykiety do pamięci **MADS** z poziomu linii poleceń. Przełącznika można użyć wielokrotnie podczas jednego wywołania **MADS**, może być przydatny gdy asemblujemy z użyciem plików wsadowych **BAT**.

### `f`

Użycie przełącznika -f umożliwia umieszczanie rozkazów **CPU** od pierwszej kolumny wiersza i ich poprawne rozpoznawanie przez asembler jako rozkazy a nie tylko jako etykiety.

### `fv:value`

Użycie przełącznika `-fv:value` pozwala ustalić wartość wypełnienia pamięci gdy użyjemy `OPT F+`

### `hc[:filename]`

Przełącznik `-hc` włącza zapis pliku z nagłówkami dla kompilatora **CC65**. Pozwala także określić nową nazwę dla takiego pliku. Domyślna nazwa pliku nagłówkowego dla **CC65** to `*.H`

### `hm[:filename]`

Przełącznik `-hm` włącza zapis pliku z nagłówkami dla **MADS**. Pozwala także określić nową nazwę dla takiego pliku. Domyślna nazwa pliku nagłówkowego dla **MADS** to `*.HEA`. Plik taki zawiera informacje o bankach przypisanych etykietom i ich wartości. Dodatkowo etykiety posortowane zostają wg typu `CONSTANS` `VARIABLES` `PROCEDURES`.

### `i:path`

Przełącznik `-i` służy do określenia ścieżek poszukiwań dla operacji `ICL` oraz `INS`. Przełącznika można użyć wielokrotnie podczas jednego wywołania MADS-a, np.:

```
-i:"c:\program files" -i:c:\temp -i:"d:\atari project"
```

### `l:filename`

Przełącznik `-l` włącza zapis pliku z listingiem. Pozwala także określić nową nazwę dla takiego pliku.

### `m:filename`

Przełącznik `-m` służy do określenia pliku z deklaracjami makr. W przypadku jego użycia **MADS** asembluje taki plik przed głównym plikiem `.ASM`

### `o:filename`

Przełącznik `-o` pozwala określić nową nazwę pliku wykonywalnego **Atari DOS** lub **Atari Sparta DOS X**, który powstanie po procesie asemblacji.

### `p`

Przełącznik `-p` pomocny jest w połączeniu z **Code Genie**. Gdy wystąpi błąd podczas asemblacji, w oknie *Output Bar* edytora **Code Genie** pojawi się stosowny komunikat wygenerowany przez **MADS**, np.:

```
D:\!Delphi\Masm\test.asm (29) ERROR: Missing .PROC
```

Teraz wystarczy kliknąć dwukrotnie linię z tym komunikatem, a kursor edytora ustawi się w linii z błędem.

### `s`

Użycie przełącznika `-s` spowoduje uaktywnienie tzw. trybu pracy *Silent mode*, czyli żadne komunikaty nie zostaną wyświetlone, co najwyżej komunikaty błędów **ERROR** i ostrzeżenia **WARNING**.

### t[:filename]

Przełącznik `-t` włącza zapis pliku z użytymi definicjami etykiet. Pozwala także określić nową nazwę dla takiego pliku.

### `x`
Przełącznik `-x` pozwala na pominięcie w procesie asemblacji procedur zadeklarowanych dyrektywą `.PROC`, do których nie nastąpiło odwołanie w programie.

### `vu`

Przełącznik `-vu` wymusza dodatkowy test kodu w blokach `.PROC` mimo tego że taki blok `.PROC` nie zostanie zapisany do pliku wynikowego, najczęściej przydaje się gdy używamy przełącznika `-x`

### `u`

Przełącznik `-u` wyświetli etykiety które nie zostały użyte w programie.

## Kody wyjścia

```none
3 = bad parameters, assembling not started
2 = error occured
0 = no errors
```

Komunikaty ostrzeżenia nie powodują zmiany wartości kodu wyjścia.

## Struktura pliku `LST`

Format listingu nie odbiega od tego znanego z **XASM**, jedyną zmianą jest dodanie przed adresem, numeru wirtualnego banku pamięci (pod warunkiem że numer banku `<> 0`).

```none
3
4 = 01,9033    obraz equ $9033
5 = 01,00A0    scr1 equ $a0
6
7
8 01,2000 EA   main nop
```

## Struktura pliku `LAB`

Podobnie jak w przypadku **XASM**, w pliku `*.LAB` przechowywane są informacje na temat etykiet które wystąpiły w programie.

W sumie są to trzy kolumny:

* Pierwsza kolumna to numer wirtualnego banku przypisany do etykiety (jeśli bank `<> 0`)
* Druga kolumna to wartość etykiety.
* Trzecia kolumna to nazwa etykiety.

Numery wirtualnych banków przypisane do etykiety o wartościach `>= $FFF9` mają specjalne znaczenie:

```none
$FFF9   etykieta parametru procedury zdefiniowanej przez dyrektywę .PROC
$FFFA   etykieta tablicy zdefiniowanej przez dyrektywę .ARRAY
$FFFB   etykieta danych strukturalnych zdefiniowanej przez pseudo rozkaz DTA STRUCT_LABEL
$FFFC   etykieta symbolu Sparta DOS X - SMB
$FFFD   etykieta makra zdefiniowanego przez dyrektywę .MACRO
$FFFE   etykieta struktury zdefiniowanej przez dyrektywę .STRUCT
$FFFF   etykieta procedury zdefiniowanej przez dyrektywę .PROC
```

Specjalne znaczenie w nazwach etykiet mają znaki:

* etykieta zdefiniowana w makrze (dwa dwukropki) `::`
* znak kropki `.` rozdziela nazwę struktury `.MACRO` `.PROC` `.LOCAL` `.STRUCT` od nazwy pola w strukturze

Wartość liczbowa, która występuje po `::` oznacza numer wywołania makra.

```none
Mad-Assembler v1.4.2beta by TeBe/Madteam
Label table:
00  0400    @STACK_ADDRESS
00  00FF    @STACK_POINTER
00  2000    MAIN
00  2019    LOOP
00  201C    LOOP::1
00  201C    LHEX
00  0080    LHEX.HLP
00  204C    LHEX.THEX
00  205C    HEX
00  205C    HEX.@GETPAR0.LOOP
00  2079    HEX.@GETPAR1.LOOP
```

## Struktura pliku `H`

Nie jestem pewien czy wszystko z tym plikiem jest OK, ale **Eru** chciał żeby coś takiego było więc jest :) Ma on być pomocny przy łączeniu **ASM** z **CC65**, czyli portem **C** dla małego **Atari**. Jego zawartość może wyglądać tak, przykładowy plik `TEST.ASM`:

```none
#ifndef _TEST_ASM_H_
#define _TEST_ASM_H_

#define TEST_CPU65816 0x200F
#define TEST_CPU6502 0x2017
#define TEST_TEXT6502 0x201F
#define TEST_TEXT65816 0x2024

#endif
```
