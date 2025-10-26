
include "includes/constants.inc"
include "includes/macros.inc"


SECTION "Sound Manager", ROMX

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
    cp 0
    jr z, play_click

    cp 1
    jr z, play_click
    ; cp 2
    ; jr z, play_explosion

    ret


;------------------------------------------------------------------------------
; En macros.inc he hecho un Macro para reproducir sonidos fácilmente (PLAY_SFX {id_sound})
;------------------------------------------------------------------------------


;------------------------------------------------------------------------------
; Ejemplo de sonido: CLICK
; Usa el canal 2 (onda cuadrada simple)
;------------------------------------------------------------------------------
play_click::
    ; Canal 2 - cuadrada 12.5%, longitud mínima
    ld a, %00000001          ; duty=12.5%, length=1
    ld [SFX_CH2_DUTY_LEN], a

    ; Volumen inicial 15, decae rápido (paso=3)
    ld a, %11100011
    ld [SFX_CH2_VOL_ENV], a

    ; Frecuencia más baja posible (n = 2047)
    ld a, $FC                ; parte baja
    ld [SFX_CH2_FREQ_LO], a
    ld a, %11101001         ; bits altos = 111 (n=2047), bit7=1 para trigger
    ld [SFX_CH2_FREQ_HI], a

    ret
