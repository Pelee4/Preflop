include "src/engine/enemies/enemy1_data.inc"
include "includes/constants.inc"


SECTION "Enemy vars", WRAM0
enemy_data: DS ENEMY_SIZE
export enemy_data





SECTION "Enemy functions", ROM0


;;Input == bc:: Pos 1 del sprite (Y) Sprite= (Y) X TILE ATT;;;;;;;;;;;;

enemy_moves_once::
; checkea solid y checkea empty
    call get_tilemap_pos_enemy ;;Tengo en hl la posicion del enemigo

    ld a, [enemy_data + ENEMY_DIR]
    cp 0
    jr z, check_right_enemy
    cp 1
    jr z, check_left_enemy
    cp 2
    jr z, check_up_enemy
    cp 3
    jr z, check_down_enemy
    

    check_right_enemy:
        inc hl
        inc hl
        ld a, [hl]
        
        cp $18 ;;Checkea si hay vacío
        jr z, change_dir_rl
        
        cp $10 ;;Checkea si hay roca
        jr z, change_dir_rl
        call move_right_enemy
        ret
        change_dir_rl:
            call change_dir_and_move_rl
        ret

    check_left_enemy:
        dec hl
        dec hl
        ld a, [hl]
        
        cp $18 ;;Checkea si hay vacío
        jr z, change_dir_lr
        
        cp $10 ;;Checkea si hay roca
        jr z, change_dir_lr
        call move_left_enemy
        ret
        change_dir_lr:
            call change_dir_and_move_lr
        ret

    check_up_enemy:
        ld de, $0040
        ld a, l
        sub e
        jr nc, .next
            dec h
        .next:
        ld l, a
        ld a, [hl]
        
        cp $18 ;;Checkea si hay vacío
        jr z, change_dir_ud
        
        cp $10 ;;Checkea si hay roca
        jr z, change_dir_ud
        
        call move_up_enemy
        ret
        change_dir_ud:
            call change_dir_and_move_ud
        ret

    check_down_enemy:
        ld de, $0040
        add hl, de
        ld a, [hl]
        
        cp $18 ;;Checkea si hay vacío
        jr z, change_dir_du
        
        cp $10 ;;Checkea si hay roca
        jr z, change_dir_du
        call move_down_enemy
        ret
        change_dir_du:
            call change_dir_and_move_du
        ret
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVER ENEMIGO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

move_right_enemy:

    ld a, [enemy_data + ENEMY_X]
    add 16
    ld [enemy_data + ENEMY_X], a
ret

move_left_enemy:

    ld a, [enemy_data + ENEMY_X]
    sub 16
    ld [enemy_data + ENEMY_X], a
ret

move_up_enemy:

    ld a, [enemy_data + ENEMY_Y]
    sub 16
    ld [enemy_data + ENEMY_Y], a
ret

move_down_enemy:

    ld a, [enemy_data + ENEMY_Y]
    add 16
    ld [enemy_data + ENEMY_Y], a
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAMBIAR DIRECCION ENEMIGO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

change_dir_and_move_rl:

    ld a, 1
    ld [enemy_data + ENEMY_DIR], a
    call move_left_enemy

ret

change_dir_and_move_lr:

    ld a, 0
    ld [enemy_data + ENEMY_DIR], a
    call move_right_enemy

ret

change_dir_and_move_ud:

    ld a, 3
    ld [enemy_data + ENEMY_DIR], a
    call move_down_enemy

ret

change_dir_and_move_du:

    ld a, 2
    ld [enemy_data + ENEMY_DIR], a
    call move_up_enemy

ret