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