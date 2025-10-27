;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl8 scene", ROMX

sc_game_lvl8::
    call sc_game_lvl8_init
    loop_lvl8:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update
        call Player_Idle_Animate 
        jr loop_lvl8
    ret
sc_game_lvl8_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   
   ;MAP DRAW
   MEMCPY_2 map8, $9800, 608

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
   ld a, 32
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
   ld a, 8
   ld [player_data + PLAYER_LEVEL], a


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player_l8, $FE00, 4
   MEMCPY sprite2_player_l8, $FE00 + 4, 4
 
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

    MEMCPY sprite1_enemy1_l8, $FE00 + (20 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy1_l8, $FE00 + (21 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    MEMCPY sprite1_enemy2_l8, $FE00 + (22 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy2_l8, $FE00 + (23 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    MEMCPY sprite1_enemy3_l8, $FE00 + (24 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy3_l8, $FE00 + (25 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

   MEMCPY enemy1_8_stats, ENEMIES_START_DATA, 4
   MEMCPY enemy2_8_stats, ENEMIES_START_DATA + 8, 4
   MEMCPY enemy3_8_stats, ENEMIES_START_DATA + 16, 4

   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on

   call HUD_Init
ret


