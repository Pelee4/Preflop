; SISTEMA DE COLISIONES QUE A SABER COMO SE HACE, SI CON TILEMAPS O CON
; EL METODO DE LA GBDEV.IO O CON LO QUE EXPLIQUE EL PROFE
include "includes/constants.inc"
include "includes/macros.inc"

include "src/engine/player/player_data.inc"
include "src/engine/enemies/enemy1_data.inc"

SECTION "Collisions_logic", ROM0

;;Convierte la posicion del sprite a posicion de tile map y la guarda en hl
get_tilemap_pos_player:

   ld a, [player_data + PLAYER_Y]
   call convert_y_to_ty
   ld l, a
   ld a, [player_data + PLAYER_X]
   call convert_x_to_tx
   call calculate_address_from_tx_and_ty

ret



;#####  CHECK_COLLISIONS  ##############################################################################
; - WE CALL IT RIGHT AFTER THE PLAYER MOVES (BEFORE UDPATING THE SPRITE)
; - IT CHECKS IF THE PLAYER HAS MOVED TO AN INVALID POSITION SO IT RETURN HIM TO THE PREVIOUS ONE
; - AFTER CHECKING WE CALL UPDATE_SPRITE
;#######################################################################################################

check_collision::
   ; Load player's position
   call get_tilemap_pos_player
   ; checks if the player moves to a void block -> dies
   call check_empty_tile
   ; checks if the player is in a stair -> changes lvl
   call check_stairs
   ; checks if the player face a solid block -> returns player_x & player_y to its previous position
   ;call check_solid

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
check_empty_tile::
   ld a, [hl]
   cp $18
   ret nz
   ;;AQUI VA LA MUERTE, de momento he puesto reset del lvl 1S
   call sc_game_lvl1
ret



check_stairs::
   ld a, [hl]
   cp $00
   ret nz
   ;;if its a stair, changes level (updates the player_level data and calls the lvl_manager)
   ld a, [player_data + PLAYER_LEVEL]
   inc a
   ld [player_data + PLAYER_LEVEL], a
   call change_level_manager
ret


check_solid::
   ld a, [hl]
   cp $00
   ret nz
   ;;if its a block, returns player to previous position
   ;ld a, [player_data + PLAYER_PREVIOUS_X]
   ;ld [player_data + PLAYER_X], a
   ;ld a, [player_data + PLAYER_PREVIOUS_Y]
   ;ld [player_data + PLAYER_Y], a
ret




;;To take the player tile
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