#

## Detekcja CPU6502, CPU65816

Przykład zaczerpnięty ze [tej](http://www.s-direktnet.de/homepages/k_nadj/cputest.html) strony. Program potrafi zdiagnozować obecność jednego z mikroprocesorów: **6502**, **65C02**, **65816**.

```
/*

How to detect on which CPU the assembler code is running

(This information is from Draco, the author of SYSINFO 2.0)

You can test on plain 6502-Code if there is a 65c816 CPU, the 16-Bit processor avaible
in some XLs as a turbo-board, avaible. Draco told me how to do this:

First we make sure, whether we are running on NMOS-CPU (6502) or CMOS (65c02,65c816).
I will just show the "official" way which doesn`t uses "illegal opcodes":

*/

 org $2000

 opt c+

DetectCPU

 lda #$99
 clc
 sed
 adc #$01
 cld
 beq DetectCPU_CMOS

DetectCPU_02

 ldx #<_6502
 ldy #>_6502
 jsr $c642

 lda #0
 rts

DetectCPU_CMOS

 lda #0
 rep #%00000010     ;wyzerowanie bitu Z
 bne DetectCPU_C816

DetectCPU_C02

 ldx #<_65c02
 ldy #>_65c02
 jsr $c642

 lda #1
 rts

DetectCPU_C816

 ldx <_65816
 ldy >_65816
 jsr $c642

 lda #$80
 rts

_6502   dta c'6502',$9b
_65c02  dta c'65c02',$9b
_65816  dta c'65816',$9b
```

Następny przykład detekcji **CPU**, ogranicza się do określenia obecności mikroprocesora **6502** lub **65816**. Program po disasemblacji inaczej wygląda dla **6502**, inaczej dla **65816**. **6502** rozkaz `inc @` uzna za `nop`, rozkaz `xba` uzna za `sbc #`. Dzięki takiej *przezroczystości* możemy być pewni że program nie wykona żadnej nielegalnej operacji i uczciwie rozpozna właściwy **CPU**. Pomysłodawcą tego zwięzłego i jakże sprytnego testu jest **Ullrich von Bassewitz**.

```
 org $2000

 opt c+                 ; 65816 enabled

 lda #0

 inc @                  ; increment accumulator

 cmp #1
 bcc cpu6502

; ostateczny test na obecnosc 65816

 xba           ; put $01 in B accu
 dec @         ; A=$00 if 65C02
 xba           ; get $01 back if 65816
 inc @         ; make $01/$02

 cmp #2
 bne cpu6502

cpu65816

 ldx <text65816
 ldy >text65816
 jsr $c642
 rts

cpu6502

 ldx <text6502
 ldy >text6502
 jsr $c642
 rts

text6502  dta c'6502',$9b
text65816 dta c'65816',$9b
```