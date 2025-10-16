;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl1 scene", ROM0

sc_game_lvl1::
    call sc_game_lvl1_init
    loop:
        call read_input
        call check_collision
        jr loop
    ret
sc_game_lvl1_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   
   ;MAP DRAW
   MEMCPY_2 map1, $9800, 576

   

   ;DRAW PLAYER AND ENEMIES
   MEMCPY Mr_floor_sprite, $8280, $40  ;28 29 30 31
   MEMCPY Enemy_Sprite, $8200, $40     ;20 21 22 23



   ;;PALETTES
   ld hl, rBGP
   ld [hl], %11100100

   ld hl, rOBJP
   ld [hl], %11100100

   ;;ACTIVATE SPRITES AND MAKE THEM 8x16
   ld hl, rLCDC
   set 1, [hl]
   set 2, [hl]


   ;;PUT OAM TO 00
   MEMSET $FE00, 0, 160

   ;;INITIALIZE PLAYER_DATA ON 0
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
   ld a, 0
   ld [player_data + PLAYER_INTERACTION_BOOL], a


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player, $FE00, 4
   MEMCPY sprite2_player, $FE00 + 4, 4
   ; - ENEMIES
   MEMCPY sprite1_enemy, $FE00 + 8, 4
   MEMCPY sprite2_enemy, $FE00 + 12, 4
 


    ;; ENEMIES INITIAL POSITION
   ld a, 80
   ld [enemy_data + ENEMY_X], a
   ld a, 40
   ld [enemy_data + ENEMY_Y], a
   



   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on
ret


