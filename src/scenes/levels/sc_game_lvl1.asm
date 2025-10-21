;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl1 scene", ROM0

sc_game_lvl1::
    call sc_game_lvl1_init
    loop_lvl1:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update
        jr loop_lvl1
    ret

sc_game_lvl1_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   

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
   ld a, 80
   ld [player_data + PLAYER_Y], a
   ;ld a, 80
   ;ld [player_data + PLAYER_PREVIOUS_Y], a
   ld a, 48
   ld [player_data + PLAYER_X], a
   ;ld a, 48
   ;ld [player_data + PLAYER_PREVIOUS_X], a
   ld a, 0
   ld [player_data + PLAYER_ISMOVING], a
   ld a, 3
   ld [player_data + PLAYER_DIR], a
   ld a, 0
   ld [player_data + PLAYER_TIMER], a
   ld a, 0
   ld [player_data + PLAYER_INT_BOOL], a
   ld a, 1
   ld [player_data + PLAYER_LEVEL], a


   ; - PLAYER
   MEMCPY sprite1_player_l1, $FE00, SPRITE_BYTE_SIZE
   MEMCPY sprite2_player_l1, $FE00 + SPRITE_BYTE_SIZE, SPRITE_BYTE_SIZE



    ; ENEMIES DATA
    ld a, 80
    ld [enemy_data + ENEMY_X], a
    ld a, 40
    ld [enemy_data + ENEMY_Y], a
    ld a, DIR_LEFT
    ld [enemy_data + ENEMY_DIR], a
    ld a, 20
    ld [enemy_data + ENEMY_SPRITEID], a
   
    MEMCPY sprite1_enemy_l1, $FE00 + (20 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy_l1, $FE00 + (21 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE



 
    ;MAP DRAW
    MEMCPY_2 map1, $9800, 576


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


   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on
   
   call HUD_Init
ret


