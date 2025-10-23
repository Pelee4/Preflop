;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl5 scene", ROM0

sc_game_lvl5::
    call sc_game_lvl5_init
    loop_lvl5:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update 
        jr loop_lvl5
    ret
sc_game_lvl5_init::
   ;===========================
   ;; SCREEN OFF
   ;===========================

   call lcd_off
   call Tiles_Init

   
   ;MAP DRAW
   MEMCPY_2 map5, $9800, 576

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
   ld a, 5
   ld [player_data + PLAYER_LEVEL], a


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player_l5, $FE00, 4
   MEMCPY sprite2_player_l5, $FE00 + 4, 4
 
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

    MEMCPY sprite1_enemy1_l5, $FE00 + (20 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy1_l5, $FE00 + (21 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

    MEMCPY sprite1_enemy2_l5, $FE00 + (22 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE
    MEMCPY sprite2_enemy2_l5, $FE00 + (23 * SPRITE_BYTE_SIZE), SPRITE_BYTE_SIZE

   MEMCPY enemy1_5_stats, ENEMIES_START_DATA, 4
   MEMCPY enemy2_5_stats, ENEMIES_START_DATA + 8, 4
   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on

   call HUD_Init
ret


