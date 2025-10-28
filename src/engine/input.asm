include "includes/constants.inc"
include "includes/macros.inc"
include "src/engine/player/player_data.inc"


SECTION "Flanco things", HRAM

estadoPad:        ds 1     ; Último estado del D-Pad
flancoPad:        ds 1     ; Flancos ascendentes del D-Pad

estadoBotones:    ds 1     ; Último estado de los botones (A, B, Start, Select)
flancoBotones:    ds 1     ; Flancos ascendentes de los botones


SECTION "Inputs", ROM0

read_input::
    ld a, [player_data + PLAYER_ISMOVING]
    cp 0
    jp nz, moving          ; si ya se mueve, no hacemos nada

    ld a, SELECT_PAD
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]          ; leer varias veces para estabilidad
    ld a, [rJOYP]
    ld a, [rJOYP]

    cpl                    ; invertir bits (0=pulsado → 1=pulsado)
    and $0F                ; mantener solo los 4 bits bajos (direcciones)
    ld b, a                ; guardar lectura actual

    ; --- calcular flanco ascendente ---
    ldh a, [estadoPad]     ; estado anterior
    xor b                  ; 1 donde hay cambio
    and b                  ; 1 solo donde ha pasado de 0→1
    ldh [flancoPad], a     ; guardar flanco
    ld a, b
    ldh [estadoPad], a     ; guardar nuevo estado
    ; -------------------------------

    ; ahora solo usamos flancoPad para iniciar movimientos
    ldh a, [flancoPad]

    bit RIGHT_PRESSED, a
    jp nz, start_move_right

    bit LEFT_PRESSED, a
    jp nz, start_move_left

    bit UP_PRESSED, a
    jp nz, start_move_up

    bit DOWN_PRESSED, a
    jp nz, start_move_down

ret

read_input_buttons::
    ld a, [player_data + PLAYER_ISMOVING]
    cp 0
    ret nz                 ; no leer si se está moviendo

    ld a, SELECT_BUTTONS
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]

    cpl
    and $0F
    ld b, a                ; estado actual botones

    ; --- calcular flanco ascendente ---
    ldh a, [estadoBotones]
    xor b
    and b
    ldh [flancoBotones], a
    ld a, b
    ldh [estadoBotones], a
    ; -------------------------------

    ldh a, [flancoBotones]

    bit A_PRESSED, a
    ret z                 ; si no está pulsado, salir
    call Interact

ret

read_a_menus::
    ; Leer botones igual que en el juego
    ld a, SELECT_BUTTONS
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]

    cpl
    and $0F
    ld b, a                ; estado actual botones

    ; --- calcular flanco ascendente ---
    ldh a, [estadoBotones]
    xor b
    and b
    ldh [flancoBotones], a
    ld a, b
    ldh [estadoBotones], a
    ; -------------------------------

    ldh a, [flancoBotones]

    bit A_PRESSED, a       ; ¿A acaba de ser pulsado?
    ret z                  ; si no, salir

    ld a, $FF              ; acción cuando se pulsa A
ret
