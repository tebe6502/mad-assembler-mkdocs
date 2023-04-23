## Procedury

**MADS** wprowadza nowe możliwości w obsłudze procedur z parametrami. Nowe możliwości upodabniają ten mechanizm do tych znanych z języków wysokiego poziomu i są tak samo łatwe w użyciu dla programisty.

Aktualnie dołączone do **MADS**-a deklaracje makr (`@CALL.MAC`, `@PULL.MAC`, `@EXIT.MAC`) umożliwiają obsługę stosu programowego o wielkości 256 bajtów, czyli tej samej wielkości jak stos sprzętowy, udostępniają mechanizm zdejmowania ze stosu programowego i odkładania na stos programowy parametrów potrzebnych podczas wywoływania procedur, jak i wychodzenia z takich procedur. **MADS** uwzględnia możliwość rekurencji takich procedur.

Programista nie jest zaangażowany w ten mechanizm, może skupić uwagę na swoim programie. Musi tylko pamiętać o potrzebie zdefiniowania odpowiednich etykiet i dołączeniu odpowiednich makr podczas asemblacji programu.

Dodatkowo istnieje możliwość pominięcia "mechanizmu" stosu programowego **MADS**-a i skorzystanie z klasycznego sposobu ich przekazywania, za pomocą rejestrów *CPU* (dyrektywa `.REG`) lub przez zmienne (dyrektywa `.VAR`).

Inną właściwością procedur `.PROC` jest możliwość pominięcia ich podczas asemblacji jeśli nie wystąpiło żadne odwołanie do nich, czyli zostały zdefiniowane ale nie są wykorzystane. Wystąpi wówczas komunikat ostrzeżenia _**Unreferenced procedure ????**_. Pominięcie takiej procedury podczas asemblacji możliwe jest poprzez podanie parametru do **MADS**-a w linii poleceń `-x 'Exclude unreferenced procedures'`.

Wszelkie etykiety zdefiniowane w obszarze procedury `.PROC` są zasięgu lokalnego, można je też określić jako etykiety globalne zdefiniowane lokalnie o dostępie swobodnym, ponieważ można się do nich odwoływać co nie jest normalne w innych językach programowania.

