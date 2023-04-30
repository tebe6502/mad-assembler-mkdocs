#

**MADS** udostępnia możliwość deklaracji dwóch typów danych: strukturalne `.STRUCT` i wyliczeniowe `.ENUM`.

## STRUKTURY

Jeśli programowaliście w **C**, to pewnie spotkaliście się już ze strukturami. Ogólnie w **MADS** struktura definiuje tablicę wirtualną, jednowymiarową o polach różnego typu `.BYTE` `.WORD` `.LONG` `.DWORD` i ich wielokrotności. Wirtualna ponieważ istnieje ona jak na razie tylko w pamięci assemblera.

Pola takiej struktury zawierają informację o ofsecie do początku struktury.

### Deklaracja `.STRUCT`

Struktur dotyczą n/w dyrektywy:

```
name .STRUCT
     .STRUCT name
     .ENDS [.SEND] [.END]
```

* `name .STRUCT`

Deklaracja struktury name przy użyciu dyrektywy `.STRUCT`. Nazwa struktury jest wymagana i konieczna, jej brak wygeneruje błąd. Do nazw struktur nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem **Reserved word**.

---

Przykład deklaracji struktury:

```
.STRUCT name

  x .word      ; lda #name.x = 0
  y .word      ; lda #name.y = 2
  z .long      ; lda #name.z = 4
  v .dword     ; lda #name.v = 7

  q :3 .byte   ; lda #name.q = 11

.ENDS          ; lda #name   = 14 (length)
```

Pola struktury definiujemy przez podanie nazwy i typu pola `.BYTE` `.WORD` `.LONG` `.DWORD`. Nazwa pola może być poprzedzona *białymi spacjami*. W obszarze ograniczonym dyrektywami `.STRUCT` i `.ENDS` nie ma możliwości używania mnemoników *CPU*, jeśli je użyjemy lub użyjemy innych niedozwolonych znaków wystąpi błąd z komunikatem **Improper syntax lub Illegal instruction**.

Podsumowując, etykieta name zawiera informację o całkowitej długości struktury (w bajtach). Pozostałe etykiety opisujące pola zawierają informację o ofsecie do początku struktury.
Deklaracji struktur nie można zagnieżdżać, można zagnieżdżać wcześniej zadeklarowane struktury (kolejność wystąpienia w programie nie ma znaczenia), np.:

```
.STRUCT temp

x .word
y .word
v .byte
z .word

.ENDS


.STRUCT test

tmp  temp

.ENDS

 lda #temp.v
 lda #test.tmp.x
 lda #test.tmp.z
```

Do czego może przydać się struktura?

Przypuśćmy, że mamy jakąś tablicę z polami różnego typu, możemy odczytywać pola takiej tablicy przy pomocy z góry określonych wartości offsetów. Jednak gdy dodamy dodatkowe pole do tablicy, czy też zmodyfikujemy ją w inny sposób, będziemy zmuszeni poprawiać kod programu który posługiwał się z góry określonymi wartościami offsetów. Gdy zdefiniujemy taką tablicę przy pomocy struktury będziemy mogli odczytywać jej pola posługując się offsetami zapisanymi w deklaracji struktury, czyli zawsze odczytamy właściwe pole niezależnie od zmian jakie zaszły w tablicy.

Inny przykład zastosowania struktur został opisany w rozdziale *Symbole zewnętrzne*, przykład zastosowania symboli external i struktur `.STRUCT`.

### Definicja (odwołania)

Definiowanie danych strukturalnych polega na przypisaniu nowej etykiecie konkretnej struktury z użyciem pseudo rozkazu `DTA` lub bez tego pseudo rozkazu. Wynikiem takiego przypisania jest zarezerwowana pamięć, nie jest to już twór wirtualny.

```
label DTA struct_name [count] (data1,data2,data3...) (data1,data2,data3...) ...

label struct_name
```

`COUNT` określa liczbę z przedziału `0..COUNT`, która definiuje maksymalną wartość indeksu tablicy jednowymiarowej, a przez to także liczbę odłożonych w pamięci danych typu strukturalnego.
Przykład deklaracji struktury i definicji danych strukturalnych:

