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

    ;;Copiamos los tiles
    MEMSET $9904, 0, 13
    MEMSET $9924, 0, 13
    MEMCPY PreflopLogoTiles, $8000, 144

    ;;copiamos a la pantalla
    MEMCPY PreflopLogoMap, $9800, 360

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