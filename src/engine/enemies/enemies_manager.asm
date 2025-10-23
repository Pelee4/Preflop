include "src/engine/enemies/enemy1_data.inc"

SECTION "Enemy manager", ROM0

; OBTIENE CADA SPRITE ENEMIGO Y LLAMA A SU FUNCION enemy_moves_once

init_entities::
    call enemy_update_sprite

ret

move_entities::
    ld hl, ENEMIES_START_DATA
    .loop_move:
        ld a, [hl+]
        cp 0
        ret z
    
        ld [enemy_data + ENEMY_Y], a
        ld a, [hl+]
        ld [enemy_data + ENEMY_X], a
        ld a, [hl+]
        ld [enemy_data + ENEMY_NUMBER], a
        ld a, [hl+]
        ld [enemy_data + ENEMY_DIR], a
        push hl
    
    call enemy_moves_once
    call enemy_update_sprite

    pop hl
    inc hl
    inc hl
    inc hl
    inc hl
    jr .loop_move
ret