```
;----------------------;
; deklaracja struktury ;
;----------------------;
.STRUCT temp

x .word
y .word
v .byte
z .word

.ENDS

;---------------------;
; definiowanie danych ;
;---------------------;

data dta temp [12] (1,20,200,32000) (19,2,122,42700)

data2 dta temp [0]

data3 temp          // krótszy odpowiednik DATA2
```

Po nazwie struktury w nawiasie kwadratowym musi znajdować się wartość z przedziału `0..2147483647`, która definiuje maksymalną wartość indeksu tablicy jednowymiarowej, a jednocześnie liczbę odłożonych w pamięci danych typu strukturalnego.

Po nawiasie kwadratowym może wystąpić opcjonalnie lista wartości początkowych (ograniczona nawiasami okrągłymi), jeśli nie wystąpi wówczas domyślnymi wartościami pól struktury są zera. Z kolei jeśli lista wartości początkowych jest mniejsza od liczby pól zadeklarowanych, wówczas pozostałe pola inicjowane są ostatnimi wartościami jakie zostały podane, np.

    data dta temp [12] (1,20,200,32000)

Taka deklaracja spowoduje, że wszystkie pola zostaną zaincjowane wartościami `1,20,200,32000`, a nie tylko pierwsze pole `data[0]`.

Jeśli lista wartości początkowych będzie większa lub mniejsza od liczby pól struktury, wówczas wystąpi błąd z komunikatem **Constant expression violates subrange bounds**.

Aby odwołać się do pól tak nowo powstałych danych należy podać ich nazwę, koniecznie indeks w nawiasie kwadratowym i nazwę pola po kropce, np.:

    lda data[4].y
    ldx #data[0].v

Brak nawiasu kwadratowego z indeksem label[index] zakończy się komunikatem błędu **Undeclared label**.

## WYLICZENIA

Wyliczeń dotyczą n/w dyrektywy:

```
name .ENUM
     .ENDE [.EEND] [.END]

Example:

.enum portb
 rom_off = $fe
 rom_on = $ff
.ende

.enum test
 a             ; a=0
 b             ; b=1
 c = 5         ; c=5
 d             ; d=6
.ende
```

Deklaracja wyliczenia odbywa się przy użyciu dyrektyw `.ENUM` i `.ENDE`. Nazwa wyliczenia jest wymagana i konieczna, jej brak wygeneruje błąd. Do nazw wyliczeń nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem **Reserved word**.

Wartości kolejnych etykiet są zwiększane automatycznie o 1 zaczynając od domyślnej wartości `0`, wartości etykiet można definiować samodzielnie albo pozostawić to automatowi.

Do etykiet wyliczeniowych odwołujemy się przy pomocy składni:

    enum_name (field)

lub bezpośrednio podobnie jak w przypadku odwołań do bloków `.LOCAL` `.PROC` czyli po nazwie typu oddzielone znakiem kropki występują kolejne pola, np.:

```
lda #portb(rom_off)

dta portb.rom_on, portb.rom_off
```

Wyliczeń możemy użyć do deklaracji pól struktury `.STRUCT`, do alokacji zmiennych dyrektywą `.VAR`, np.:

```
bank portb           // alokacja zmiennej BANK o rozmiarze 1 bajtu
.var bank portb      // alokacja zmiennej BANK o rozmiarze 1 bajtu

.struct test
 a portb
 b portb
.ends
```

Rozmiar zmiennej typu wyliczeniowego zależny jest od maksymalnej wartości jakie przyjmują kolejne etykiety wyliczenia, np.:

```
.enum EState
    DONE, DIRECTORY_SEARCH=$ff, INIT_LOADING, LOADING
.ende
```

Dla w/w przykładu alokacja zmiennej typu `EState` będzie miała rozmiar dwóch bajtów `WORD`.

Rozmiar możemy sprawdzić przy pomocy dyrektywy `.LEN` `.SIZEOF`, wynikiem będą wartości `1..4` (1 **BYTE**, 2 **WORD**, 3 **LONG**, 4 **DWORD**) np.:

    .print .len EState