W obszarze procedury `.PROC` istnieje możliwość zdefiniowania etykiet o zasięgu globalnym (patrz rozdział [Etykiety globalne](#globalne)).

Jeśli chcemy dostać się do etykiet zdefiniowanych w procedurze spoza obszaru procedury, wówczas adresujemy z użyciem znaku kropki `.`, np.:

```
 lda test.pole

.proc test

pole nop

.endp
```

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze procedury `.PROC`, wówczas **MADS** będzie poszukiwał ją w obszarze niższym aż dojdzie do obszaru globalnego. Aby odczytać natychmiastowo wartość etykiety globalnej z poziomu procedury `.PROC` (czy też innego obszaru lokalnego) poprzedzamy nazwę etykiety znakiem dwukropka `:`.

**MADS** wymaga dla procedur wykorzystujących stos programowy, trzech globalnych definicji etykiet o konkretnych nazwach (adres stosu, wskaźnik stosu, adres parametrów procedury):

 - @PROC_VARS_ADR
 - @STACK_ADDRESS
 - @STACK_POINTER

Brak definicji w/w etykiet i próba użycia bloku `.PROC` wykorzystującego stos programowy spowoduje że **MADS** przyjmie swoje domyślne wartości tych etykiet: `@PROC_VARS_ADR = $0500`, `@STACK_ADDRESS = $0600`, `@STACK_POINTER = $FE`

**MADS** dla procedur wykorzystujących stos programowy wymaga także deklaracji makr o konkretnych nazwach. Dołączone do **MADS**-a deklaracje tych makr znajdują się w plikach:

 - @CALL    ..\EXAMPLES\MACROS\@CALL.MAC
 - @PUSH    ..\EXAMPLES\MACROS\@CALL.MAC
 - @PULL    ..\EXAMPLES\MACROS\@PULL.MAC
 - @EXIT    ..\EXAMPLES\MACROS\@EXIT.MAC

W/w makra realizują przekazywanie i odkładanie na programowy stos parametrów, oraz zdejmowanie i odkładanie parametrów dla procedur wykorzystujących stos programowy i wywoływanych z poziomu innych procedur wykorzystujących stos programowy.


### Deklaracja procedury

Procedur dotyczą n/w dyrektywy:

```
 name .PROC [(.TYPE PAR1 .TYPE PAR2 ...)] [.REG] [.VAR]
 .PROC name [,address] [(.TYPE PAR1 .TYPE PAR2 ...)] [.REG] [.VAR]
 .ENDP [.PEND] [.END]
```

#### name .PROC [(.TYPE Par1,Par2 .TYPE Par3 ...)] [.REG] [.VAR]

Deklaracja procedury name przy użyciu dyrektywy `.PROC`. Nazwa procedury jest wymagana i konieczna, jej brak wygeneruje błąd. Do nazw procedur nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem _**Reserved word**_.

Jeśli chcemy wykorzystać jeden z mechanizmów **MADS**-a do przekazywania parametrów do procedur, musimy je wcześniej zadeklarować. Deklaracja parametrów procedury mieści się pomiędzy nawiasami okrągłymi `( )`. Dostępne są cztery typy parametrów:

 - .BYTE  (8-bit)  relokowalne
 - .WORD  (16-bit) relokowalne
 - .LONG  (24-bit) nierelokowalne
 - .DWORD (32-bit) nierelokowalne

> _W obecnej wersji **MADS**-a nie ma możliwości przekazywania parametrów za pomocą struktur `.STRUCT`._

Bezpośrednio po deklaracji typu, oddzielona minimum jedną spacją, następuje nazwa parametru. Jeśli deklarujemy więcej parametrów tego samego typu możemy rozdzielić ich nazwy znakiem przecinka ','.

Przykład deklaracji procedury wykorzystującej stos programowy:

```
name .PROC ( .WORD par1 .BYTE par2 )
name .PROC ( .BYTE par1,par2 .LONG par3 )
name .PROC ( .DWORD p1,p2,p3,p4,p5,p6,p7,p8 )
```

Dodatkowo używając dyrektyw `.REG` lub `.VAR` mamy możliwość określenia sposobu i metody przekazywania parametrów do procedur **MADS**-a. Przez rejestry *CPU* (`.REG`) lub przez zmienne (`.VAR`). Dyrektywy określające sposób przekazywania parametrów umieszczamy na końcu naszej deklaracji procedury `.PROC`

Przykład deklaracji procedury wykorzystującej rejestry *CPU*:

```
name .PROC ( .BYTE x,y,a ) .REG
name .PROC ( .WORD xa .BYTE y ) .REG
name .PROC ( .LONG axy ) .REG
```

Dyrektywa `.REG` wymaga aby nazwy parametrów składały się z liter `A`, `X`, `Y` lub ich kombinacji. Litery te odpowiadają nazwom rejestrów *CPU* i wpływają na kolejność użycia rejestrów. Ograniczeniem w liczbie przekazywanych parametrów jest ilość rejestrów *CPU*, przez co możemy przekazać do procedury w sumie maksimum 3 bajty. Zaletą takiego sposobu jest natomiast szybkość i małe zużycie pamięci *RAM*.

Przykład deklaracji procedury wykorzystującej zmienne:

```
name .PROC ( .BYTE x1,x2,y1,y2 ) .VAR
name .PROC ( .WORD inputPointer, outputPointer ) .VAR
name .PROC ( .WORD src+1, dst+1 ) .VAR
```

Dla `.VAR` nazwy parametrów wskazują nazwy zmiennych do których będą ładowane przekazywane parametry. Metoda ta jest wolniejsza od `.REG` jednak nadal szybsza od metody ze stosem programowym.

Procedurę opuszczamy w standardowy sposób, czyli przy pomocy rozkazu `RTS`. Dodanie rozkazu `RTS` w ciele procedury przy wyjściu z każdej ścieżki jest obowiązkiem programującego, a nie assemblera.

Podobnie jak w przypadku bloku `.LOCAL` mamy możliwość określenia nowego adresu asemblacji dla bloku `.PROC`, np.:

```
.PROC label,$8000
.ENDP

.PROC label2,$a000 (.word ax) .reg
.ENDP
```

W przypadku procedur wykorzystujących stos programowy po zakończeniu procedury przez `.ENDP` **MADS** wywołuje makro `@EXIT`, którego zadaniem jest modyfikacja wskaźnika stosu programowego `@STACK_POINTER`, jest to konieczne dla prawidłowego działania stosu programowego. Użytkownik może sam zaprojektować swoje makro `@EXIT`, albo skorzystać z dołączonego do **MADS**-a (plik ..\EXAMPLES\MACROS\@EXIT.MAC), ma ono obecnie następującą postać:

```
.macro @EXIT

 ift :1<>0

  ift :1=1
   dec @stack_pointer

  eli :1=2
   dec @stack_pointer
   dec @stack_pointer

  els
   pha
   lda @stack_pointer
   sub #:1
   sta @stack_pointer
   pla

  eif

 eif

.endm
```

Makro `@EXIT` nie powinno zmieniać zawartości rejestrów *CPU* jeśli chcemy zachować możliwość zwrócenie wyniku działania procedury `.PROC` poprzez rejestry *CPU*.

#### .ENDP

Dyrektywa `.ENDP` kończy deklarację bloku procedury.


### Wywołanie procedury

Procedurę wywołujemy poprzez jej nazwę (identycznie jak makro), po niej mogą wystąpić parametry, rozdzielone separatorem w postaci znaku przecinka `,` lub spacji `' '` (nie ma możliwości zadeklarowania innych separatorów).

Jeśli typ parametru nie będzie zgadzał się z typem zadeklarowanym w deklaracji procedury wystąpi komunikat błędu _**Incompatible types**_.

Jeśli przekazana liczba parametrów różni się od liczby zadeklarowanych parametrów w deklaracji procedury to wystąpi komunikat błędu _**Improper number of actual parameters**_. Wyjątkiem jest procedura do której parametry przekazywane są przez rejestry *CPU* (`.REG`) lub zmienne (`.VAR`), w takich przypadkach możemy pominąć parametry, w domyśle są one już załadowane do odpowiednich rejestrów czy też zmiennych.

Możliwe są trzy sposoby przekazania parametru:

- '#' przez wartość
- ' ' przez wartość spod adresu (bez znaku poprzedzającego)
- '@' przez akumulator (parametry typu .BYTE)
- "string" przez ciąg znakowy, np. "label,x"

Przykład wywołania procedury:

```
 name @ , #$166 , $A400  ; dla stosu programowego
 name , @ , #$3f         ; dla .REG lub .VAR
 name "(hlp),y" "tab,y"	 ; dla .VAR lub dla stosu programowego (stos programowy korzysta z regX)
```

**MADS** po napotkaniu wywołania procedury, która korzysta ze stosu programowego wymusza wykonanie makra `@CALL`. Jeśli jednak procedura nie korzysta ze stosu programowego, zamiast makra `@CALL` zostanie wygenerowany zwykły rozkaz `JSR PROCEDURE`.

Do makra `@CALL` **MADS** przekazuje parametry wyliczone na podstawie deklaracji procedury (rozbija każdy parametr na trzy składowe: tryb adresacji, typ parametru, wartość parametru).

```
@CALL_INIT 3\ @PUSH_INIT 3\ @CALL '@','B',0\ @CALL '#','W',358\ @CALL ' ',W,"$A400"\ @CALL_END PROC_NAME
```

Makro `@CALL` odłoży na stos zawartość akumulatora, następnie wartość $166 (358 dec), następnie wartość spod adresu $A400. Więcej informacji na temat sposobu przekazywania parametrów do makr (znaczenia apostrofów `' '` i `" "`) w rozdziale [Wywołanie makra](../skladnia/#wywoanie-makra).

Parametr przekazywany przez akumulator `@` powinien być zawsze pierwszym parametrem przekazywanym do procedury, jeśli wystąpi w innym miejscu zawartość akumulatora zostanie zmodyfikowana (domyślne makro `@CALL` nakłada takie ograniczenie). Oczywiście użytkownik może to zmienić pisząc swoją wersję makra `@CALL`. W przypadku procedur `.REG` lub `.VAR` kolejność wystąpienia parametru `@` nie ma znaczenia.

Wyjście z procedury `.PROC` następuje poprzez rozkaz `RTS`. Po powrocie z procedury **MADS** wywołuje makro `@EXIT` które zawiera program modyfikujący wartość wskaźnika stosu `@STACK_POINTER`, jest to niezbędne w celu prawidłowego działania stosu programowego. Od wskaźnika stosu odejmowana jest liczba bajtów które zostały przekazane do procedury, liczba bajtów przekazywana jest do makra jako parametr.

Dodanie rozkazu `RTS` w ciele procedury przy wyjściu z każdej ścieżki jest obowiązkiem programującego, a nie assemblera.


### Parametry procedury

Odwołania do parametrów procedury z poziomu procedury nie wymagają dodatkowych operacji ze strony programisty, np.:

```
@stack_address equ $400
@stack_pointer equ $ff
@proc_vars_adr equ $80

name .PROC (.WORD par1,par2)

 lda par1
 clc
 adc par2
 sta par1

 lda par1+1
 adc par2+1
 sta par1+1

.endp

 icl '@call.mac'
 icl '@pull.mac'
 icl '@exit.mac'
```

**MADS** w momencie napotkania deklaracji `.PROC` z parametrami, dokonuje automatycznej definicji tych parametrów przypisując im wartości na podstawie `@PROC_VARS_ADR`. W w/w przykładzie **MADS** dokona automatycznej definicji parametrów `PAR1 = @PROC_VARS_ADR`, `PAR2 = @PROC_VARS_ADR + 2`.

Programista odwołuje się do tych parametrów po nazwie jaka została im nadana w deklaracji procedury, czyli podobnie jak ma to miejsce w językach wyższego poziomu. W **MADS** istnieje możliwość dostępu do parametrów procedury spoza procedury co nie jest już normalne w językach wyższego poziomu. Możemy odczytać z w/w przykładu zawartość `PAR1`, np.:

```
 lda name.par1
 sta $a000
 lda name.par1+1
 sta $a000+1
```

Wartość `PAR1` została przepisane pod adres $A000, wartość PAR1+1 pod adres $A000+1. Oczywiście możemy tego dokonać tylko bezpośrednio po zakończeniu tej konkretnej procedury. Trzeba pamiętać że parametry takich procedur odkładane są pod wspólnym adresem `@PROC_VARS_ADR`, więc z każdym nowym wywołaniem procedury wykorzystującej stos programowy zawartość obszaru `<@PROC_VARS_ADR .. @PROC_VARS_ADR + $FF>` ulega zmianom.

Jeśli procedura ma zadeklarowane parametry typu `.REG` programista powinien zatroszczyć się o to aby je zapamiętać czy też właściwie wykorzystać zanim zostaną zmodyfikowane przez kod procedury. W przypadku parametrów typu `.VAR` nie trzeba się o nic martwić ponieważ parametry zostały zapisane do konkretnych komórek pamięci skąd zawsze możemy je odczytać.

