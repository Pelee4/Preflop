;; ------------------------------------------------------------
;; MENU (con efecto sine wave + música)
;; ------------------------------------------------------------
include "includes/constants.inc"
include "includes/macros.inc"

SECTION "Menu scene", ROMX

sc_game_start::
    call sc_game_start_init
.loop
    halt                        ; Espera a cualquier interrupción (eficiente)
    call UpdateSineOffset
    call read_a
    cp $FF
    jr nz, .loop

    ;; Botón A pulsado → detener efecto antes de salir

    ; di
    ; xor a
    ; ld [wSineActive], a
    ; call StopWaveEffect
    ; ei

    call StopMusic
    xor a 
    ld [$FF41], a            ; rSTAT = 0 (desactiva HBlank)
    ld [$FFFF], a            ; rIE = 0 (desactiva TODO)
ret

sc_game_start_init::
    call lcd_off
    
    ;; PALETAS
    ld hl, rBGP
    ld [hl], %00100111
    ld hl, rOBJP
    ld [hl], %11100100
    
    MEMSET $9904, 0, 13
    MEMSET $9924, 0, 13

    ;; Copiar tileset y mapa
    MEMCPY_2 PantallaInicio, $8000, 2000
    MEMCPY_2 PantallaInicioMap, $9800, 576

    ;; Inicializar variables del efecto
    xor a
    ld [wSinePhase], a
    ld [wSineFrameCounter], a
    ld a, 16
    ld [wSineAmplitude], a
    ld a, 1
    ld [wSineActive], a
    xor a
    ld [wSineCycleCount], a

    ;; CRÍTICO: Habilitar AMBAS interrupciones
    ld a, %00001000          ; HBlank interrupt en STAT
    ldh [rSTAT], a
    
    ld a, %00000011          ; VBlank (bit 0) + LCD STAT (bit 1)
    ldh [rIE], a
    
    call lcd_on
    ei
ret


;; ------------------------------------------------------------
;; VECTOR DE INTERRUPCIÓN VBLANK
;; ------------------------------------------------------------
SECTION "VBlank Interrupt", ROM0[$0040]
    jp VBlankHandler

SECTION "VBlank Handler", ROM0
VBlankHandler::
    push af
    push bc
    push de
    push hl
    
    call hUGE_dosound        ; Actualizar música cada VBlank
    
    pop hl
    pop de
    pop bc
    pop af
    reti


;; ------------------------------------------------------------
;; VECTOR DE INTERRUPCIÓN LCD STAT (HBlank para sine wave)
;; ------------------------------------------------------------
SECTION "LCD STAT Interrupt", ROM0[$0048]
    jp HBlankInterrupt

SECTION "HBlank Handler", ROM0
HBlankInterrupt::
    push af
    push bc
    push hl
    push de

    ld a, [wSineActive]
    or a
    jr z, .done

    ldh a, [rLY]
    and a
    jr z, .done

    ; Calcular índice en tabla
    ld hl, SineTable
    ld b, a
    ld a, [wSinePhase]
    add a, b
    and %01111111
    ld e, a
    ld d, 0
    add hl, de
    ld a, [hl]
    
    ; Escalar por amplitud
    ld b, a
    ld a, [wSineAmplitude]
    cp 16
    ld a, b
    jr z, .apply
    
    ld a, [wSineAmplitude]
    cp 12
    jr z, .scale_12
    cp 8
    jr z, .scale_8
    
    ld a, b
    sra a
    sra a
    jr .apply
.scale_12:
    ld a, b
    sra a
    ld c, a
    ld a, b
    sra a
    sra a
    sra a
    add a, c
    jr .apply
.scale_8:
    ld a, b
    sra a
.apply:
    ldh [rSCX], a

.done:
    pop de
    pop hl
    pop bc
    pop af
    reti


;; ------------------------------------------------------------
;; ACTUALIZAR FASE SENO
;; ------------------------------------------------------------
UpdateSineOffset::
    ld a, [wSineActive]
    or a
    ret z

    ld a, [wSineFrameCounter]
    inc a
    cp 6
    jr c, .store
    xor a
    ld [wSineFrameCounter], a

    ld a, [wSinePhase]
    inc a
    and %01111111
    ld [wSinePhase], a

    or a
    jr nz, .ret

    ld a, [wSineCycleCount]
    inc a
    ld [wSineCycleCount], a
    
    cp 4
    jr nc, .stop
    
    ld a, [wSineAmplitude]
    sub 4
    jr nc, .ok
    xor a
.ok:
    ld [wSineAmplitude], a
    or a
    ret nz
    jr .stop

.stop:
    xor a
    ld [wSineActive], a
    call StopWaveEffect
    ret

.ret:
    ret

.store:
    ld [wSineFrameCounter], a
    ret


;; ------------------------------------------------------------
;; DETENER EFECTO
;; ------------------------------------------------------------
StopWaveEffect::
    xor a
    ldh [rSTAT], a       ; Desactiva HBlank interrupt
    ld a, %00000001      ; Solo deja VBlank activa (para música)
    ldh [rIE], a
    xor a
    ldh [rSCX], a
    ret


;; ------------------------------------------------------------
;; TABLA DE SENO
;; ------------------------------------------------------------
SECTION "Sine table", ROMX
SineTable:
    db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    db 16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
    db 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15
    db -16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1
    db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    db 16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
    db 0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15
    db -16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1


;; ------------------------------------------------------------
;; ENTRADA BOTÓN A
;; ------------------------------------------------------------
read_a::
    ld a, SELECT_BUTTONS
    ld [rJOYP], a
    ld a, [rJOYP]
    ld a, [rJOYP]
    ld a, [rJOYP]

    bit A_PRESSED, a
    ret nz

    ld a, $FF
ret



;; ------------------------------------------------------------
;; Limpia efectos y configuración del menú antes de ir a niveles
;; ------------------------------------------------------------
CleanupMenuEffects::
    di
    
    ; Detener música
    call StopMusic
    
    ; Detener efecto sine wave
    xor a
    ld [wSineActive], a
    ldh [rSTAT], a          ; Desactiva HBlank
    ldh [rSCX], a           ; Resetea scroll
    
    ; Solo VBlank activa (para música en niveles si la usas)
    ld a, IEF_VBLANK
    ldh [rIE], a
    
    ei
    ret
