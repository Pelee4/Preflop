;##############################################################################
; LÓGICA DEL PLAYER:
; - MOVIMIENTO
; - CAMBIAR SPRITE DE POSICION
; - ANIMACIONES
; - ON_DEATH
; - ...
;##############################################################################

include "src/engine/player/player_data.inc"

SECTION "Player Vars", WRAM0

player_data: DS PLAYER_SIZE
EXPORT player_data






