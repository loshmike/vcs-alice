.ifndef VSYNC
.include "atari2600.inc"
.endif
.include "bank.inc"
.include "ram.inc"
.include "sprites.inc"
.include "playfield.inc"

.org $5000
.segment "BANK2"
Reset2:
   bit BANK0
   nop
   nop
   nop
jump_b2_b1:
   bit BANK1
   nop
   nop
   nop
   nop
   nop
   nop
   jmp start_bank2

   ; Graphics Data

digits1_2:
   DIGITS_1

digits02_2:
   DIGITS_02

; Pre-level 1 init

start_bank2:
   lda #0
   sta FRAME_CTR

level3:

; Start of vertical blank processing
   lda #0
   sta VBLANK
   sta PF0
   sta PF1
   sta PF2
   sta GRP0
   sta GRP1

   lda #2
   sta VSYNC
; 3 scanlines of VSYNCH signal...
   sta WSYNC
   sta WSYNC
   sta WSYNC
   lda #0
   sta VSYNC

; 37 scanlines of vertical blank...

   ldx #36
@vblank_loop:
   sta WSYNC
   dex
   bne @vblank_loop

; 192 scanlines of picture...
@score:
   sta WSYNC
   SCORE digits1_2, digits02_2

; just blank
   ldx #176
@screen_loop:
   sta WSYNC
   dex
   bne @screen_loop

; 30 lines overscan
   ldx #29
@oscan_loop:
   sta WSYNC
   dex
   bne @oscan_loop

@finish_oscan:
   sta WSYNC
   jmp level3

; More graphics

.org $5FFA
.segment "VECTORS2"
.word Reset2          ; NMI
.word Reset2          ; RESET
.word Reset2          ; IRQ
