SECTION "Entry point", ROM0[$150]

main::
   call init_sound
   ;ld hl, dead_theme
   ;call hUGE_init
   ;ld hl, info_screen_theme
   ;call hUGE_init
   ld hl, menu_theme
   call hUGE_init
   call sc_game_start
   call sc_game_lvl8
   di
   halt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Este main solo tiene que tener llamadas a los init de las escenas, niveles y menús.
;; Todo lo que hay ahora aqui seria para un lvl por ejemplo.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   

;; Input:  D (HIGH byte of the region to copy)
;; rutinaDMA:
;;      ld a, HIGH(copiaOAM) ;; activates the copy of the given region XX00
;;      ldh [$FF46], a 
;;      ld a, 40
;;   .espera:
;;      dec a
;;      jr nz, .espera
;;      ret
;;   .fin
;;
;; SECTION "Copia OAM", WRAM0, ALIGN[8]
;; copiaOAM::
;; DS 6*4 ;;Numero de Sprites * 4
;;
;; SECTION "OAM DMA", HRAM
;; OAMDMA:: 
;; DS rutinaDMA.fin - rutinaDMA