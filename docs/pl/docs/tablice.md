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


