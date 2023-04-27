#

## Wstęp

Pewnie każdemu, kto miał do czynienia z architekturą małego **Atari**, pojęcie *bank pamięci* kojarzy się z pamięcią rozszerzoną, podzieloną na banki wielkości **16kb**, przełączane w obszar `$4000..$7FFF`.

**MADS** też może to rozumieć w ten sposób (opcja `OPT B+`, [Sprzętowe banki pamięci](#sprzetowe-banki-pamieci-opt-b)), jednak domyślnie rozumie to w sposób bardziej wirtualny (opcja `OPT B-`, [Wirtualne banki pamięci](#wirtualne-banki-pamieci-opt-b-)).

Banków dotyczą n/w pseudo rozkazy:

```
LMB #value
NMB
RMB
```

* `LMB #` Load Memory Bank

Ustawiamy licznik banków MADS-a na konkretną wartość z zakresu <$00..$FF> (BANK = value), np.

```
lmb #0
lmb #bank
lmb #5 , $6500      ; tylko gdy OPT B+
```

* `NMB` Next Memory Bank

Zwiększamy o 1 licznik banków **MADS**-a (BANK = BANK + 1).

```
nmb
nmb  $6500          ; tylko gdy OPT B+
```

* `RMB` Reset Memory Bank

Zerujemy licznik banków **MADS**-a (BANK = 0).

```
rmb
rmb $3500           ; tylko gdy OPT B+
rmb $8500           ; tylko gdy OPT B+
```

---

**MADS** podczas asemblacji, każdej nowo zdefiniowanej etykiecie przypisuje aktualną wartość licznika banków. Programista może mieć wpływ na wartość licznika banków dzięki w/w pseudo rozkazom.

* Etykiety z przypisanym licznikiem banków **MADS** `=0` są zasięgu **globalnego**.
* Etykiety z przypisanym licznikiem banków **MADS** `>0` są zasięgu **lokalnego**.

## Wirtualne banki pamięci `OPT B-`

W **MADS** przez pojęcie *wirtualny bank pamięci* rozumiany jest każdy obszar oznaczony przez nowo zdefiniowaną etykietę z przypisaną aktualną wartością licznika banków (domyślnie licznik banków jest wyzerowany). Czyli wirtualny bank pamięci to nie koniecznie obszar pamięci `$4000..$7FFF`, ale każda etykieta reprezentująca jakiś obszar kodu programu, której przypisany został kod (wartość licznika banków) z zakresu `$00..$FF` przy pomocy odpowiednich pseudo rozkazów oddanych na użytek programisty `NMB` `RMB` `LMB`.

Wyjątek stanowią bloki `.RELOC` w których nie można samodzielnie zmieniać licznika banków, realizuje to automatycznie **MADS**, który zwiększa licznik za każdym wywołaniem dyrektywy `.RELOC`. Licznik banków w takim przypadku przyjmuje wartości z zakresu `$0001..$FFF7`.

Programista może odczytać wartość licznika banków, który został przypisany etykiecie za pomocą operatora `=` np.:

```
label

 ldx #=label
```

W w/w przykładzie do rejestru `X` *CPU* zapisaliśmy wartość licznika banków pamięci **MADS** przypisany etykiecie `LABEL`.

Innym przydatnym operatorem może być znak dwukropka `:` umieszczony na początku nazwy etykiety. Spowoduje to że **MADS** odczyta wartość takiej etykiety pomijając ograniczenia zasięgu, które wprowadza licznik banków **MADS**. Niekiedy może spowodować to komplikacje, np. jeśli wystąpiło więcej etykiet o tej samej nazwie ale w różnych obszarach lokalnych albo w obszarach o różnych wartościach licznika wirtualnych banków.

```


 lmb #5

label5
 nop

 lmb #6

label6
 nop

 lda :label5
```

Dla w/w przykładu brak operatora `:` na początku nazwy etykiety w rozkazie `lda :label5` skończy się komunikatem błędu **ERROR: Undeclared label LABEL5 (BANK=6)**.

Wirtualnych banków pamięci można użyc do indeksowania tablicy zawierającej wartości dla **PORTB**. Takie też jest ich zastosowanie w przypadku wybrania opcji `OPT B+`.

## Sprzętowe banki pamięci `OPT B+`

Ten tryb działania **MADS** można określić jako *czuły na banki* **BANK SENSITIVE**.

Sprzętowe banki pamięci są rozszerzeniem wirtualnych banków. Rozumiane są przez **MADS** jako banki rozszerzonej pamięci, włączane w obszar `$4000..$7FFF`. Działanie pseudo rozkazów `NMB`  `RMB` `LMB` zostaje rozszerzone o wywołanie makra `@BANK_ADD`, które można znaleźć w katalogu `..\EXAMPLES\MACROS\`.

W tym trybie działania **MADS** potrzebuje deklaracji konkretnych makr:

```
@BANK_ADD
@BANK_JMP
```

oraz potrzebuje definicji etykiet o nazwach:

```
@TAB_MEM_BANKS
@PROC_ADD_BANK
```

Etykieta `@TAB_MEM_BANKS` definiuje adres tablicy, z której wartości będą przepisywane do rejestru **PORTB** odpowiedzialnego za przełączanie banków rozszerzonej pamięci. Możemy sobie ułatwić sprawę i skorzystać z gotowej procedury wykrywającej banki rozszerzonej pamięci dołączonej do **MADS**, plik `..\EXAMPLES\PROCEDURES\@MEM_DETECT.ASM`.

Etykieta `@PROC_ADD_BANK` używana jest przez makro `@BANK_ADD` i definiuje adres pod jakim znajdzie się kod programu przełączający bank pamięci rozszerzonej.

Programista może odczytać wartość licznika banków, który został przypisany etykiecie za pomocą operatora `=`, np.:

```
label

 ldy #=label
```

W w/w przykładzie do rejestru regY zapisaliśmy wartość licznika banków pamięci **MADS** przypisany etykiecie `LABEL`.

Jeśli licznik banków **MADS** `= 0` to:

* kod programu musi znajdować się poza obszarem `$4000..$7FFF`
* nowo zdefiniowane etykiety w tym obszarze są globalne
* można odwoływać się do wszystkich zdefiniowanych etykiet bez ograniczeń, bez względu na numer banku
* skok w obszar banku możliwy przy użyciu makra `@BANK_JMP`, przykład w pliku `..\EXAMPLES\MACROS\@BANK_JMP.MAC`, parametr dla tego makra nie musi być poprzedzony operatorem `:`

Jeśli licznik banków **MADS** `> 0` to:

* kod programu musi znajdować się w obszarze `$4000..$7FFF`
* nowo zdefiniowane etykiety w tym obszarze są lokalne
* można odwoływać się tylko do etykiet globalnych i tych zdefiniowanych w obszarze aktualnego banku
* pseudo rozkaz `LMB` `NMB` powoduje wykonanie makra `@BANK_ADD`, które włącza nowy bank rozszerzonej pamięci na podstawie licznika banków MADS-a oraz ustawia nowy adres asemblacji (domyślnie na `$4000`)
* pseudo rozkaz `RMB` powoduje wyzerowanie licznika banków pamięci **MADS** oraz ustawienie nowego adresu asemblacji poza bankiem (domyślnie na `$8000`)
* skok w obszar innego banku możliwy przy użyciu makra `@BANK_JMP`, przykład w pliku `..\EXAMPLES\MACROS\@BANK_JMP`, parametr dla tego makra musi być poprzedzony operatorem `:`

Przykładem wykorzystania tego trybu pracy **MADS** jest plik `..\EXAMPLES\XMS_BANKS.ASM`. W tym przykładzie kod programu znajduje się w dwóch różnych bankach rozszerzonej pamięci i wykonuje się jakby był jedną całością.
