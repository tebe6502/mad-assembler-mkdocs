## Makra

Makra ułatwiają nam wykonywanie powtarzających się czynności, automatyzują je. Istnieją tylko w pamięci assemblera, dopiero w momencie wywołania są asemblowane. Przy ich pomocy **MADS** może odkładać i zdejmować z programowego stosu parametry dla procedur zadeklarowanych dyrektywą `.PROC` oraz przełączać banki rozszerzonej pamięci w trybie *BANK SENSITIVE* (`OPT B+`).

> _Makra czytane są tylko w pierwszym przebiegu assemblacji, dla n/w przykładu makra znajdujące się w pliku dołączanym przez `ICL` nie zostaną rozpoznane_:

```
 .macro test
   icl 'dodatkowe_makra.mac'
 .endm
```

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

