;;LVL1

include "includes/constants.inc"
include "includes/macros.inc"
include "engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"




SECTION "Lvl1 scene", ROMX

sc_game_lvl1::
    call sc_game_lvl1_init
    loop_lvl1:
        call wait_vblank_start   ; <<-- sincroniza AL INICIO de frame
        call read_input
        call read_input_buttons
        call check_collision
        call HUD_Update
        call Player_Idle_Animate
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
   ld a, 48
   ld [player_data + PLAYER_X], a
   ld a, 0
   ld [player_data + PLAYER_ISMOVING], a
   ld a, 1
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

 
    ;MAP DRAW
    MEMCPY_2 map1, $9800, 576


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

   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on
   
   call HUD_Init
ret


