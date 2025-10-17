;##############################################################################
; LÓGICA DEL PLAYER:
; - MOVIMIENTO
; - CAMBIAR SPRITE DE POSICION
; - ANIMACIONES
; - ON_DEATH
; - ...
;##############################################################################

include "includes/constants.inc"
include "includes/macros.inc"


include "src/engine/player/player_data.inc"

SECTION "Player Vars", WRAM0

player_data: DS PLAYER_SIZE
EXPORT player_data




; =================================================================================
; FUNCTIONALITY
; =================================================================================
SECTION "Player functions", ROM0


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
      ; ld a, [player_data + PLAYER_X]
      ; ld [player_data + PLAYER_PREVIOUS_X], a  ;saves x pos in previous x
      ld a, [player_data + PLAYER_X]
      add 16
      ld [player_data + PLAYER_X], a
      call update_sprite
   jr skip

   move_left:
      ; ld a, [player_data + PLAYER_X]
      ; ld [player_data + PLAYER_PREVIOUS_X], a 
      ld a, [player_data + PLAYER_X]
      sub 16
      ld [player_data + PLAYER_X], a
      call update_sprite
   jr skip

   move_up:
      ; ld a, [player_data + PLAYER_Y]
      ; ld [player_data + PLAYER_PREVIOUS_Y], a 
      ld a, [player_data + PLAYER_Y]
      sub 16
      ld [player_data + PLAYER_Y], a
      call update_sprite
   jr skip

   move_down:
      ; ld a, [player_data + PLAYER_Y]
      ; ld [player_data + PLAYER_PREVIOUS_Y], a 
      ld a, [player_data + PLAYER_Y]
      add 16
      ld [player_data + PLAYER_Y], a
      call update_sprite
   jr skip

   skip:
      call update_move
   ret

update_move::
   call wait_vblank_start
   ld a, [player_data + PLAYER_TIMER]
   inc a
   ld [player_data + PLAYER_TIMER], a
   cp 5                    ; esperar X frames de cooldown
   jr c, skip_end

   xor a
   ld [player_data + PLAYER_ISMOVING], a   ; termina cooldown
   ld [player_data + PLAYER_TIMER], a

skip_end:
   ret

update_sprite::
   call wait_vblank_start
   ld a, [player_data + PLAYER_Y]
   ld [$FE00], a
   ld [$FE00 + 4], a
   
   ld a, [player_data + PLAYER_X]
   ld [$FE00 + 1], a
   add 8
   ld [$FE00 + 5], a
ret



; by the moment it does nothing because the player dies instantly 
; but it is a good practice to have it created just in case
take_damage::
    call on_player_death
ret

on_player_death::
   ;; Reposiciona al jugador en su punto del principio
   ld a, PLAYER_START_X
   ld [player_data + PLAYER_X], a
   ld a, PLAYER_START_Y
   ld [player_data + PLAYER_Y], a

   ;; Actualiza OAM
   call update_sprite

   ;; reiniciamos su estado
   xor a
   ld [player_data + PLAYER_ISMOVING], a
   ld [player_data + PLAYER_TIMER], a

ret