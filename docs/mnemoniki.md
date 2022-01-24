#

## Dostępne rozkazy 6502

```none
LDA   LDX   LDY   STA   STX   STY   ADC   AND
ASL   SBC   JSR   JMP   LSR   ORA   CMP   CPY
CPX   DEC   INC   EOR   ROL   ROR   BRK   CLC
CLI   CLV   CLD   PHP   PLP   PHA   PLA   RTI
RTS   SEC   SEI   SED   INY   INX   DEY   DEX
TXA   TYA   TXS   TAY   TAX   TSX   NOP   BPL
BMI   BNE   BCC   BCS   BEQ   BVC   BVS   BIT
```

Możliwe jest użycie rozszerzenia mnemonika po znaku kropki `.` dla rozkazów typu `LDA` `LDX` `LDY` `STA` `STX` `STY`:

```
.b lub .z          BYTE
.a lub .w lub .q   WORD
```

np.

```
lda.w $80   ; AD 80 00
lda   $80   ; A5 80
```

## Dostępne nielegalne rozkazy 6502

```
ASO   RLN   LSE   RRD   SAX   LAX   DCP   ISB
ANC   ALR   ARR   ANE   ANX   SBX   LAS   SHA
SHS   SHX   SHY   NPO   CIM
```

## Dostępne rozkazy 65816

Oczywiście dostępne są rozkazy *6502*, a oprócz nich:

```
STZ   SEP   REP   TRB   TSB   BRA   COP   MVN
MVP   PEA   PHB   PHD   PHK   PHX   PHY   PLB
PLD   PLX   PLY   RTL   STP   TCD   TCS   TDC
TSC   TXY   TYX   WAI   WDM   XBA   XCE   INA
DEA   BRL   JSL   JML
```
Możliwe jest użycie rozszerzenia mnemonika w stylu **XASM** `a:` `z:` `r:` np.:

```
XASM        MADS
lda a:0     lda.a 0
ldx z:0     lda.z 0

org r:$40   org $40,*
```

Możliwe jest użycie rozszerzenia mnemonika po znaku kropki `.` dla rozkazów typu `LDA` `LDX` `LDY` `STA` `STX` `STY`:

```
.b lub .z          BYTE
.a lub .w lub .q   WORD
.t lub .l          TRIPLE, LONG (24bit)
```

np.

```
lda.w #$00   ; A9 00 00
lda   #$80   ; A9 80
```

Wyjątki stanowią rozkazy n/w, którym nie można zmienić rozmiaru rejestru w adresowaniu absolutnym (niektóre assemblery nie wymagają dla tych rozkazów podania znaku `#`, jednak **MADS** wymaga tego):

* `#$xx` dla `SEP` `REP` `COP`

* `#$xxxx` dla `PEA`

Innym wyjątkiem jest tryb adresowania pośredni długi, który reprezentowany jest przez nawiasy kwadratowe `[]`. Jak wiemy tego typu nawiasy wykorzystywane są też do obliczania wyrażeń, jednak jeśli asembler napotka pierwszy znak `[` uzna to za tryb adresowania pośredni długi i jeśli nie zasygnalizowaliśmy chęci używania *65816* wystąpi błąd z komunikatem **Illegal adressing mode**. Aby *oszukać* assembler wystarczy dać przed kwadratowym nawiasem otwierającym `[` znak `+`.

```
lda [2+4]     ; lda [6]
lda +[2+4]    ; lda 6
```
