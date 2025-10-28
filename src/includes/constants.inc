;; Main control registers
DEF rJOYP		equ $FF00
DEF rLCDC 		equ $FF40
DEF rLY			equ $FF44 ; for VBlank
DEF rDMA		equ $FF46
DEF rBGP		equ $FF47
DEF rOBJP		equ $FF48

;; Memory map
DEF VRAM_TILE_START	equ $8000 ; starts on the tile region
DEF VRAM_SCREEN	equ $9800 ; region for the screen
DEF VRAM_END	equ $9FFF ; 8KB

DEF WRAM_START 	equ $C000
DEF WRAM_END 	equ $CFFF ; 4KB

DEF OAM_START	equ $FE00
DEF OAM_END		equ $FE9F ; 160 bytes

;; rLCDC control bits
DEF rLCDC_OBJ_ENABLE 		equ 1 ; set to enable sprites
DEF rLCDC_OBJ_16X8 			equ 2 ; set to enable 16x8 sprites
DEF rLCDC_LCD_ENABLE	 	equ 7 ; set to turn on screen, res to turn off

;; rJOYP control bits
DEF SELECT_BUTTONS 		equ $10  ;; it selects the button panel (select, start, B, A)
DEF SELECT_PAD 			equ $20      ;; it selects pad panel (up, down, left, right)
DEF RIGHT_PRESSED		equ 0
DEF LEFT_PRESSED		equ 1
DEF UP_PRESSED			equ 2
DEF DOWN_PRESSED		equ 3
DEF A_PRESSED			equ 0
DEF B_PRESSED			equ 1
DEF SELECT_PRESSED		equ 2
DEF START_PRESSED		equ 2


;; PALLETES
DEF DEFAULT_PALLETE	equ %11100100
DEF FADE_1_PALLETE	equ %11100100
DEF FADE_2_PALLETE	equ %11100101
DEF FADE_3_PALLETE	equ %11101001
DEF FADE_4_PALLETE	equ %11101010
DEF FADE_5_PALLETE	equ %11111010
DEF FADE_6_PALLETE	equ %11111110
DEF FADE_7_PALLETE	equ %11111111

;; Tiles
DEF TILE_SIZE equ $10

;; Vblank
DEF VBLANK_START_LINE equ $90


;; Directions
DEF DIR_RIGHT  EQU 0
DEF DIR_LEFT   EQU 1
DEF DIR_UP     EQU 2
DEF DIR_DOWN   EQU 3


;; Sprites
DEF SPRITE_BYTE_SIZE EQU 4




; ===============================
; SOUND DEFINITIONS
; ===============================

; Channel 1
DEF SFX_CH1_SWEEP       EQU $FF10
DEF SFX_CH1_DUTY_LEN    EQU $FF11
DEF SFX_CH1_VOL_ENV     EQU $FF12
DEF SFX_CH1_FREQ_LO     EQU $FF13
DEF SFX_CH1_FREQ_HI     EQU $FF14

; Channel 2
DEF SFX_CH2_DUTY_LEN    EQU $FF16
DEF SFX_CH2_VOL_ENV     EQU $FF17
DEF SFX_CH2_FREQ_LO     EQU $FF18
DEF SFX_CH2_FREQ_HI     EQU $FF19

; Channel 3
DEF SFX_CH3_ENABLE      EQU $FF1A
DEF SFX_CH3_LENGTH      EQU $FF1B
DEF SFX_CH3_OUTPUT      EQU $FF1C
DEF SFX_CH3_FREQ_LO     EQU $FF1D
DEF SFX_CH3_FREQ_HI     EQU $FF1E

; Channel 4
DEF SFX_CH4_LENGTH      EQU $FF20
DEF SFX_CH4_VOL_ENV     EQU $FF21
DEF SFX_CH4_NOISE       EQU $FF22
DEF SFX_CH4_TRIGGER     EQU $FF23

; Master
DEF SFX_MASTER_VOL      EQU $FF24
DEF SFX_CHANNEL_MIX     EQU $FF25
DEF SFX_MASTER_ENABLE   EQU $FF26


; sounds id (for macro PLAY_SFX)
DEF SFX_CLICK_MENU      EQU 0
DEF SFX_MOVE            EQU 1
DEF SFX_PICK_BLOCK      EQU 2
DEF SFX_PUT_BLOCK       EQU 3
DEF SFX_FALL_DIE        EQU 4
DEF SFX_COMPLETE_LEVEL  EQU 5


;songs id
DEF MENU_THEME EQU 10
DEF LEVELS_THEME EQU 11
DEF DEAD_THEME EQU 12
DEF GAME_COMPLETED EQU 20


