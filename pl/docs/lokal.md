## Obszar lokalny

Głównym zadaniem obszaru lokalnego w **MADS** jest stworzenie nowej przestrzeni nazw dla etykiet.

Wszelkie etykiety zdefiniowane w obszarze lokalnym `.LOCAL` są zasięgu lokalnego, można je też określić jako etykiety globalne zdefiniowane lokalnie o dostępie swobodnym, ponieważ można się do nich odwoływać co nie jest normalne w innych językach programowania.

Obszary lokalne są addytywne tzn. że może być wiele bloków `.LOCAL` o tej samej nazwie, nie zostanie wygenerowany komunikat błędu _**Label ... declared twice**_.

Addytywność obszarów lokalnych odbywa się na aktualnym poziomie przestrzeni nazw, jeśli chcemy połączyć się z wybranym obszarem lokalnym w innej przestrzeni nazw, poprzedzamy pełną nazwę prowadzącą do takiego obszaru znakiem `+`, np.:

```
  .local lvl

tmp = 3

  .endl



  .local temp

tmp = 7


    .local +lvl

      .print tmp

    .endl


  .endl

```

Dla w/w przykładu zostanie wyświetlona wartość etykiety `TMP` z obszaru lokalnego `LVL` o wartości `3`. Gdyby zabrakło znaku `+` w `.LOCAL +LVL` wówczas wartość `TMP` jaka zostanie wyświetlona to `7`.

W obszarze lokalnym `.LOCAL` istnieje możliwość zdefiniowania etykiet o zasięgu globalnym (patrz rozdział [Etykiety globalne](#globalne)).

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze lokalnym `.LOCAL`, wówczas **MADS** będzie poszukiwał ją w obszarze niższym aż dojdzie do obszaru globalnego. Aby odczytać natychmiastowo wartość etykiety globalnej z poziomu obszaru lokalnego `.LOCAL` (czy też innego obszaru lokalnego) poprzedzamy nazwę etykiety znakiem dwukropka `:`.

Obszarów lokalnych dotyczą n/w dyrektywy:

```
 [name] .LOCAL [,address]
 .LOCAL [name] [,address]
 .ENDL [.LEND] [.END]
```

### [name] .LOCAL [,address]

Deklaracja obszaru lokalnego o nazwie `name` za pomocą dyrektywy `.LOCAL`. Nazwa obszaru nie jest wymagana i nie jest konieczna. Do nazw obszarów lokalnych nie można używać nazw mnemoników i pseudo rozkazów. Jeśli nazwa jest zarezerwowana wystąpi błąd z komunikatem _**Reserved word**_.

Po nazwie obszaru lokalnego (lub po dyrektywie `.LOCAL`) możemy podać nowy adres asemblacji bloku lokalnego. Po zakończeniu takiego bloku (`.ENDL`) przywracany jest poprzedni adres asemblacji zwiększony o długość bloku lokalnego.

```
label .local,$4000
.endl

.local label2,$8000
.endl

.local
.endl

.local label3
.endl
```

Wszelkie definicje etykiet w obszarze `.LOCAL` są typu lokalnego. Aby odwołać się do etykiety globalnej o tej samej nazwie co etykieta lokalna należy poprzedzić ją znakiem dwukropka `:`, np.:

```
lab equ 1

.local

lab equ 2

 lda #lab
 ldx #:lab

.endl
```

W w/w przykładzie do rejestru `A` zostanie załadowana wartość `2`, natomiast do rejestru `X` wartość `1`.

Jeśli poszukiwana przez assembler etykieta nie wystąpiła w obszarze `.LOCAL`, wówczas nastąpi jej szukanie w obszarze makra (jeśli jest aktualnie przetwarzane), potem w procedurze (jeśli procedura jest aktualnie przetwarzana), na końcu w głównym programie.

W zadeklarowanym obszarze lokalnym wszystkie definicje etykiet rozróżniane są na podstawie nazwy obszaru lokalnego. Aby dotrzeć do zdefiniowanej etykiety w obszarze lokalnym spoza obszaru lokalnego musimy znać nazwę obszaru i etykiety w nim występującej, np.:

```
 lda #name.lab1
 ldx #name.lab2

.local name

lab1 = 1
lab2 = 2

.endl
```

W adresowaniu takiej struktury `.LOCAL` używamy znaku kropki `.`.

Obszary lokalne możemy zagnieżdżać, możemy je umieszczać w ciele procedur zadeklarowanych przez dyrektywę `.PROC`. Obszary lokalne są addytywne, tzn. może istnieć wiele obszarów lokalnych o tej samej nazwie, wszystkie symbole występujące w tych obszarach należeć będą do wspólnej przestrzeni nazw.

Długość wygenerowanego kodu w bloku `.LOCAL` można sprawdzić przy pomocy dyrektywy `.LEN` (`.SIZEOF`).

### .ENDL
Dyrektywa `.ENDL` kończy deklarację obszaru lokalnego.

Przykład deklaracji obszaru lokalnego:

```
 org $2000

tmp ldx #0   <-------------   etykieta w obszarze globalnym
                          |
 lda obszar.pole  <---    |   odwolanie do obszaru lokalnego
                     |    |
.local obszar        |    |   deklaracja obszaru lokalnego
                     |    |
 lda tmp   <---      |    |
              |      |    |
 lda :tmp     |      | <---   odwolanie do obszaru globalnego
              |      |
tmp nop    <---      |        definicja w obszarze lokalnym
                     |
pole lda #0       <---   <--- definicja w obszarze lokalnym
                            |
 lda pole  <----------------- odwolanie w obszarze lokalnym

.endl                        koniec deklaracji obszaru lokalnego
```

