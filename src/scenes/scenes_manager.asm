;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONTROLARÁ CAMBIOS DE ESCENA:
; - QUE UN NIVEL TE LLEVE AL SIGUIENTE O ANTERIOR (SI QUEREMOS VOLVER ATRÁS)
; - QUE ALMACENE UNA ESCENA DE UNA PARRTIDA GUARDADA Y LA CARGUE AL REANUDAR PARTIDA
; - ...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

include "includes/constants.inc"
include "includes/macros.inc"
include "src/engine/player/player_data.inc"





SECTION "Level_manager_stuff", ROMX

get_player_level:
    ld a, [player_data + PLAYER_LEVEL]
ret


change_level_manager::
    call get_player_level
    cp 2
    jr z, open_lvl2
    cp 3
    jr z, open_lvl3  
    cp 4 
    jr z, open_lvl4
    cp 5
    jr z, open_lvl5
    cp 6
    jr z, open_lvl6
    cp 7
    jr z, open_lvl7
    cp 8
    jr z, open_lvl8
ret




open_lvl2:
    call sc_game_lvl2

open_lvl3:
    call sc_game_lvl3

open_lvl4:
    call sc_game_lvl4

open_lvl5:
    call sc_game_lvl5

open_lvl6:
    call sc_game_lvl6

open_lvl7:
    call sc_game_lvl7

open_lvl8:
    call sc_game_lvl8