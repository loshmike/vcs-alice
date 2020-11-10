.ifndef VSYNC
.include "atari2600.inc"
.endif
.include "bank.inc"
.include "ram.inc"
.include "sprites.inc"
.include "playfield.inc"

.org $3000
.segment "BANK1"
Reset1:
   bit BANK0
   nop
   nop
   nop
   nop
   nop
   nop
   ; Bank 1 entry:
   jmp start_bank1
   bit BANK2

   ; Score digits
digits1_1:
   DIGITS_1

digits02_1:
   DIGITS_02

start_bank1:
   lda #<falling_sprites_1
   sta PTR1
   lda #>falling_sprites_1
   sta PTR1+1
   lda #0
   sta OFFSET
   sta JUMP_CD
   sta RELEASED
   sta START
   sta COUNTER
   sta COLUBK
   lda #$10 ; dark brown
   sta COLUPF

level2:

; Start of vertical blank processing
   lda #0
   sta VBLANK
   sta PF0
   sta PF1
   sta PF2

   lda #2
   sta VSYNC
; 3 scanlines of VSYNCH signal...
   sta WSYNC
   lda START
   bne @started
   ldx #6
   stx START
:  dex
   bne :-
   sta RESP0
@started:
   sta WSYNC
   sta WSYNC
   lda #0
   sta VSYNC

; 37 scanlines of vertical blank...

   ldx #35
@vblank_loop:
   sta WSYNC
   dex
   bne @vblank_loop

   lda #0
   sta PF2_R
   ldx COUNTER
   lda level1_terrain,x
   sec
   ror
   rol PF2_R
   sec
   ror
   sta PF1_R
   rol PF2_R
   sta WSYNC

; 192 scanlines of picture...

   SCORE digits1_1, digits02_1
   lda #$10 ; dark brown
   sta COLUPF

   ; First 8 lines: just playfield
   ldx #0
   ldy #8
@top8:
   sta WSYNC
   lda PF1_R
   sta PF1
   lda PF2_R
   sta PF2
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   dey
   bne @top8
   inx
   lda level1_terrain,x
   sec
   ror
   rol PF2_R
   sec
   ror
   sta PF1_R
   sta PF1
   rol PF2_R
   lda PF2_R
   sta PF2
   lda (PTR1),y
   sta COLUP0
   iny
   lda (PTR1),y
   sta GRP0
   iny
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2

   ; Lines 8-23: playfield + sprite
@start_alice:
   sta WSYNC
@start_alice_skip_wsync:
   lda PF1_R
   sta PF1
   lda PF2_R
   sta PF2
   lda (PTR1),y
   sta COLUP0
   iny
   lda (PTR1),y
   sta GRP0
   iny
   lda PF1_R
   eor #$ff
   nop
   nop
   nop
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   cpy #16
   bmi @start_alice
   bne @check_end
   inx
   lda #0
   sta PF2_R
   lda level1_terrain,x
   sec
   ror
   rol PF2_R
   sec
   ror
   sta PF1_R
   sta PF1
   rol PF2_R
   lda PF2_R
   sta PF2
   iny
   lda (PTR1),y
   sta GRP0
   lda #$96
   sta COLUP0
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   iny
   jmp @start_alice
@check_end:
   cpy #32
   bne @start_alice
   inx
   lda #0
   sta PF2_R
   sta GRP0
   lda level1_terrain,x
   sec
   ror
   rol PF2_R
   sec
   ror
   sta PF1_R
   sta PF1
   rol PF2_R
   lda PF2_R
   sta PF2
   nop
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   sta WSYNC

   ldy #7
   jmp @below_row_skip_wsync
@below_row_loop:
   sta WSYNC
@below_row_skip_wsync:
   lda PF1_R
   sta PF1
   lda PF2_R
   sta PF2
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   nop
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   dey
   cpy #0
   bne @below_row_loop
   inx
   cpx #22
   beq @end_screen
   lda #0
   sta PF2_R
   lda level1_terrain,x
   sec
   ror
   rol PF2_R
   sec
   ror
   sta PF1_R
   sta PF1
   rol PF2_R
   lda PF2_R
   sta PF2
   nop
   nop
   nop
   nop
   nop
   lda PF1_R
   eor #$ff
   sta PF1
   lda PF2_R
   eor #$0f
   sta PF2
   ldy #7
   jmp @below_row_loop

@end_screen:
   sta WSYNC
   lda #%00000010
   sta VBLANK                     ; end of screen - enter blanking

; 30 scanlines of overscan...
   ldx #30
@oscan_loop:
   sta WSYNC
   dex
   bne @oscan_loop

   jmp level2

; Graphics Data

level1_terrain:
.byte $F0
.byte $F0
.byte $F0
.byte $E0
.byte $C0
.byte $C0
.byte $E0
.byte $E0
.byte $F0
.byte $F8
.byte $F8
.byte $FC
.byte $FE
.byte $FE
.byte $FE
.byte $FC
.byte $FC
.byte $FC
.byte $F8
.byte $F8
.byte $F8
.byte $F0
.byte $E0
.byte $C0
.byte $80
.byte $00
.byte $00
.byte $00
.byte $00
.byte $80
.byte $80
.byte $C0
.byte $E0
.byte $F0
.byte $F8
.byte $FC
.byte $FE
.byte $FF
.byte $F0
.byte $C0
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $80
.byte $80
.byte $E0
.byte $F8
.byte $FE
.byte $FE
.byte $FF
.byte $FF
.byte $FF
.byte $FE
.byte $FE
.byte $FC
.byte $FC
.byte $FC
.byte $F8
.byte $F8
.byte $F8
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F0
.byte $F8


falling_sprites_1:
FALLING_SPRITES


.org $3FFA
.segment "VECTORS1"
.word Reset1          ; NMI
.word Reset1          ; RESET
.word Reset1          ; IRQ
