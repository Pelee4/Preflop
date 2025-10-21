;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl4 scene", ROM0

sc_game_lvl4::
    call sc_game_lvl4_init
    loop_lvl4:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update 
        jr loop_lvl4
    ret
sc_game_lvl4_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   
   ;MAP DRAW
   MEMCPY_2 map4, $9800, 576

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
   ld a, 48
   ld [player_data + PLAYER_Y], a
   ld a, 24
   ld [player_data + PLAYER_X], a
   ld a, 0
   ld [player_data + PLAYER_ISMOVING], a
   ld a, 3
   ld [player_data + PLAYER_DIR], a
   ld a, 0
   ld [player_data + PLAYER_TIMER], a
   ld a, 0
   ld [player_data + PLAYER_INT_BOOL], a
   ld a, 4
   ld [player_data + PLAYER_LEVEL], a


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player_l4, $FE00, 4
   MEMCPY sprite2_player_l4, $FE00 + 4, 4
 
   ; --- HUD sprite ---
   ; define HUD en $FE00+16
   ; por ahora ponlo fuera de pantalla (oculto)
   ld a,0              ; Y = 0 --> oculto
   ld [$FE00+16],a
   ld a,160            ; X = da igual oculto
   ld [$FE00+17],a
   ld a,$7C            ; tile HUD (el tile del icono HUD, el existente en MEMCPY Hud)
   ld [$FE00+18],a
   ld a,%00000000      ; attr
   ld [$FE00+19],a





   ; ENEMIES DATA
   ld a, 48
   ld [enemy_data + ENEMY_X], a
   ld a, 24
   ld [enemy_data + ENEMY_Y], a
   ld a, DIR_LEFT
   ld [enemy_data + ENEMY_DIR], a
   ld a, 20
   ld [enemy_data + ENEMY_SPRITEID], a

   MEMCPY sprite1_enemy_l1, $FE00 + (20 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
   MEMCPY sprite2_enemy_l1, $FE00 + (21 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE


   call init_entities

   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on

   call HUD_Init
ret


