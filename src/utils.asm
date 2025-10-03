INCLUDE "constants.inc"

SECTION "Utils", ROM0 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LCD OFF (turns off the screen)
;;
;; DESTROYS AF, HL
lcd_off::
    ;;BEWARE!!!!!!
    call wait_vblank_start
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VBLANK
;; DESTROYS AF, HL
wait_vblank_start::
    ld hl, rlY
    ld a, VBLANK_START_LINE
    .loop:
        cp [hl]
    jr nz, .loop
    ret



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memcpy_256
;; INPUT;
;;  HL: Source address
;;  DE: Destiny address
;;   B: Bytes to copy
;;
;; DESTROYS: AF, B, HL, DE
;;
memcpy_256::
    ld a, [hl+]
    ld [de], a
    inc de
    dec b
    jr nz, memcpy_256
    ret

