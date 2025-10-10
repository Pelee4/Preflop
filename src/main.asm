include "constants.inc"
include "macros.inc"

SECTION "Entry point", ROM0[$150]

main::
   
   call game_init
   
   di
   halt

game_init:

   ;;Apagamos Pantallita con el wait_vblank and other stuff
   call lcd_off

   ;;Quitamos logo Nintendo
   MEMSET $9904, 0, 13
   MEMSET $9924, 0, 13

   ;;Paleteamos Paletas
   ld hl, rBGP
   ld [hl], %11100100

   ld hl, rOBJP
   ld [hl], %11100100

   ;;Probando pruebas de fantasmas (como david) y rocas (como malphite)
   MEMCPY Enemy_Sprite, $8200, $40
   MEMCPY Rock_Sprite, $8260, $40

   ld a, $20
   ld hl, $990A
   ld [hl], a
   inc a
   ld hl, $992A
   ld [hl], a
   inc a
   ld hl, $990B
   ld [hl], a
   inc a
   ld hl, $992B
   ld [hl], a


   ld a, $26
   ld hl, $994A
   ld [hl], a
   inc a
   ld hl, $996A
   ld [hl], a
   inc a
   ld hl, $994B
   ld [hl], a
   inc a
   ld hl, $996B
   ld [hl], a




   ;;Encendemos Pantallita
   call lcd_on
   
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;OAM DMA STUFF

SECTION "Copia OAM", WRAM0, ALIGN[8]
copiaOAM::
DS 8 ;;Numero de Sprites * 4

SECTION "Rutina DMA", ROM0

;; Input:  D (HIGH byte of the region to copy)
rutinaDMA:
    ld a, HIGH(copiaOAM) ;; activates the copy of the given region XX00
    ldh [rDMA], a 
    ld a, 40
    .espera:
        dec a
    jr nz, .espera
    ret
.fin

SECTION "OAM DMA", HRAM
OAMDMA:: 
   DS rutinaDMA.fin - rutinaDMA

SECTION "Utils 2", ROM0