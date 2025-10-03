;;----------LICENSE NOTICE-------------------------------------------------------------------------------------------------------;;
;;  This file is part of GBTelera: A Gameboy Development Framework                                                               ;;
;;  Copyright (C) 2024 ronaldo / Cheesetea / ByteRealms (@FranGallegoBR)                                                         ;;
;;                                                                                                                               ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ;;
;; files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,    ;;
;; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the         ;;
;; Softwareis furnished to do so, subject to the following conditions:                                                           ;;
;;                                                                                                                               ;;
;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.;;
;;                                                                                                                               ;;
;; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ;;
;; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ;;
;; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ;;
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         ;;
;;-------------------------------------------------------------------------------------------------------------------------------;;


def VRAM_TILE_START equ $8000
def VRAM_TILE_SIZE equ $10
def VRAM_PLAYER_SPRITE equ VRAM_TILE_START + ($40 * VRAM_TILE_SIZE)
def rBGP equ $FF47

SECTION "Tile Data", ROM0

Mr_floor_sprite:
DB $00, $00, $0F, $0F, $10, $1F, $10, $1F, $10, $10, $10, $10, $14, $19, $14, $10
DB $00, $00, $00, $00, $F0, $F0, $08, $F8, $08, $78, $08, $78, $08, $38, $08, $08
DB $10, $12, $08, $08, $0B, $0D, $11, $17, $19, $16, $08, $0F, $05, $07, $0F, $09
DB $08, $38, $F0, $30, $88, $78, $08, $C8, $38, $C8, $10, $F0, $D0, $F0, $F0, $90



SECTION "Entry point", ROM0[$150]


memcpy:
   ld a, [hl+]
   ld [de], a
   inc de
   dec c
jr nz, memcpy
ret


wait_vblank_start:
   ld hl, $FF44
   ld a, $90
   .do:
      cp [hl]
   jr nz, .do
ret


main::

   call wait_vblank_start

   ;; Cargamos la paleta
   ld a, %11100100
   ld [rBGP], a

   ld hl, Mr_floor_sprite
   ld de, VRAM_PLAYER_SPRITE
   ld c, VRAM_TILE_SIZE * 4
   call memcpy

   ld h, $98
   ld l, $00
   ld a, $40
   ld [hl+], a
   inc a
   ld [hl], a
   ld l, $20
   inc a
   ld [hl+], a
   inc a
   ld [hl], a

   di
   halt
