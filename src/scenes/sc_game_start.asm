;; EXAMPLE FILE. IT MAKES A LEVEL BASICALLY
;; AQUI DEBERIAMOS PONER NUESTRO MAIN ACTUAL PERO NO TENGO COJONES A CAMBIARLO
include "includes/constants.inc"

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

    ;;Dibujar logo y Press A to play

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