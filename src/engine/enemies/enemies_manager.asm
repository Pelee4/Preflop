include "src/engine/enemies/enemy1_data.inc"

SECTION "Enemy manager", ROM0

; OBTIENE CADA SPRITE ENEMIGO Y LLAMA A SU FUNCION enemy_moves_once

init_entities::
    call enemy_update_sprite

ret

move_entities::
    ld a, [ENEMIES_START_OAM]
    cp 0
    ret z
    call enemy_moves_once
    call enemy_update_sprite
ret
