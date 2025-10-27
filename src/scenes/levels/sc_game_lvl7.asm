;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl7 scene", ROMX

sc_game_lvl7::
    call sc_game_lvl7_init
    loop_lvl7:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update
        call Player_Idle_Animate 
        jr loop_lvl7
    ret
sc_game_lvl7_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   
   ;MAP DRAW
   MEMCPY_2 map7, $9800, 576

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
   ld a, 64
   ld [player_data + PLAYER_Y], a
   ld a, 152
   ld [player_data + PLAYER_X], a
   ld a, 0
   ld [player_data + PLAYER_ISMOVING], a
   ld a, 3
   ld [player_data + PLAYER_DIR], a
   ld a, 0
   ld [player_data + PLAYER_TIMER], a
   ld a, 0
   ld [player_data + PLAYER_INT_BOOL], a
   ld a, 7
   ld [player_data + PLAYER_LEVEL], a


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player_l7, $FE00, 4
   MEMCPY sprite2_player_l7, $FE00 + 4, 4
 
   ; --- HUD sprite ---
   ; --- HUD sprite TOP (FE10) - PARTE IZQUIERDA ---
    ld a,0
    ld [$FE10],a ; Y
    ld a,160
    ld [$FE11],a ; X
    ld a,$7C     
    ld [$FE12],a
    ld a,%00000000
    ld [$FE13],a

    ; --- HUD sprite BOTTOM (FE14) - PARTE DERECHA ---
    ld a,0
    ld [$FE14],a ; Y 
    ld a,160
    ld [$FE15],a ; X 
    ld a,$7E     
    ld [$FE16],a
    ld a,%00000000
    ld [$FE17],a



    MEMSET ENEMIES_START_DATA, 0, 80

    MEMCPY sprite1_enemy1_l7, $FE00 + (20 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy1_l7, $FE00 + (21 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    MEMCPY sprite1_enemy2_l7, $FE00 + (22 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy2_l7, $FE00 + (23 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    MEMCPY sprite1_enemy3_l7, $FE00 + (24 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy3_l7, $FE00 + (25 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    ;MEMCPY sprite1_enemy4_l7, $FE00 + (26 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    ;MEMCPY sprite2_enemy4_l7, $FE00 + (27 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    ;MEMCPY sprite1_enemy5_l7, $FE00 + (28 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    ;MEMCPY sprite2_enemy5_l7, $FE00 + (29 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

   MEMCPY enemy1_7_stats, ENEMIES_START_DATA, 4
   MEMCPY enemy2_7_stats, ENEMIES_START_DATA + 8, 4
   MEMCPY enemy3_7_stats, ENEMIES_START_DATA + 16, 4
   ;MEMCPY enemy4_7_stats, ENEMIES_START_DATA + 24, 4
   ;MEMCPY enemy5_7_stats, ENEMIES_START_DATA + 32, 4
   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on

   call HUD_Init
ret


