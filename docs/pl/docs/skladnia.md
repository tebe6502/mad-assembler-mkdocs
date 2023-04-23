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
