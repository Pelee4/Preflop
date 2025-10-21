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
        call HUD_Update          ; <<-- AHORA SÍ, SOLO DENTRO VBLANK
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


   ; WRITES SPRITES ON SCREEN
   ; - PLAYER
   MEMCPY sprite1_player_l1, $FE00, 4
   MEMCPY sprite2_player_l1, $FE00 + 4, 4
   ; - ENEMIES
   MEMCPY sprite1_enemy_l1, $FE00 + 8, 4
   MEMCPY sprite2_enemy_l1, $FE00 + 12, 4

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
 
    ;MAP DRAW
    MEMCPY_2 map1, $9800, 576


    ; ENEMIES INITIAL POSITION
    ld a, 80
    ld [enemy_data + ENEMY_X], a
    ld a, 40
    ld [enemy_data + ENEMY_Y], a
   

    

   ;===========================
   ; SCREEN ON
   ;===========================

   call lcd_on
   
   call HUD_Init
ret


