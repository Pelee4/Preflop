

SECTION "Enemy manager", ROM0

; OBTIENE CADA SPRITE ENEMIGO Y LLAMA A SU FUNCION enemy_moves_once

init_entities::
    call enemy_update_sprite

ret

move_entities::
    call enemy_moves_once

ret
