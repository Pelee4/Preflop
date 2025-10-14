INCLUDE "constants.inc"

SECTION "Utils", ROM0 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LCD OFF (turns off the screen)
;;
;; DESTROYS AF, HL
lcd_off::
    ;;BEWARE!!!!!!
    di
    call wait_vblank_start
    ld hl, rLCDC
    res 7, [hl]
    ei
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LCD ON (turns on the screen)
;;
;; DESTROYS AF, HL
lcd_on::
    ;;BEWARE!!!!!!
    ld hl, rLCDC
    set rLCDC_LCD_ENABLE, [hl]
ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; VBLANK
;; DESTROYS AF, HL
wait_vblank_start::
    ld hl, rLY
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MEMSET_256
;; INPUT;
;;  HL: Destination Adress
;;   B: Bytes to Set
;;   A: Value to Write
;;
;; DESTROYS: AF, B, HL
;;
memset_256::
    
    ld [hl+], a
    dec b
    jr nz, memset_256
ret