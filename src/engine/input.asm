include "includes/constants.inc"
include "includes/macros.inc"
include "src/engine/player/player_data.inc"


SECTION "Inputs", ROM0

read_input::

   ld a, [player_data + PLAYER_ISMOVING]
   cp 0
   jp nz, moving

   ld a, SELECT_PAD
   ld [rJOYP], a
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]
   ld a, [rJOYP]

    ;for every pad button, calls a player.asm move function
   bit RIGHT_PRESSED, a
   jp z, start_move_right

   bit LEFT_PRESSED, a
   jp z, start_move_left

   bit UP_PRESSED, a
   jp z, start_move_up

   bit DOWN_PRESSED, a
   jp z, start_move_down

ret