; =======================================
; SOUND REGISTERS (APU)
; =======================================

; --- Channel 1 (Square + Sweep) ---
DEF rNR10 EQU $FF10  ; Sweep register
DEF rNR11 EQU $FF11  ; Sound length / Duty
DEF rNR12 EQU $FF12  ; Volume envelope
DEF rNR13 EQU $FF13  ; Frequency low
DEF rNR14 EQU $FF14  ; Frequency high + control

; --- Channel 2 (Square) ---
DEF rNR21 EQU $FF16  ; Sound length / Duty
DEF rNR22 EQU $FF17  ; Volume envelope
DEF rNR23 EQU $FF18  ; Frequency low
DEF rNR24 EQU $FF19  ; Frequency high + control

; --- Channel 3 (Wave) ---
DEF rNR30 EQU $FF1A  ; Sound on/off
DEF rNR31 EQU $FF1B  ; Sound length
DEF rNR32 EQU $FF1C  ; Output level
DEF rNR33 EQU $FF1D  ; Frequency low
DEF rNR34 EQU $FF1E  ; Frequency high + control

; --- Channel 4 (Noise) ---
DEF rNR41 EQU $FF20  ; Sound length
DEF rNR42 EQU $FF21  ; Volume envelope
DEF rNR43 EQU $FF22  ; Polynomial counter (frequency / randomness)
DEF rNR44 EQU $FF23  ; Counter / consecutive; control

; --- Control registers ---
DEF rNR50 EQU $FF24  ; Master volume (Vin L/R enable)
DEF rNR51 EQU $FF25  ; Sound panning (L/R output enable)
DEF rNR52 EQU $FF26  ; Sound on/off (master enable)

; --- Wave pattern RAM (for channel 3) ---
DEF rWAVE0 EQU $FF30
DEF rWAVE1 EQU $FF31
DEF rWAVE2 EQU $FF32
DEF rWAVE3 EQU $FF33
DEF rWAVE4 EQU $FF34
DEF rWAVE5 EQU $FF35
DEF rWAVE6 EQU $FF36
DEF rWAVE7 EQU $FF37
DEF rWAVE8 EQU $FF38
DEF rWAVE9 EQU $FF39
DEF rWAVEA EQU $FF3A
DEF rWAVEB EQU $FF3B
DEF rWAVEC EQU $FF3C
DEF rWAVED EQU $FF3D
DEF rWAVEE EQU $FF3E
DEF rWAVEF EQU $FF3F

;BANK DIR
DEF rROMB0 EQU $2000

;DEF MAIN_BANK  EQU BANK(main)   ; o BANK(main) o cualquier label que esté en tu banco de juego



;; ===============================
;; REGISTROS DE HARDWARE
;; ===============================

; Registros de LCD/Video
DEF rSTAT    EQU $FF41   ; LCD Status
DEF rSCY     EQU $FF42   ; Scroll Y
DEF rSCX     EQU $FF43   ; Scroll X
DEF rLYC     EQU $FF45   ; LY Compare
DEF rOBP0    EQU $FF48   ; Object Palette 0 Data
DEF rOBP1    EQU $FF49   ; Object Palette 1 Data
DEF rWY      EQU $FF4A   ; Window Y Position
DEF rWX      EQU $FF4B   ; Window X Position

; Registros de Interrupciones
DEF rIE      EQU $FFFF   ; Interrupt Enable
DEF rIF      EQU $FF0F   ; Interrupt Flag

; Bits de Interrupt Enable (rIE) y Interrupt Flag (rIF)
DEF IEF_VBLANK  EQU %00000001   ; Bit 0: VBlank
DEF IEF_STAT    EQU %00000010   ; Bit 1: LCD STAT
DEF IEF_TIMER   EQU %00000100   ; Bit 2: Timer
DEF IEF_SERIAL  EQU %00001000   ; Bit 3: Serial
DEF IEF_JOYPAD  EQU %00010000   ; Bit 4: Joypad

; Bits de LCD STAT (rSTAT)
DEF STATF_LYC     EQU %01000000 ; Bit 6: LYC=LY Interrupt
DEF STATF_MODE10  EQU %00100000 ; Bit 5: Mode 2 OAM Interrupt
DEF STATF_MODE01  EQU %00010000 ; Bit 4: Mode 1 VBlank Interrupt
DEF STATF_MODE00  EQU %00001000 ; Bit 3: Mode 0 HBlank Interrupt
DEF STATF_LYCF    EQU %00000100 ; Bit 2: LYC=LY Flag (Read-only)
DEF STATF_BUSY    EQU %00000010 ; Bit 1: PPU Mode (Read-only)
