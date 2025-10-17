;; EXAMPLE FILE. IT MAKES A LEVEL BASICALLY
;; AQUI DEBERIAMOS PONER NUESTRO MAIN ACTUAL PERO NO TENGO COJONES A CAMBIARLO
include "includes/constants.inc"
include "includes/macros.inc"

SECTION "Menu scene", ROM0


sc_game_start::
    call sc_game_start_init
    .loop
        call read_a
        cp $FF
    jr nz, .loop
ret

sc_game_start_init::

    call lcd_off
    ;MEMSET $9800, 0, 576
    ;;Copiamos los 
    
    ;;PALETTES
   ld hl, rBGP
   ld [hl], %00100111

   ld hl, rOBJP
   ld [hl], %11100100
    
    MEMSET $9904, 0, 13
    MEMSET $9924, 0, 13
    MEMCPY_2 PantallaInicio, $8000, 2000

    ;;copiamos a la pantalla
    MEMCPY_2 PantallaInicioMap, $9800, 576

    call lcd_on

ret


read_a::
    ld a, SELECT_BUTTONS
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]

    bit A_PRESSED, a
    ret nz

    ld a, $FF
ret