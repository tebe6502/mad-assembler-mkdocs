## Makro rozkazy

 [REQ, RNE, RPL, RMI, RCC, RCS, RVC, RVS](#req)

 [SEQ, SNE, SPL, SMI, SCC, SCS, SVC, SVS](#seq)

 [JEQ, JNE, JPL, JMI, JCC, JCS, JVC, JVS](#jeq)

 [ADD, SUB](#add)

 [ADB, SBB](#adb)

 [ADW, SBW](#adw)

 [PHR, PLR](#phr)

 [INW, INL, IND, DEW, DEL, DED](#inw)

 [MVA, MVX, MVY](#mva)

 [MWA, MWX, MWY](#mwa)

 [CPB, CPW, CPL, CPD](#cpb)

Zadaniem makro rozkazów jest skrócenie czasu pisania programu i samego listingu. Makro rozkazy zastępują grupy często powtarzających się mnemoników.

<a name="req"></a>
### REQ, RNE, RPL, RMI, RCC, RCS, RVC, RVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok do poprzednio asemblowanej instrukcji, np.:

```
   lda:cmp:req 20           ->      lda 20
                            -> wait cmp 20
                            ->      beq wait

   ldx #0                   ->      ldx #0
   mva:rne $500,x $600,x+   -> loop lda $500,x
                            ->      sta $600,x
                            ->      inx
                            ->      bne loop
```

<a name="seq"></a>
### SEQ, SNE, SPL, SMI, SCC, SCS, SVC, SVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok do następnej asemblowanej instrukcji, np.:

```
   lda #40         ->       lda #40
   add:sta  $80    ->       clc
   scc:inc  $81    ->       adc $80
                   ->       sta $80
                   ->       bcc skip
                   ->       inc $81
                   ->  skip
```

<a name="jeq"></a>
### JEQ, JNE, JPL, JMI, JCC, JCS, JVC, JVS

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`. Posiadają dodatkową właściwość jaką jest skok warunkowy pod wskazany adres, z ich pomocą możemy skakać nie tylko w zakresie -128..+127 bajtów ale w całym zakresie **64kB** np.:

```
 jne dest   ->  beq *+4
            ->  jmp dest
```

Jeśli skok jest krótki (zakres -128..+127) wówczas **MADS** użyje krótkiego skoku, odpowiednio `BEQ`, `BNE`, `BPL`, `BMI`, `BCC`, `BCS`, `BVC`, `BVS`.

<a name="addq"></a>
### ADD, SUB

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie bajtu pamięci bez zapisywania wyniku (wynik w akumulatorze *CPU*).

```
  ADD -> CLC         SUB -> SEC
      -> ADC ...         -> SBC ...
```

<a name="adb"></a>
### ADB, SBB

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie bajtu pamięci z zapisaniem wyniku.

```
  ADB SRC #$40 -> LDA SRC       ADB A B C  -> LDA A
               -> CLC                      -> CLC
               -> ADC #$40                 -> ADC B
               -> STA SRC                  -> STA C

  SBB SRC #$80 -> LDA SRC       SBB A B C  -> LDA A
               -> SEC                      -> SEC
               -> SBC #$80                 -> SBC B
               -> STA SRC                  -> STA C
```

<a name="adw"></a>
### ADW, SBW

W/w makro rozkazy realizują odpowiednio zwiększenie/zmniejszenie słowa pamięci z zapisaniem wyniku.

```
  ADW SRC #$40 -> CLC             ADW A B C  -> CLC
               -> LDA SRC                    -> LDA A
               -> ADC #$40                   -> ADC B
               -> STA SRC                    -> STA C
               -> SCC                        -> LDA A+1
               -> INC SRC+1                  -> ADC B+1
                                             -> STA C+1

  ADW SRC #$40 SRC -> CLC
                   -> LDA SRC
                   -> ADC #$40
                   -> STA SRC
                   -> LDA SRC+1
                   -> ADC #$00
                   -> STA SRC+1

  SBW SRC #$4080 -> SEC           SBW A B C  -> SEC
                 -> LDA SRC                  -> LDA A
                 -> SBC <$4080               -> SBC B
                 -> STA SRC                  -> STA C
                 -> LDA SRC+1                -> LDA A+1
                 -> SBC >$4080               -> SBC B+1
                 -> STA SRC+1                -> STA C+1
```

<a name="phr"></a>
### PHR, PLR

W/w makro rozkazy swoimi nazwami nawiązują do odpowiednich mnemoników *6502*, odpowiednio `PHA`, `PLA`, realizują odkładanie na stosie i zdejmowanie ze stosu rejestrów `A`, `X`, `Y`.

```
  PHR  -> PHA         PLR  -> PLA
       -> TXA              -> TAY
       -> PHA              -> PLA
       -> TYA              -> TAX
       -> PHA              -> PLA
```

<a name="inw"></a>
### INW, INL, IND, DEW, DEL, DED

Makro rozkazy `INW`, `INL`, `IND` realizują zwiększenie odpowiednio słowa pamięci (`.WORD`), długiego słowa pamięci (`.LONG`), podwójnego słowa pamięci (`.DWORD`).

Makro rozkazy `DEW`, `DEL`, `DED` realizują zmniejszenie odpowiednio słowa pamięci (`.WORD`), długiego słowa pamięci (`.LONG`), podwójnego słowa pamięci (`.DWORD`) i wykorzystują w tym celu akumulator *CPU* (zawartość akumulatora ulega zmianie po wykonaniu makro rozkazów `DEW`, `DEL`, `DED`).

```
    inw dest  ->       inc dest    ->   inc dest
              ->       bne skip    ->   sne
              ->       inc dest+1  ->   inc dest+1
              ->  skip             ->

    dew dest  ->       lda dest    ->   lda dest
              ->       bne skip    ->   sne
              ->       dec dest+1  ->   dec dest+1
              ->  skip dec dest    ->   dec dest
```

<a name="mva"></a>
### MVA, MVX, MVY

Makro rozkazy `MVA`, `MVX`, `MVY` służą do przenoszenia bajtów (`.BYTE`) pamięci przy pomocy rejestrów *CPU* odpowiednio `A`, `X`, `Y`. Użycie opcji `OPT R+` pozwala na potencjalne skrócenie kodu wynikowego dla następujących po sobie makro rozkazów `MVA`, `MVX`, `MVY`.

```
    lda src    ->  mva src dst
    sta dst    ->

    ldy $10,x  ->  mvy $10,x $a0,x
    sty $a0,x  ->

    ldx #$10   ->  mvx #$10 dst
    stx dst    ->
```

<a name="mwa"></a>
### MWA, MWX, MWY

Makro rozkazy `MWA`, `MWX`, `MWY` służą do przenoszenia słów (`.WORD`) pamięci przy pomocy rejestrów *CPU* odpowiednio `A`, `X`, `Y`. Użycie opcji `OPT R+` pozwala na potencjalne skrócenie kodu wynikowego dla następujących po sobie makro rozkazów `MWA`, `MWX`, `MWY`.

```
    ldx <adr    ->  mwx #adr dst
    stx dst     ->
    ldx >adr    ->
    stx dst+1   ->

    mwa #0 $80  ->  lda #0           mwy #$3040 $80  ->  ldy <$3040
                ->  sta $80                          ->  sty $80
                ->  sta $81                          ->  ldy >$3040
                                                     ->  sty $81

    mwa ($80),y $a000,x  ->  lda ($80),y
                         ->  sta $a000,x
                         ->  iny
                         ->  lda ($80),y
                         ->  sta $a001,x
```

<a name="cpb"></a>
### CPB, CPW, CPL, CPD

Makro rozkazy `CPB`, `CPW`, `CPL`, `CPD` realizują porównanie wartości odpowiednich typów, odpowiednio `.BYTE`, `.WORD`, `.LONG`, `.DWORD`.

```
 cpw temp #$4080
 bcc skip

 cpd v0 v1
 beq skip
```
