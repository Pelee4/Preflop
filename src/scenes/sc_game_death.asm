;; ------------------------------------------------------------
;; ESCENA DE MUERTE (PantallaMuerte) - versión más robusta
;; ------------------------------------------------------------
include "includes/constants.inc"
include "includes/macros.inc"

SECTION "Death scene", ROM0

sc_game_death::
    call sc_game_death_init

    call wait_vblank_start
    call wait_vblank_start

.loop
    call read_a_death
    cp $FF
    jr nz, .loop

    
    call change_level_manager
    
    

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


;; ------------------------------------------------------------
;; ENTRADA BOTÓN A 
;; ------------------------------------------------------------
read_a_death::
    ld a, SELECT_BUTTONS
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]

    bit A_PRESSED, a
    ret nz

    ld a, $FF
ret
