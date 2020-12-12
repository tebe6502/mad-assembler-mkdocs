#

## Wstęp

**Mad-Assembler** (MADS) jest aplikacją 32 bitową, napisaną w **Delphi**. Większość asemblerów napisano w **C**, więc żeby się nie powtarzać użyłem **Delphi 7.0** ;)

W założeniu **MADS** skierowany jest do użytkowników **QA**, **XASM**, **FA**. Z **QA** zapożyczona została składnia, z **XASM** niektóre makro rozkazy i zmiany składni, z **FA** obsługa składni **Sparta DOS X** (SDX). Umożliwione zostało użycie dodatkowych znaków w nazwach etykiet. Poza tym dodana została obsługa **CPU 65816**, makr, procedur, podziału pamięci na wirtualne banki, wielowymiarowych nazw etykiet.

Maksymalna liczba etykiet i makr ograniczona jest ilością pamięci komputera *PC*. Konkretnie można dokonać **2147483647** `INTEGER` wpisów do tablic dynamicznych. Jestem pewien że taka ilość jest wystarczająca :)

Operacje arytmetyczne dokonywane są na wartościach typu `INT64` (signed 64 bit), wynik reprezentowany jest na wartościach typu `CARDINAL` (unsigned 32 bit).
Jeden wiersz może mieć długość **65535** bajtów, takiej długości może być też nazwa etykiety. Nie miałem jednak okazji sprawdzić tak długich etykiet i wierszy :)

Dzięki darmowemu kompilatorowi **Free Pascal Compiler** (FPC) możliwa jest kompilacja **MADS** dla innych platform systemowych, np. **Linux**, **Mac**, **OS/2** itp.

Źrodła dostępne na [GitHub](https://github.com/tebe6502/Mad-Assembler) wraz z [release](https://github.com/tebe6502/Mad-Assembler/releases) dla systemu Windows.

## Kompilacja

Aby skompilować źródło **MADS**, można użyć kompilatora z **Delphi**, jeśli ktoś ma akurat zainstalowane środowisko **Delphi 7.0** lub nowsze.

Innym sposobem, bardziej multi platformowym jest użycie kompilatora z pakietu **Free Pascal Compiler** (FPC), który można pobrać ze tej [strony](http://www.freepascal.org/).

Uruchamiamy instalator, wybieramy katalog w którym zostanie zainstalowany **FP**. Ważne jest aby nie używać w nazwie katalogu znaku wykrzyknika `!` czy innych nie standardowych znaków. Jeśli nie uda nam się skompilować żadnego pliku, najpewniej winna jest nie standardowa nazwa ścieżki. Linia komend uruchamiająca kompilację może wyglądać następująco (wielkość liter w nazwach parametrów ma znaczenie):

    fpc -Mdelphi -v mads.pas

* `-Mdelphi`     pozwala kompilować plik w formacie Delphi
* `-v`           wyświetla wszystkie komunikaty błędów i ostrzeżeń
* `-O3`          dokonuje optymalizacji kodu

W porównaniu z kompilatorem **Delphi**, kod wygenerowany przez **FPC** jest dłuższy, za to prędkość działania skompilowanego nim **MADS** znacznie większa, nawet o kilka sekund. Załączony plik `MADS.EXE` jest kompilowany przy użyciu **FPC**.

## **XASM** / **MADS**

### Podobieństwa

* ta sama składnia
* te same kody wyjścia
* te same makro rozkazy

### Różnice i nowe możliwości

* mała różnica w `OR`G, np. `ORG [[expression]]adres[,adres2]`
* **XASM** nie lubi *białych spacji*, **MADS** toleruje je i akceptuje dla wyrażeń logicznych, arytmetycznych, definicji stałych i zmiennych
* **MADS** pozwala na umieszczanie wyrażeń pomiędzy nawiasami `()` `[]`, **XASM** tylko pomiędzy `[]`
* **MADS** udostępnia definicje stałych i zmiennych lokalne, globalne, tymczasowe, **XASM** tylko globalne
* **MADS** nie akceptuje `ORG a:adres` i `ORG f:adres`
* **MADS** udostępnia zapis liczb rzeczywistych poprzez dyrektywę `.FL` `.FL real`, **XASM** poprzez pseudo rozkaz `DTA R` `DTA R(real)`
* **MADS** oferuje bardziej rozbudowaną obsługę pseudo rozkazu `INS`
* **MADS** nie akceptuje składni typu `lda (203),0`
* **MADS** umożliwia pisanie programów dla Sparta DOS X
* **MADS** umożliwia generowanie kodu relokowalnego w swoim własnym formacie
jeśli użyjemy podczas adresowania wartości znakowej, np.:

```
lda #' '
lda #" "
```

**MADS** będzie rozróżniał apostrof pojedyńczy (kod ATASCII) i apostrof podwójny (kod INTERNAL), **XASM** oba rodzaje apostrofów potraktuje jednakowo (kod ATASCII). Oczywiście dla danych `DTA` apostrofy nie są rozróżniane przez **MADS**.

* w trybach indeksowych znak `+` lub `-` zwiększa lub zmniejsza rejestr, np.:

```
lda $2000,x+    ->    lda $2000,x
                      inx
```

* jeśli jednak umieścimy wartość za znakiem `+` lub `-` wówczas zmienimy o tą wartość główny argument (działa tylko w trybie absolutnym indeksowym), np.:

```
lda $2000,x+2   ->    lda $2002,x
```

## Linki

* [Strona domowa **XASM**](http://atariarea.histeria.pl/x-asm/)
* Wątki dotyczące **MADS**:
    * [Atari Area](http://www.atari.org.pl/forum/viewtopic.php?id=8450)
    * [Atari Age](http://atariage.com/forums/topic/114443-mad-assembler-mads/)
    * [Kolorowanie składni](http://www.atari.org.pl/forum/viewtopic.php?id=13407)