## Dyrektywy generujące kod 6502

 [#IF type expression [.OR type expression] [.AND type expression]](#d_if)<br>
 [#ELSE](#d_if)<br>
 [#END](#d_if)<br>

 [#WHILE type expression [.OR type expression] [.AND type expression]](#d_while)<br>
 [#END](#d_while)<br>

 [#CYCLE #N](#d_cycle)

<a name="d_if"></a>
### #IF type expression [.OR type expression] [.AND type expression]

Dyrektywa `#IF` to skromniejszy odpowiednik instrukcji `IF` z języków wyższego poziomu (**C**, **Pascal**).

Dyrektywy `#IF`, `#ELSE` i `#END` pozwalają na wygenerowanie kodu maszynowego *CPU 6502* instrukcji warunkowej `IF` dla wyznaczonego bloku programu, możliwe jest ich zagnieżdżanie.

Dopuszczalne są wszystkie typy `.BYTE`, `.WORD`, `.LONG`, `.DWORD`, możliwe jest łączenie większej ilości warunków przy pomocy dyrektyw `.OR` i `.AND`, nie ma możliwości określenia kolejności wartościowania poprzez nawiasy.

Wykonanie dyrektywy `#IF` zaczyna się od obliczenia wartości wyrażenia prostego tzn. takiego które składa się z dwóch argumentów i jednego operatora (wyrażenia możemy łączyć dyrektywami `.OR` lub `.AND`).

Jeżeli wyrażenie ma wartość różną od zera (`TRUE`), to zostanie wykonywany blok programu występujący po dyrektywie `#IF`. Blok takiego programu automatycznie kończony jest instrukcją `JMP` realizującą skok do następnej instrukcji programu za dyrektywą `#END` w przypadku występowania bloku `#ELSE`.

Jeżeli wyrażenie ma wartość zero (`FALSE`), to wykonywany jest kod programu występujący po dyrektywie `#ELSE`, jeśli dyrektywa `#ELSE` nie występuje sterowanie przekazywane jest do następnej instrukcji programu za dyrektywą `#END`, np.:

```JavaScript
#if .byte label>#10 .or .byte label<#5
#end

#if .byte label>#100

#else

 #if .byte label<#200
 #end

#end

#if .byte label>#100 .and .byte label<#200 .or .word lab=temp
#end

#if .byte @
#end
```

<a name="d_while"></a>
### #WHILE type expression [.OR type expression] [.AND type expression]

Dyrektywa `#WHILE` jest odpowiednikiem instrukcji `WHILE` z języków wyższego poziomu (**C**, **Pascal**).

Dyrektywy `#WHILE` i `#END` pozwalają na wygenerowanie kodu maszynowego *CPU 6502* pętli dla wyznaczonego bloku programu, możliwe jest ich zagnieżdżanie.

Dopuszczalne są wszystkie typy `.BYTE`, `.WORD`, `.LONG`, `.DWORD`, możliwe jest łączenie większej ilości warunków przy pomocy dyrektyw `.OR` i `.AND`, nie ma możliwości określenia kolejności wartościowania poprzez nawiasy.

Sekwencja działań przy wykonywaniu dyrektywy `#WHILE` jest następująca:

1. Oblicz wartość wyrażenia i sprawdź, czy jest równe zeru (`FALSE`).
	- jeżeli tak, to pomiń krok 2;
	- jeżeli nie (`TRUE`), przejdź do kroku 2.
2. Wykonaj blok programu ograniczonego dyrektywami `#WHILE` i `#END`, następnie przejdź do kroku 1.

Jeżeli pierwsze wartościowanie wyrażenia wykaże, że ma ono wartość zero, to blok programu nigdy nie zostanie wykonany i sterowanie przejdzie do następnej instrukcji programu za dyrektywą `#END`

```JavaScript
#while .byte label>#10 .or .byte label<#5
#end

#while .byte label>#100
 #while .byte label2<#200
 #end
#end

#while .byte label>#100 .and .byte label<#200 .or .word lab=temp
#end
```

Wersja krótka pętli `#WHILE`, trwa dopóki `LABEL<>0`

```
#while .word label
#end
```

<a name="d_cycle"></a>
### #CYCLE #N

Dyrektywa `#CYCLE` pozwala wygenerować kod *6502* o zadanej liczbie cykli. Wygenerowany kod nie modyfikuje żadnej komórki pamięci, ani rejestru *CPU*, co najwyżej znaczniki.

```JavaScript
#cycle #17  ; pha      3 cycle
            ; pla      4 cycle
            ; pha      3 cycle
            ; pla      4 cycle
            ; cmp $00  3 cycle
                      ---------
                      17 cycle
```
