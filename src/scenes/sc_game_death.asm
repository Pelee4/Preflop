;; ------------------------------------------------------------
;; ESCENA DE MUERTE (PantallaMuerte) - versión más robusta
;; ------------------------------------------------------------
include "includes/constants.inc"
include "includes/macros.inc"
include "src/engine/player/player_data.inc"

SECTION "Death scene", ROM0

sc_game_death::
call init_sound
    call sc_game_death_init

    call wait_vblank_start

.loop
    call wait_vblank_start
    ;ld a, BANK(dead_theme)
    ;ld [rROMB0], a
    di
    ;SwitchBank dead_theme
    ; ld a, BANK(main)
    ; ld [rROMB0], a
    ei
    call read_a_menus
    cp $FF
    jr nz, .loop

    
    ;call StopMusic
    xor a 
    ld [$FF41], a            ; rSTAT = 0 (desactiva HBlank)
    ld [$FFFF], a            ; rIE = 0 (desactiva TODO)
    ;call StopMusic
    ;call init_sound

    ;;HE CAMBIADO A QUE SEA ASI PORQUE SI NO SE ROMPE EL JUEGO
    call reload_current_level
    
    reload_current_level:
    ld a, [player_data + PLAYER_LEVEL]
    
    cp 1
    jp z, sc_game_lvl1
    cp 2
    jp z, sc_game_lvl2
    cp 3
    jp z, sc_game_lvl3
    cp 5
    jp z, sc_game_lvl5
    cp 6
    jp z, sc_game_lvl6
    cp 7
    jp z, sc_game_lvl7
    cp 8
    jp z, sc_game_lvl8
    
    ret  ; Por si acaso
    

sc_game_death_init::
    
    di                      
    
    
    xor a
    ld [$FF41], a           
    ld [$FFFF], a           

    
    call lcd_off

    ;; --------------------------------------------------------
    ;; LIMPIAR OAM y restablecer SCX (esto ultimo es pq si no se buguea a veces)
    ;; --------------------------------------------------------
    MEMSET $FE00, 0, 160    ; limpiar OAM 
    xor a
    ld [$FF43], a           ; SCX = 0

    ;; --------------------------------------------------------
    ;; PALETAS 
    ;; --------------------------------------------------------
    ld hl, rBGP
    ld [hl], %11100100

    ld hl, rOBJP
    ld [hl], %11100100

    ;; --------------------------------------------------------
    ;; COPIAR TILESET Y TILEMAP DE LA PANTALLA DE MUERTE
    ;; --------------------------------------------------------
    
    MEMCPY_2 PantallaMuerte, $8000, 2000
    MEMCPY_2 PantallaMuerteMap, $9800, 576

    
    call lcd_on

    ;; esto para asegurar que funcione
    call wait_vblank_start
    call wait_vblank_start

    
    ei

ret