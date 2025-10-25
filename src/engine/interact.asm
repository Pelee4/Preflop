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
    jr nc, .next
        dec h
    .next:
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
    call animate_pickup
ret

; =======================================================
; animate_pickup - animación al coger un bloque (más lenta)
; =======================================================

; =======================================================
; animate_pickup - animación al coger un bloque (más lenta)
; incluye versión "flipped" si mira hacia arriba
; =======================================================

animate_pickup:
    call wait_vblank_start

    
    ld a, [player_data + PLAYER_DIR]
    cp 2
    jr z, .anim_up  ; si mira hacia arriba que haga su animacion propia

    ; animación normal (no mira arriba)

    ; Primer frame (Mr_floor_animated2)
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $48
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $4A
    call update_sprite
    call Delay_PickupAnim   

    ; Segundo frame (Mr_floor_animated3)
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $4C
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $4E
    call update_sprite
    call Delay_PickupAnim   

    ; Restaurar sprite normal según dirección
    ld a, [player_data + PLAYER_DIR]
    cp 0
    jr z, restore_right
    cp 1
    jr z, restore_left
    cp 3
    jr z, restore_down
    ret

; animación especial al mirar ARRIBA
.anim_up:
    ; Primer frame flipped (Mr_floor_animated2_flipped)
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $5C
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $5E
    call update_sprite
    call Delay_PickupAnim   

    ; Segundo frame flipped (Mr_floor_animated3_flipped)
    ld hl, TILE_LEFT_SPRITE
    ld [hl], $60
    ld hl, TILE_RIGHT_SPRITE
    ld [hl], $62
    call update_sprite
    call Delay_PickupAnim   

    ; Restaurar sprite hacia arriba
    call Flip_sprite_up
    ret



Delay_PickupAnim:
    ld b, 28          ;; mayor = más lenta la animación
.wait_loop:
    call wait_vblank_start
    dec b
    jr nz, .wait_loop
    ret

restore_right:
    call Flip_sprite_right
    ret
restore_left:
    call Flip_sprite_left
    ret
restore_down:
    call Flip_sprite_down
    ret