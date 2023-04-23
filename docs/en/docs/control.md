## Kontrola asemblacji

### [Zmiana opcji asemblacji](../pseudo-rozkazy/#opt)

### [Asemblacja warunkowa](../dyrektywy/#if_else)

### [Przerwanie asemblacji](../dyrektywy/#error)

### Asemblacja na stronie zerowej

W przeciwieństwie do dwu-przebiegowych asemblerów takich jak **QA** i **XASM**, **MADS** jest wielo-przebiegowy. Co to daje ?

Weźmy sobie taki przykład:

```
 org $00

 lda tmp+1

tmp lda #$00
```

Dwu-przebiegowy assembler nie znając wartości etykiety `TMP` przyjmie domyślnie, że jej wartość będzie dwu-bajtowa, czyli typu `WORD` i wygeneruje rozkaz `LDA W`.

Natomiast **MADS** uprzejmie wygeneruje rozkaz strony zerowej `LDA Z`. I to właściwie główna i najprostsza do wytłumaczenia właściwość większej liczby przebiegów.

Teraz ktoś powie, że woli gdy rozkaz odwołujący się do strony zerowej ma postać `LDA W`. Nie ma sprawy, wystarczy że rozszerzy mnemonik:

```
 org $00

 lda.w tmp+1

tmp lda #$00
Są dopuszczalne trzy rozszerzenia mnemonika
 .b[.z]
 .w[.a][.q]
 .l[.t]
```

czyli odpowiednio `BYTE`, `WORD`, `LONG`. Z czego ostatni generuje 24bitową wartość i odnosi się do *65816* i pamięci o ciągłym obszarze. Więcej informacji na temat mnemoników *CPU 6502*, *65816* oraz ich dopuszczalnych rozszerzeń w rodziale [Mnemoniki].
Innym sposobem na wymuszenie rozkazu strony zerowej jest użycie nawiasów klamrowych `{ }` np.

```
 dta {lda $00},$80    ; lda $80
```

W **MADS** możemy robić tak samo, ale po co, ostatni przebieg załatwi sprawę za nas :) Problem stanowi teraz umieszczenie takiego fragmentu kodu w pamięci komputera. Możemy spróbować załadować taki program bezpośrednio na stronę zerową i jeśli obszar docelowy mieści się w granicy `$80..$FF` to pewnie **OS** przeżyje, poniżej tego obszaru będzie trudniej.
Dlatego **MADS** umożliwia takie coś:

```
 org $20,$3080

 lda tmp+1

tmp lda #$00
```

Czyli asembluj od adresu `$0020`, ale załaduj pod adres `$3080`. Oczywiście późniejsze przeniesienie kodu pod właściwy adres (w naszym przykładzie `$0020`) należy już do zadań programisty.

Podsumowując:

```
 org adres1,adres2
```

Asembluj od adresu `adres1`, umieść w pamięci od adresu `adres2`. Taki `ORG` zawsze spowoduje stworzenie nowego bloku w pliku, czyli zostaną zapisane dodatkowe cztery bajty nagłówka nowego bloku.

Jeśli nie zależy nam na nowym adresie umiejscowienia danych w pamięci, adresem umiejscowienia danych ma być aktualny adres wówczas możemy skorzystać z właściwości bloków `.LOCAL` i `.PROC`, bajty nagłówka nie będą w takim przypadku zapisywane, np.:

```none
     1
     2                                  org $2000
     3
     4 FFFF> 2000-200D> A9 00           lda #0
     5 2002 EA                          nop
     6
     7 0060                     .local  temp, $60
     8
     9 0060 BD FF FF                    lda $ffff,x
    10 0063 BE FF FF                    ldx $ffff,y
    11
    12                          .endl
    13
    14 2009 A5 60                       lda temp
    15 200B AD 03 20                    lda .adr temp
    16
```

Dla w/w przykładu blok programu `TEMP` zostanie zasemblowany z nowym adresem `= $60` i umiejscowiony w pamięci pod adresem `$2003`.

Po dyrektywie kończącej blok (`.ENDL`, `.ENDP`, `.END`) przywracamy jest adres asemblacji sprzed bloku plus jeszcze długość tak zasemblowanego bloku, w naszym przykładzie adresem od którego będzie kontynuowana asemblacja po zakończeniu bloku `.LOCAL` będzie adres `$2009`.
Następnie wykorzystując dyrektywy `.ADR` i `.LEN` można dokonać skopiowania takiego bloku pod właściwy adres, np.:

```
      ldy #0
copy  mva .adr(temp),y temp,y+
      cpy #.len temp
      bne copy
```

Więcej informacji na temat działania dyrektyw [.ADR](#d_adr) i [.LEN](#d_len).

