
include "includes/constants.inc"
include "includes/macros.inc"

SECTION "Sound Manager", ROM0

;------------------------------------------------------------------------------
; Inicializa el chip de sonido
;------------------------------------------------------------------------------
init_sound::
    ; Activar el sistema de sonido (bit 7 del registro maestro)
    ld a, %10000000
    ld [SFX_MASTER_ENABLE], a

    ; Configurar el volumen maestro: máximo en ambos canales (L y R)
    ld a, %01110111      ; bits 6-4 = vol L, bits 2-0 = vol R
    ld [SFX_MASTER_VOL], a

    ; Activar todos los canales para ambas salidas (L y R)
    ld a, %11111111
    ld [SFX_CHANNEL_MIX], a

    ret


;------------------------------------------------------------------------------
; Reproduce un sonido según el ID pasado en A
;------------------------------------------------------------------------------
play_sound::
    cp 1
    jp z, play_move

    cp 2
    jp z, play_place_block

    cp 3
    jp z, play_death

    cp 4
    jp z, play_completed

    cp 5
    jp z, play_pickup_block

    cp 6
    jp z, play_collide_wall

    ret


;------------------------------------------------------------------------------
; En macros.inc hay un Macro para reproducir sonidos fácilmente (PLAY_SFX {id_sound})
;------------------------------------------------------------------------------





StopMusic::
    ; Deja de llamar a hUGE_dosound en el bucle principal
    ; y limpia todos los canales de sonido

    xor a
    ld [rNR10], a    ; CH1 sweep off
    ld [rNR11], a
    ld [rNR12], a
    ld [rNR13], a
    ld [rNR14], a

    ld [rNR21], a    ; CH2 off
    ld [rNR22], a
    ld [rNR23], a
    ld [rNR24], a

    ld [rNR30], a    ; CH3 off
    ld [rNR31], a
    ld [rNR32], a
    ld [rNR33], a
    ld [rNR34], a

    ld [rNR41], a    ; Noise off
    ld [rNR42], a
    ld [rNR43], a
    ld [rNR44], a

    ; Master off
    ld [rNR50], a
    ld [rNR51], a
    ld [rNR52], a
    ret











;------------------------------------------------------------------------------
; Ejemplo de sonido: CLICK
; Usa el canal 2 (onda cuadrada simple)
;------------------------------------------------------------------------------
play_death::
    ; Canal 2 - cuadrada 12.5%, longitud mínima
    ld a, %00000001          ; duty=12.5%, length=1
    ld [SFX_CH2_DUTY_LEN], a

    ; Volumen inicial 15, decae rápido (paso=3)
    ld a, %00100011
    ld [SFX_CH2_VOL_ENV], a

    ; Frecuencia más baja posible (n = 2047)
    ld a, $FC                ; parte baja
    ld [SFX_CH2_FREQ_LO], a
    ld a, %11101001         ; bits altos = 111 (n=2047), bit7=1 para trigger
    ld [SFX_CH2_FREQ_HI], a

    ret







;------------------------------------------------------------------------------
; SONIDO 1 - "DEATH" (hihat/snare)
; Usa canal 4 - ruido blanco (ruido corto y brillante)
;------------------------------------------------------------------------------
play_move::
    ; Sweep ascendente lento
    ld a, %00111001         ; tiempo=3, increase, shift=1
    ld [rNR10], a
  
    ; Duty 50%, length media
    ld a, %10011111         ; duty=50%, length=31
    ld [rNR11], a
  
    ; Volumen alto, decay suave
    ld a, %00110001         ; vol=15, decrease, step=1
    ld [rNR12], a
  
    ; Frecuencia baja al inicio
    ld a, $80
    ld [rNR13], a
    ld a, %11000010         ; trigger + use length
    ld [rNR14], a
    ret




play_pickup_block::
    ; Length MUY corta
    ld a, %00000001         ; length=1 (más seco)
    ld [rNR41], a
    
    ; Volumen MÍNIMO, decay ultra rápido
    ld a, %00110111         ; vol=1 (muy bajo), decrease, step=7 (máximo)
    ld [rNR42], a
    
    ; Ruido MUY grave (menos "tsss")
    ld a, %01100111         ; shift=6 (más grave), wide, divider=7
    ld [rNR43], a
    
    ; Disparo
    ld a, %11000000         ; trigger + use length
    ld [rNR44], a
    ret



play_place_block::
    ; Length corta (igual)
    ld a, %11100010
    ld [rNR41], a
    
    ; Volumen MÁS BAJO, decay MÁS RÁPIDO
    ld a, %00100110         ; vol=2 (era 3), decrease, step=6 (era 4)
    ld [rNR42], a
    
    ; Ruido más grave y menos agresivo
    ld a, %01010110         ; shift=5 (era 4), wide, divider=6
    ld [rNR43], a
    
    ; Disparo
    ld a, %11000100
    ld [rNR44], a
    ret



play_collide_wall::
    ; Sweep ascendente lento
    ld a, %00111001         ; tiempo=3, increase, shift=1
    ld [rNR10], a
  
    ; Duty 50%, length media
    ld a, %10011111         ; duty=50%, length=31
    ld [rNR11], a

    ; Volumen alto, decay suave
    ld a, %01110001         ; vol=15, decrease, step=1
    ld [rNR12], a
  
    ; Frecuencia baja al inicio
    ld a, $80
    ld [rNR13], a
    ld a, %11000010         ; trigger + use length
    ld [rNR14], a
    ret





play_get_smtng::
    ; Sweep ascendente muy rápido
    ld a, %00010101         ; tiempo=1, increase, shift=5
    ld [rNR10], a
    
    ; Duty 12.5%, length media
    ld a, %00011111         ; duty=12.5%, length=31
    ld [rNR11], a
    
    ; Volumen medio, sin decay
    ld a, %10110000         ; vol=11, no envelope
    ld [rNR12], a
    
    ; Frecuencia inicial baja
    ld a, $00
    ld [rNR13], a
    ld a, %11000010         ; trigger + use length
    ld [rNR14], a
    ret





play_completed::
    ; Sweep: sube rápido
    ld a, %00010111         ; tiempo=1, increase, shift=7
    ld [rNR10], a
    
    ; Duty 12.5%, length corta
    ld a, %00010000         ; duty=12.5%, length=16
    ld [rNR11], a
    
    ; Volumen alto, sin envelope
    ld a, %11110000         ; vol=15, no envelope
    ld [rNR12], a
    
    ; Frecuencia media-alta
    ld a, $00
    ld [rNR13], a
    ld a, %11000111         ; trigger + use length
    ld [rNR14], a
    ret


















;play_move::
    ; === PRIMER TONO (impacto) ==

