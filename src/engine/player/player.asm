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
wPlayerIdleTimer:: ds 1      ; contador independiente
wPlayerIdleFrame:: ds 1      ; 0 = base, 1 = alterno   ; 0 = normal, 1 = frame alterno
EXPORT player_data




; =================================================================================
; FUNCTIONALITY
; =================================================================================
SECTION "Player functions", ROM0


   start_move_right:
      call move_entities
      call get_tilemap_pos_player ;now hl = player_pos 
      ld a, 0
      ld [player_data + PLAYER_DIR], a
      call can_move
      ret

   start_move_left:
      call move_entities
      call get_tilemap_pos_player
      ld a, 1
      ld [player_data + PLAYER_DIR], a
      call can_move
      ret

   start_move_up:
      call move_entities
      call get_tilemap_pos_player
      ld a, 2
      ld [player_data + PLAYER_DIR], a
      call can_move
      ret

   start_move_down:
      call move_entities
      call get_tilemap_pos_player
      ld a, 3
      ld [player_data + PLAYER_DIR], a
      call can_move
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
      call wait_vblank_start
      call Flip_sprite_right
      call update_sprite
   jr skip

   move_left:
      ; ld a, [player_data + PLAYER_X]
      ; ld [player_data + PLAYER_PREVIOUS_X], a 
      ld a, [player_data + PLAYER_X]
      sub 16
      ld [player_data + PLAYER_X], a
      call wait_vblank_start
      call Flip_sprite_left
      call update_sprite
   jr skip

   move_up:
      ; ld a, [player_data + PLAYER_Y]
      ; ld [player_data + PLAYER_PREVIOUS_Y], a 
      ld a, [player_data + PLAYER_Y]
      sub 16
      ld [player_data + PLAYER_Y], a
      call wait_vblank_start
      call Flip_sprite_up
      call update_sprite
   jr skip

   move_down:
      ; ld a, [player_data + PLAYER_Y]
      ; ld [player_data + PLAYER_PREVIOUS_Y], a 
      ld a, [player_data + PLAYER_Y]
      add 16
      ld [player_data + PLAYER_Y], a
      call wait_vblank_start
      call Flip_sprite_down
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
   ld a, [player_data + PLAYER_Y]
   ld [$FE00], a
   ld [$FE00 + 4], a
   
   ld a, [player_data + PLAYER_X]
   ld [$FE00 + 1], a
   add 8
   ld [$FE00 + 5], a
ret

;;To flip sprite to right
Flip_sprite_right:
   ld hl, TILE_LEFT_SPRITE
   ld a, [hl]
   cp $2C
   ret z ;;If the sprite is already on this flip, stop the rutine
   ld [hl], $2C

   ld hl, TILE_RIGHT_SPRITE
   ld [hl], $2E
ret

;;To flip sprite to left
Flip_sprite_left:
   ld hl, TILE_LEFT_SPRITE
   ld a, [hl]
   cp $28
   ret z ;;If the sprite is already on this flip, stop the rutine
   ld [hl], $28

   ld hl, TILE_RIGHT_SPRITE
   ld [hl], $2A
ret

;;To flip sprite to left
Flip_sprite_down:
   ld hl, TILE_LEFT_SPRITE
   ld a, [hl]
   cp $30
   ret z ;;If the sprite is already on this flip, stop the rutine
   ld [hl], $30

   ld hl, TILE_RIGHT_SPRITE
   ld [hl], $32
ret

;;To flip sprite to left
Flip_sprite_up:
   ld hl, TILE_LEFT_SPRITE
   ld a, [hl]
   cp $34
   ret z ;;If the sprite is already on this flip, stop the rutine
   ld [hl], $34

   ld hl, TILE_RIGHT_SPRITE
   ld [hl], $36
ret

;==============================================
; IDLE ANIMATION (solo cuando mira hacia abajo)
;==============================================
Player_Idle_Animate::
    ;-------------------------------------------
    ; Si se mueve que se cambie la direccion bien
    ;-------------------------------------------
    ld a, [player_data + PLAYER_ISMOVING]
    or a
    jr nz, .reset_to_direction

    ;-------------------------------------------
    ; Si no mira hacia abajo
    ;-------------------------------------------
    ld a, [player_data + PLAYER_DIR]
    cp 3
    jr nz, .end_no_reset

    ;-------------------------------------------
    ; Si está quieto mirando hacia abajo 
    ;-------------------------------------------
    ld hl, wPlayerIdleTimer
    inc [hl]
    ld a, [hl]
    cp 30
    jr c, .end_no_reset

    xor a
    ld [hl], a

    ; Alternar frame
    ld a, [wPlayerIdleFrame]
    xor 1
    ld [wPlayerIdleFrame], a

    ; Aplica frame correspondiente
    ld a, [wPlayerIdleFrame]
    or a
    jr z, .frame_base

    ; ---- FRAME 1: alterno (idle) ----
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $38
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $3A
    jr .end_no_reset

.frame_base:
    ; ---- FRAME 0: base hacia abajo ----
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $30
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $32
    jr .end_no_reset

;-------------------------------------------
; para resetear la dirección
;-------------------------------------------
.reset_to_direction:
    xor a
    ld [wPlayerIdleTimer], a
    ld [wPlayerIdleFrame], a

    ld a, [player_data + PLAYER_DIR]
    cp 0
    jr z, .right
    cp 1
    jr z, .left
    cp 2
    jr z, .up
    cp 3
    jr z, .down
    jr .end_no_reset

.right:
    call Flip_sprite_right
    jr .end_no_reset

.left:
    call Flip_sprite_left
    jr .end_no_reset

.up:
    call Flip_sprite_up
    jr .end_no_reset

.down:
    call Flip_sprite_down
    jr .end_no_reset

;-------------------------------------------
.end_no_reset:
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



;; CHECK IF THE BLOCKING WHERE HE IS GOING TO MOVE IS SOLID OR NOT, SO IT CAN MOVE OR NOT
can_move::
   cp a, 0
        jr z, check_right
   cp a, 1
      jr z, check_left
   cp a, 2
      jr z, check_up
   cp a, 3
      jr z, check_down


   check_right:
      ld de, $0002
      add hl, de
      call check_solid
      cp a, $FF
      ret nz
      ld a, 0
      call start_move
   ret
   check_left:
      dec hl
      dec hl
      call check_solid
      cp a, $FF
      ret nz
      ld a, 1
      call start_move
   ret
   check_up:
      ld de, $0040
      ld a, l
      sbc e
      jr nc, .next
         dec h
      .next:
      ld l, a
      call check_solid
      cp a, $FF
      ret nz
      ld a, 2
      call start_move
   ret
   check_down:
      ld de, $0040 
      add hl, de
      call check_solid
      cp a, $FF
      ret nz
      ld a, 3
      call start_move
   ret

ret



