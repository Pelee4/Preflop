include "src/engine/enemies/enemy1_data.inc"
include "includes/constants.inc"


SECTION "Enemy vars", WRAM0
enemy_data: DS ENEMY_SIZE
export enemy_data





SECTION "Enemy functions", ROM0

enemy_moves_once::
; actualiza posicion

; checkea solid y checkea empty

; si si vuelve a posicion + cambia direccion + cambia direccion sprite

; si no actualiza sprite a posicion nueva
ret






;CHECKS IF ITS COLLIDING WITH THE PLAYER TO KILL HIM
checks_hitting_player::
;get position

;get player position

;cp

;if its the same -> call take_damage

ret





; ahora mismo no lo pone en la posicion ni puta idea de por que
enemy_update_sprite::
    ld a, [enemy_data + ENEMY_Y]
    ld [$FE00 + 20 * SPRITE_BYTE_SIZE], a
    ld [$FE00 + 21 * SPRITE_BYTE_SIZE], a

    ld a, [enemy_data + ENEMY_X]
    ld [$FE00 + 1 + (20 * SPRITE_BYTE_SIZE)], a
    add 8
    ld [$FE00 + 1 + (21 * SPRITE_BYTE_SIZE)], a
ret
