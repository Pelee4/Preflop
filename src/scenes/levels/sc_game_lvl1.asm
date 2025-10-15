;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
; include "data/Maps/lvl1_tilemap_wospliting.inc"
; include "data/Maps/lvl1_tilemap_wospliting.z80"
; include "data/Maps/lvl1_tilemap.z80"


DEF PLAYER_START_X EQU 16
DEF PLAYER_START_Y EQU 16
RSRESET
DEF PLAYER_X        RB 1   ; posición X
DEF PLAYER_Y        RB 1   ; posición Y
DEF PLAYER_ISMOVING RB 1   ; 0 = quieto, 1 = moviéndose
DEF PLAYER_DIR      RB 1   ; 0=RIGHT, 1=LEFT, 2=UP, 3=DOWN
DEF PLAYER_TIMER    RB 1   ; contador de frames
DEF PLAYER_SIZE     RB 0   ; tamaño total (5 bytes)
RSRESET
DEF ENEMY_X         RB 1
DEF ENEMY_Y         RB 1
DEF ENEMY_SIZE      RB 0
SECTION "Player Vars", WRAM0

player_data: DS PLAYER_SIZE
enemy_data: DS ENEMY_SIZE

SECTION "Lvl1 scene", ROM0

sc_game_lvl1::
    call sc_game_lvl1_init
    loop:
        call read_input
        call check_collision
        jr loop
    ret
sc_game_lvl1_init::
    ;;Apagamos Pantallita con el wait_vblank and other stuff
   call lcd_off

   ;;Quitamos logo Nintendo
   MEMSET $9904, 0, 13
   MEMSET $9924, 0, 13
   
   ;;Probando pruebas de fantasmas (como pele) y rocas (como malphite)
   MEMCPY Enemy_Sprite, $8200, $40     ;20 21 22 23
   MEMCPY Rock_Sprite, $8240, $40      ;24 25 26 27
   MEMCPY Mr_floor_sprite, $8280, $40  ;28 29 30 31
   MEMCPY Floor_sprite, $8300, $40  ;32 33 34 35
   memcpy Void_sprite, $8
   ;; MEMCPY Map1, $9800, $89
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
   MEMCPY sprite1_enemy, $FE00 + 8, 4
   MEMCPY sprite2_enemy, $FE00 + 12, 4
   MEMCPY sprite1_floor, $FE00 + 16, 4
   MEMCPY sprite2_floor, $FE00 + 20, 4


    ;; Posición inicial del enemigo
   ld a, 80
   ld [enemy_data + ENEMY_X], a
   ld a, 40
   ld [enemy_data + ENEMY_Y], a
   
   ;; Meter rutina de copia con DMA en la HRAM
   ;; MEMCPY rutinaDMA, OAMDMA, rutinaDMA.fin - rutinaDMA

   ;; GENERO UN BLOQUE DE PRUEBA
   ld a, $24
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
      add 16
      ld [player_data + PLAYER_X], a
      call update_sprite
   jr skip

   move_left:
      ld a, [player_data + PLAYER_X]
      sub 16
      ld [player_data + PLAYER_X], a
      call update_sprite
   jr skip

   move_up:
      ld a, [player_data + PLAYER_Y]
      sub 16
      ld [player_data + PLAYER_Y], a
      call update_sprite
   jr skip

   move_down:
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
   cp 15                      ; esperar 16 frames de cooldown
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

check_collision::
   ;; Carga posiciones del jugador y enemigo
   ld a, [player_data + PLAYER_X]
   ld b, a
   ld a, [player_data + PLAYER_Y]
   ld c, a

   ld a, [enemy_data + ENEMY_X]
   ld d, a
   ld a, [enemy_data + ENEMY_Y]
   ld e, a

   ld a, b
   sub d
   bit 7, a          
   jr z, check_y
   cpl
   inc a
check_y:
   cp 8
   jr nc, no_collision

   ld a, c
   sub e
   bit 7, a
   jr z, collision_check
   cpl
   inc a
collision_check:
   cp 8
   jr nc, no_collision

   ;; Si hay colisión 
   call on_player_death
   jr no_collision

no_collision:
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