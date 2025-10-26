;; ------------------------------------------------------------
;; MENU (con cocinada de efecto)
;; ------------------------------------------------------------
include "includes/constants.inc"
include "includes/macros.inc"

SECTION "Menu scene", ROMX

sc_game_start::
    call sc_game_start_init
.loop
    call UpdateSineOffset
    call read_a
    ;call hUGE_dosound  ;maybe no funciona por reescritura de hl despues del call init
    cp $FF
    jr nz, .loop

    ;; --------------------------------------------------------
    ;; Botón A pulsado → detener efecto antes de salir
    ;; --------------------------------------------------------
    di                          ; para desactivar interrupciones q tocan las pelotillas
    xor a
    ld [wSineActive], a         ; marcar efecto como inactivo
    call StopWaveEffect         ; limpiar STAT/IE y restaurar SCX
    ei                          ; reactivar interrupciones si se requiere
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
    ld a, 16                ; amplitud inicial (±16 px)
    ld [wSineAmplitude], a
    ld a, 1
    ld [wSineActive], a
    xor a
    ld [wSineCycleCount], a ; contador de ciclos completos

    ;; Configurar interrupción HBlank (STAT)
    ld a, %00001000          ; habilitar HBlank interrupt en STAT (bit 3)
    ld [$FF41], a            ; rSTAT ($FF41)
    ld a, $02                ; habilitar la interrupción LCD STAT en IE (bit 1)
    ld [$FFFF], a            ; rIE ($FFFF)

    call lcd_on
    ei                       ; habilitar interrupciones globales
ret


;; ------------------------------------------------------------
;; INTERRUPCIÓN HBLANK: cambia SCX cada línea (solo si activo)
;; ------------------------------------------------------------
SECTION "Interrupts", ROM0[$0048]
HBlankInterrupt::
    push af
    push bc
    push hl
    push de

    ld a, [wSineActive]
    or a
    jr z, .done              ; si no está activo, salir rápido

    ldh a, [rLY]
    and a
    jr z, .done              ; si LY == 0, no procesar

    ; Calcular índice en tabla: (LY + wSinePhase) & 127
    ld hl, SineTable
    ld b, a                  ; B = LY
    ld a, [wSinePhase]
    add a, b
    and %01111111            ; wrap a 128 entradas
    ld e, a
    ld d, 0
    add hl, de
    ld a, [hl]               ; valor base de seno (-16 a +16)
    
    ; Escalar por amplitud: 16=full, 12=3/4, 8=1/2, 4=1/4
    ld b, a                  ; guardar valor seno
    ld a, [wSineAmplitude]
    cp 16
    ld a, b
    jr z, .apply             ; amplitud completa, no escalar
    
    ld a, [wSineAmplitude]
    cp 12
    jr z, .scale_12
    cp 8
    jr z, .scale_8
    ; amplitud 4 o menos: dividir por 4
    ld a, b
    sra a
    sra a
    jr .apply
.scale_12:                   ; ~75% = dividir por 2 + dividir por 8
    ld a, b
    sra a
    ld c, a
    ld a, b
    sra a
    sra a
    sra a
    add a, c
    jr .apply
.scale_8:                    ; 50% = dividir por 2
    ld a, b
    sra a
.apply:
    ld [$FF43], a            ; rSCX ($FF43)

.done:
    pop de
    pop hl
    pop bc
    pop af
    reti


;; ------------------------------------------------------------
;; ACTUALIZAR FASE SENO (con timing real de 5 segundos)
;; ------------------------------------------------------------
UpdateSineOffset::
    ld a, [wSineActive]
    or a
    ret z                    ; si el efecto está apagado, salir

    ld a, [wSineFrameCounter]
    inc a
    cp 6                     ; avanza cada 6 frames = ~10Hz
    jr c, .store
    xor a
    ld [wSineFrameCounter], a

    ; Avanza la fase
    ld a, [wSinePhase]
    inc a
    and %01111111            ; wrap en 128
    ld [wSinePhase], a

    ; Cuando completamos un ciclo (fase vuelve a 0), reducir amplitud
    or a
    jr nz, .ret

    ; Incrementar contador de ciclos
    ld a, [wSineCycleCount]
    inc a
    ld [wSineCycleCount], a
    
    ; Fade-out gradual: reducir 1 punto cada ciclo
    cp 4                     ; después de 4 ciclos, detener
    jr nc, .stop
    
    ; Reducir amplitud gradualmente
    ld a, [wSineAmplitude]
    sub 4                    ; restar 4 cada ciclo (16->12->8->4->0)
    jr nc, .ok
    xor a                    ; si va negativo, poner a 0
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
;; FUNCION: StopWaveEffect - apaga interrupción y restaura SCX
;; ------------------------------------------------------------
StopWaveEffect::
    xor a
    ld [$FF41], a        ; limpia STAT HBlank-enable (desactiva HBlank handling)
    ld [$FFFF], a        ; limpia IE (desactiva interrupciones STAT)
    ld [$FF43], a        ; reinicia SCX a 0
    ret


;; ------------------------------------------------------------
;; TABLA DE SENO (128 entradas, valores -16 a +16)
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
SineTableEnd:


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
