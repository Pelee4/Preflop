; SISTEMA DE COLISIONES QUE A SABER COMO SE HACE, SI CON TILEMAPS O CON
; EL METODO DE LA GBDEV.IO O CON LO QUE EXPLIQUE EL PROFE
include "includes/constants.inc"
include "includes/macros.inc"

include "src/engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"

SECTION "Collisions_logic", ROM0


;#####  CHECK_COLLISIONS  ##############################################################################
; - WE CALL IT RIGHT AFTER THE PLAYER MOVES (BEFORE UDPATING THE SPRITE)
; - IT CHECKS IF THE PLAYER HAS MOVED TO AN INVALID POSITION SO IT RETURN HIM TO THE PREVIOUS ONE
; - AFTER CHECKING WE CALL UPDATE_SPRITE
;#######################################################################################################

check_collision::
   ;; Carga posiciones del jugador y enemigo
   ld a, [player_data + PLAYER_X]
   ld b, a
   ld a, [player_data + PLAYER_Y]
   ld c, a

   ld a, [enemy_data + ENEMY_X]
   ld d, a
   ld a, [enemy_data + ENEMY_Y]
   ld e, a

   ld a, b
   sub d
   bit 7, a          
   jr z, check_y
   cpl
   inc a
check_y:
   cp 8
   jr nc, no_collision

   ld a, c
   sub e
   bit 7, a
   jr z, collision_check
   cpl
   inc a
collision_check:
   cp 8
   jr nc, no_collision

   ;; Si hay colisión 
   call on_player_death
   jr no_collision

no_collision:
   ret







;#####  CHECK_HIT  ##############################################################################
; - WE CALL IT RIGHT AFTER THE ENTITIES MOVE (WITH THE ECS)
; - IT CHECKS IF THE PLAYER HAS BEEN HIT BY AN ENEMY SO IT CALLS TAKE_DAMAGE FUNCTION FROM PLAYER.ASM
;#######################################################################################################
check_hit::

ret

;#####  CHECK_EMPTY_TILE  ##############################################################################
; - WE CALL IT RIGHT AFTER THE ENTITIES MOVE (WITH THE ECS)
; - IT CHECKS IF THE PLAYER HAS BEEN HIT BY AN ENEMY SO IT CALLS TAKE_DAMAGE FUNCTION FROM PLAYER.ASM
;#######################################################################################################

;;comprobar si te estas tocando (jeje) con el vacío
check_coll_empty_tile::
   call get_tilemap_pos_player
   ld a, [hl]
   cp $18
   ret nz
   ;;AQUI VA LA MUERTE, de momento he puesto reset del lvl 1S
   call sc_game_lvl1
ret

;;Convierte la posicion del sprite a posicion de tile map
get_tilemap_pos_player:

   ld a, [player_data + PLAYER_Y]
   call convert_y_to_ty
   ld l, a
   ld a, [player_data + PLAYER_X]
   call convert_x_to_tx
   call calculate_address_from_tx_and_ty

ret

;;Movidas
convert_y_to_ty:

   sub 16
   srl a
   srl a
   srl a

ret

convert_x_to_tx:

   sub 8
   srl a
   srl a
   srl a

ret

calculate_address_from_tx_and_ty:
   
   ld de, $9800
   ld h, 0
   add hl, hl
   add hl, hl
   add hl, hl
   add hl, hl
   add hl, hl
   
   adc a, l
   ld l, a

   add hl, de

ret