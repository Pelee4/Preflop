include "constants.inc"
include "macros.inc"

; ============================================================
; Definición de estructura del jugador
; ============================================================

RSRESET
DEF PLAYER_X        RB 1   ; posición X
DEF PLAYER_Y        RB 1   ; posición Y
DEF PLAYER_ISMOVING RB 1   ; 0 = quieto, 1 = moviéndose
DEF PLAYER_DIR      RB 1   ; 0=RIGHT, 1=LEFT, 2=UP, 3=DOWN
DEF PLAYER_TIMER    RB 1   ; contador de frames
DEF PLAYER_SIZE     RB 0   ; tamaño total (5 bytes)

SECTION "Player Vars", WRAM0

player_data: DS PLAYER_SIZE


SECTION "Entry point", ROM0[$150]

main::
   
   call game_init
   loop:
      call read_input
      jr loop
   di
   halt

game_init:

   ;;Apagamos Pantallita con el wait_vblank and other stuff
   call lcd_off

   ;;Quitamos logo Nintendo
   MEMSET $9904, 0, 13
   MEMSET $9924, 0, 13
   
   ;;Probando pruebas de fantasmas (como david) y rocas (como malphite)
   MEMCPY Enemy_Sprite, $8200, $40     ;20 21 22 23
   MEMCPY Rock_Sprite, $8240, $40      ;24 25 26 27
   MEMCPY Mr_floor_sprite, $8280, $40  ;28 29 30 31

   ;;Paleteamos Paletas
   ld hl, rBGP
   ld [hl], %11100100

   ld hl, rOBJP
   ld [hl], %11100100

   ;;Activamos Sprites y los hacemos de 8x16
   ld hl, rLCDC
   set 1, [hl]
   set 2, [hl]


   ;;Ponemos OAM a 00
   MEMSET $FE00, 0, 160

   ;;Ponemos player data a 0
   ld a, 16
   ld [player_data + PLAYER_Y], a
   ld a, 16
   ld [player_data + PLAYER_X], a
   ld a, 0
   ld [player_data + PLAYER_ISMOVING], a
   ld a, 3
   ld [player_data + PLAYER_DIR], a
   ld a, 0
   ld [player_data + PLAYER_TIMER], a

   MEMCPY sprite1_player, $FE00, 4
   MEMCPY sprite2_player, $FE00 + 4, 4

   ;; Meter rutina de copia con DMA en la HRAM
   ;; MEMCPY rutinaDMA, OAMDMA, rutinaDMA.fin - rutinaDMA

   ;ld a, $20
   ;ld hl, $990A
   ;ld [hl], a
   ;inc a
   ;ld hl, $992A
   ;ld [hl], a
   ;inc a
   ;ld hl, $990B
   ;ld [hl], a
   ;inc a
   ;ld hl, $992B
   ;ld [hl], a

   ;ld a, $24
   ;ld hl, $994A
   ;ld [hl], a
   ;inc a
   ;ld hl, $996A
   ;ld [hl], a
   ;inc a
   ;ld hl, $994B
   ;ld [hl], a
   ;inc a
   ;ld hl, $996B
   ;ld [hl], a




   ;;Encendemos Pantallita
   call lcd_on
   
ret


read_input::

   ld a, [player_data + PLAYER_ISMOVING]
   cp 0
   jr nz, moving

   ld a, SELECT_PAD
   ld [rJOYP], a
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]


   bit RIGHT_PRESSED, a
   jr z, start_move_right

   bit LEFT_PRESSED, a
   jr z, start_move_left

   bit UP_PRESSED, a
   jr z, start_move_up

   bit DOWN_PRESSED, a
   jr z, start_move_down

   ret

   start_move_right:
      ld a, 0
      ld [player_data + PLAYER_DIR], a
      call start_move
      ret

   start_move_left:
      ld a, 1
      ld [player_data + PLAYER_DIR], a
      call start_move
      ret

   start_move_up:
      ld a, 2
      ld [player_data + PLAYER_DIR], a
      call start_move
      ret

   start_move_down:
      ld a, 3
      ld [player_data + PLAYER_DIR], a
      call start_move
      ret

   moving:
      call update_move
      ret

start_move::
   ld a, 1
   ld [player_data + PLAYER_ISMOVING], a
   xor a
   ld [player_data + PLAYER_TIMER], a
ret

update_move::

   ld a, [player_data + PLAYER_TIMER]
   cp 15
   jr z, finish_move

   ld a, [player_data + PLAYER_DIR]
   cp 0                   ; RIGHT
   jr z, move_right
   cp 1                   ; LEFT
   jr z, move_left
   cp 2                   ; UP
   jr z, move_up
   cp 3                   ; DOWN
   jr z, move_down
   
   jr skip

   move_right:
      ld a, [player_data + PLAYER_X]
      inc a
      ld [player_data + PLAYER_X], a
   jr skip

   move_left:
      ld a, [player_data + PLAYER_X]
      dec a
      ld [player_data + PLAYER_X], a
   jr skip

   move_up:
      ld a, [player_data + PLAYER_Y]
      dec a
      ld [player_data + PLAYER_Y], a
   jr skip

   move_down:
      ld a, [player_data + PLAYER_Y]
      inc a
      ld [player_data + PLAYER_Y], a
   jr skip

   skip:
      ld a, [player_data + PLAYER_TIMER]
      inc a
      ld [player_data + PLAYER_TIMER], a

      call update_player_sprite
   ret

   finish_move:
      ld a, [player_data + PLAYER_DIR]
      cp 0
      jr z, snap_right
      cp 1
      jr z, snap_left
      cp 2
      jr z, snap_up
      cp 3
      jr z, snap_down
   jr done

   snap_right:
      ld a, [player_data + PLAYER_X]
      and %11110000
      add 16
      ld [player_data + PLAYER_X], a
   jr done

   snap_left:
      ld a, [player_data + PLAYER_X]
      and %11110000
      ld [player_data + PLAYER_X], a
   jr done

   snap_up:
      ld a, [player_data + PLAYER_Y]
      and %11110000
      ld [player_data + PLAYER_Y], a
   jr done

   snap_down:
      ld a, [player_data + PLAYER_Y]
      and %11110000
      add 16
      ld [player_data + PLAYER_Y], a
   jr done

   done:
      xor a
      ld [player_data + PLAYER_ISMOVING], a
      call update_player_sprite
   ret

update_player_sprite::
   call wait_vblank_start
   ld a, [player_data + PLAYER_Y]
   ld [$FE00], a          ; sprite 1 Y
   ld [$FE00 + 4], a      ; sprite 2 Y

   ld a, [player_data + PLAYER_X]
   ld [$FE00 + 1], a      ; sprite 1 X
   add 8                  ; el segundo está a +8 px
   ld [$FE00 + 5], a      ; sprite 2 X
ret



;; Input:  D (HIGH byte of the region to copy)
;; rutinaDMA:
;;      ld a, HIGH(copiaOAM) ;; activates the copy of the given region XX00
;;      ldh [$FF46], a 
;;      ld a, 40
;;   .espera:
;;      dec a
;;      jr nz, .espera
;;      ret
;;   .fin
;;
;; SECTION "Copia OAM", WRAM0, ALIGN[8]
;; copiaOAM::
;; DS 6*4 ;;Numero de Sprites * 4
;;
;; SECTION "OAM DMA", HRAM
;; OAMDMA:: 
;; DS rutinaDMA.fin - rutinaDMA