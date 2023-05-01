## Wstęp

W założeniu **MADS** skierowany jest do użytkowników **QA**, **XASM**, **FA**. Z **QA** zapożyczona została składnia, z **XASM** niektóre makro rozkazy i zmiany składni, z **FA** obsługa składni **Sparta DOS X** (SDX). Umożliwione zostało użycie dodatkowych znaków w nazwach etykiet. Poza tym dodana została obsługa *CPU WDC 65816*, makr, procedur, podziału pamięci na wirtualne banki, wielowymiarowych nazw etykiet.

Maksymalna liczba etykiet i makr ograniczona jest ilością pamięci komputera *PC*. Konkretnie można dokonać **2147483647** `INTEGER` wpisów do tablic dynamicznych. Jestem pewien że taka ilość jest wystarczająca :-).

Operacje arytmetyczne dokonywane są na wartościach typu `INT64` (signed 64 bit), wynik reprezentowany jest na wartościach typu `CARDINAL` (unsigned 32 bit).
Jeden wiersz może mieć długość **65535** bajtów, takiej długości może być też nazwa etykiety. Nie miałem jednak okazji sprawdzić tak długich etykiet i wierszy :-).

## Kompilacja

**Mad-Assembler (MADS)** jest aplikacją Windows 32 bitową, napisaną w **Delphi**. Większość asemblerów napisano w **C**, więc żeby się nie powtarzać użyłem **Delphi 7.0** ;-).  Najnowsze źródła są dostępne na [GitHub](https://github.com/tebe6502/Mad-Assembler).

Aby je skompilować, można użyć kompilatora **Delphi**, jeśli mamy zainstalowane **Delphi 7.0** lub nowsze. Dzięki darmowemu kompilatorowi **Free Pascal Compiler (FPC)** możliwa jest kompilacja **MADS** dla innych platform systemowych, np. **Linux**, **macOS** itp.
Pobierz pakiet **Free Pascal Compiler (FPC)** z [witryny Free Pascal](https://www.freepascal.org/) i uruchom instalator.

Uruchamiamy instalator, wybieramy katalog w którym zostanie zainstalowany **FPC**. Ważne jest aby nie używać w nazwie katalogu znaku wykrzyknika `!` czy innych nie standardowych znaków. Jeśli nie uda nam się skompilować żadnego pliku, najpewniej winna jest nie standardowa nazwa ścieżki. Linia komend uruchamiająca kompilację może wyglądać następująco (wielkość liter w nazwach parametrów ma znaczenie):

```
fpc -Mdelphi -v mads.pas
```

* `-Mdelphi`     pozwala kompilować plik w formacie Delphi
* `-v`           wyświetla wszystkie komunikaty błędów i ostrzeżeń
* `-O3`          dokonuje optymalizacji kodu

W porównaniu z kompilatorem **Delphi**, kod wygenerowany przez **FPC** jest dłuższy, za to prędkość działania skompilowanego nim **MADS** znacznie większa, nawet o kilka sekund. Załączony plik `mads.exe` jest kompilowany przy użyciu **FPC**.

## **MADS** / **XASM**

### Podobieństwa

* ta sama składnia
* te same kody wyjścia
* te same makro rozkazy

### Różnice i nowe możliwości

* mała różnica w `ORG`, np.: `ORG [[expression]]adres[,adres2]`
* **MADS** nie akceptuje `ORG a:adres` `ORG f:adres`
* **XASM** nie lubi *białych spacji*, **MADS** toleruje je i akceptuje dla wyrażeń logicznych, arytmetycznych, definicji stałych i zmiennych
* **MADS** pozwala na umieszczanie wyrażeń pomiędzy nawiasami `()` `[]`, **XASM** tylko pomiędzy `[]`
* **MADS** udostępnia definicje stałych i zmiennych lokalne, globalne, tymczasowe, **XASM** tylko globalne
* **MADS** udostępnia zapis liczb rzeczywistych poprzez dyrektywę `.FL` `.FL real`, **XASM** poprzez pseudo rozkaz `DTA R`, `DTA R(real)`
* **MADS** oferuje bardziej rozbudowaną obsługę pseudo rozkazu `INS`
* **MADS** nie akceptuje składni typu `lda (203),0`
* **MADS** umożliwia pisanie programów dla Sparta DOS X
* **MADS** umożliwia generowanie kodu relokowalnego w swoim własnym formacie
* **MADS** rozróżnia pojedyncze cudzysłowy `lda #' '` (kodowanie ATASCII) i podwójne cudzysłowy `lda #" '` (kodowanie INTERNAL) dla znaków i łańcuchów. **XASM** traktuje obie formy tak samo (kodowanie ATASCII). Oczywiście, dla danych `DTA`, cudzysłowy nie są rozróżniane przez **MADS**.
<!-- TODO
* jeśli użyjemy podczas adresowania wartości znakowej, np.:

```
lda #' '
lda #" "
```

**MADS** będzie rozróżniał apostrof pojedyńczy (kod ATASCII) i apostrof podwójny (kod INTERNAL), **XASM** oba rodzaje apostrofów potraktuje jednakowo (kod ATASCII). Oczywiście dla danych `DTA` apostrofy nie są rozróżniane przez **MADS**.
-->

**MADS** obsługuje dodatek `+` do zwiększenia i dodatek `-` do zmniejszenia rejestru indeksowego w indeksowanych trybach adresowania, np:
<!-- TODO
* w trybach indeksowych znak `+` lub `-` zwiększa lub zmniejsza rejestr, np.:
-->
```
  lda $2000,x+    ->    lda $2000,x
                        inx
```
* **MADS** obsługuje dodatek `+<offset>` do zwiększania i dodatek `-<offset>` do zmniejszania adresu głównego operandu w trybach adresowania z indeksem bezwzględnym, np:
<!-- TODO
* jeśli jednak umieścimy wartość za znakiem `+` lub `-` wówczas zmienimy o tą wartość główny argument (działa tylko w trybie absolutnym indeksowym), np.:
-->
```
  lda $2000,x+2   ->    lda $2002,x
```

## Linki

* **MADS**
   * [Wątek Atari Age Wątek](https://forums.atariage.com/topic/114443-mad-assembler-mads)
   * [Wątek Atari Area](http://www.atari.org.pl/forum/viewtopic.php?id=8450)
   * [Kolorowanie](http://www.atari.org.pl/forum/viewtopic.php?pid=210234)
* **XASM**
    *[Strona domowa](https://github.com/pfusik/xasm)
