;bit 
include "src/engine/player/player_data.inc"


SECTION "Interaction", ROM0

; HAS TO BE CALLED AFTER CHECK_COLLISIONS
Interact::
    ;pos jugador
    call get_tilemap_pos_player
    ;direccion jugador
    ld a, [player_data + PLAYER_DIR]
    ;boole
    cp 0
        jr z, call_right_tile
    cp 1
        jr z, call_left_tile
    cp 2
        jr z, call_up_tile
    cp 3
        jr z, call_down_tile
    

    call_right_tile:
        ld de, $0002
        call right_tile
        ret
    call_left_tile:
        ld de, $0002
        call left_tile
        ret
    call_up_tile:
        ld de, $0040 
        call up_tile
        ret
    call_down_tile:
        ld de, $0040
        call down_tile
        ret
ret


right_tile:

    add hl, de
    ld a, [hl]
    cp $18
    jr z, check_empty_right
    cp $14
    ret nz
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 0
        ret nz
        call put_empty
    ret

    
    check_empty_right:
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 1
        ret nz
        call put_floor
ret

left_tile:

    dec hl
    dec hl
    ld a, [hl]
    cp $18
    jr z, check_empty_left
    cp $14
    ret nz
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 0
        ret nz
        call put_empty
    ret

    
    check_empty_left:
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 1
        ret nz
        call put_floor
ret

up_tile:
    ld a, l
    sbc e
    ld l, a
    ld a, [hl]
    cp $18
    jr z, check_empty_up
    cp $14
    ret nz
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 0
        ret nz
        call put_empty
    ret

    
    check_empty_up:
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 1
        ret nz
        call put_floor

ret

down_tile:
    add hl, de
    ld a, [hl]
    cp $18
    jr z, check_empty_down
    cp $14
    ret nz
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 0
        ret nz
        call put_empty
    ret

    
    check_empty_down:
        ld a, [player_data + PLAYER_INT_BOOL]
        cp 1
        ret nz
        call put_floor

ret


put_floor:
    ld b, h
    ld c, l
    call wait_vblank_start   
    ld l, c
    ld h, b
    
    ld de, $20
    ld [hl], $14
    inc hl
    ld [hl], $16
    add hl, de
    ld [hl], $17
    dec hl
    ld [hl], $15
    ld a, 0
    ld [player_data + PLAYER_INT_BOOL], a
ret

put_empty:
    ld b, h
    ld c, l
    call wait_vblank_start   
    ld l, c
    ld h, b
    
    ld de, $20
    ld [hl], $18
    inc hl
    ld [hl], $18
    add hl, de
    ld [hl], $18
    dec hl
    ld [hl], $18
    ld a, 1
    ld [player_data + PLAYER_INT_BOOL], a
ret