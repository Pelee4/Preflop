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
    call get_tilemap_pos_player
    ld d, h
    ld e, l
;get player position
    push de
    call get_tilemap_pos_enemy
    pop de
;cp
    ld a, e
    cp l
    jr z, check_high
    ret
    check_high:
        ld a,d
        cp h
        jr z, die
    ret
;if its the same -> call take_damage
    die:
        jp sc_game_death
ret





; ahora mismo no lo pone en la posicion ni puta idea de por que
enemy_update_sprite::
    ;;aumentamos el sprite de la oam
    ld a, [enemy_data + ENEMY_NUMBER]
    ld h, $FE
    ld l, a

    ld a, [enemy_data + ENEMY_Y]
    ld [hl+], a
    ld a, [enemy_data + ENEMY_X]
    ld [hl+], a
    inc hl
    inc hl
    ld a, [enemy_data + ENEMY_Y]
    ld [hl+], a
    ld a, [enemy_data + ENEMY_X]
    add 8
    ld [hl], a

    ;;Aumentamos en la data e sprite
    ld a, [enemy_data + ENEMY_NUMBER]
    ld h, $C4
    ld l, a

    ld a, [enemy_data + ENEMY_Y]
    ld [hl+], a
    ld a, [enemy_data + ENEMY_X]
    ld [hl+], a

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

    ld a, [enemy_data + ENEMY_NUMBER]
    ld h, $C4
    ld l, a
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

    ld a, [enemy_data + ENEMY_NUMBER]
    add 3
    ld h, $C4
    ld l, a

    ld a, 1
    ld [hl], a
ret

change_dir_and_move_lr:

    ld a, 0
    ld [enemy_data + ENEMY_DIR], a

    ld a, [enemy_data + ENEMY_NUMBER]
    add 3
    ld h, $C4
    ld l, a

    ld a, 0
    ld [hl], a
ret

change_dir_and_move_ud:

    ld a, 3
    ld [enemy_data + ENEMY_DIR], a

    ld a, [enemy_data + ENEMY_NUMBER]
    add 3
    ld h, $C4
    ld l, a

    ld a, 3
    ld [hl], a
ret

change_dir_and_move_du:

    ld a, 2
    ld [enemy_data + ENEMY_DIR], a

    ld a, [enemy_data + ENEMY_NUMBER]
    add 3
    ld h, $C4
    ld l, a

    ld a, 2
    ld [hl], a
ret