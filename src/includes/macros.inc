;; File for macros

MACRO MEMSET
   ld hl, \1
   ld a, \2
   ld b, \3
   call memset_256
ENDM

MACRO MEMCPY
   ld hl, \1
   ld de, \2
   ld b, \3
   call memcpy_256
ENDM


MACRO MEMCPY_2
   ld hl, \1
   ld de, \2
   ld bc, \3
   call memcpy
ENDM


;------------------------------------------------------------------------------
; Macro para reproducir sonidos fácilmente (PLAY_SFX {id_sound})
; BREAKS A !!!
;------------------------------------------------------------------------------
MACRO PLAY_SFX
    ld a, \1
    call play_sound
ENDM