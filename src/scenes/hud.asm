; =============================================================================
; HUD SYSTEM SIMPLE - Usa tiles del background
; =============================================================================
; Dibuja/borra un tile en la esquina superior derecha cuando el jugador
; coge/suelta un bloque
; =============================================================================

include "includes/constants.inc"
include "engine/player/player_data.inc"

; =============================================================================
; CONSTANTES DEL HUD
; =============================================================================
DEF HUD_TILE_X EQU 17       ; Posición X en el tilemap (columna 17 de 20)
DEF HUD_TILE_Y EQU 1        ; Posición Y en el tilemap (fila 1)
DEF HUD_TILE_BLOCK EQU $14  ; Tile del bloque (el mismo del suelo)
DEF HUD_TILE_EMPTY EQU $18  ; Tile vacío

; Cálculo de dirección en VRAM: $9800 + (Y * 32) + X
; Para Y=1, X=17: $9800 + 32 + 17 = $9800 + 49 = $9831
DEF HUD_VRAM_ADDR EQU $9831

SECTION "HUD_VARS", WRAM0
wHUD_LastState:: ds 1  ; Último estado conocido (0=sin bloque, 1=con bloque)

; =============================================================================
; FUNCIONES DEL HUD
; =============================================================================
SECTION "HUD", ROM0

EXPORT HUD_Init
EXPORT HUD_Update
EXPORT HUD_Show
EXPORT HUD_Hide

; -----------------------------------------------------------------------------
; HUD_Init - Inicializa el HUD
; -----------------------------------------------------------------------------
HUD_Init::
    ; Inicialmente el jugador no tiene bloque
    xor a
    ld [wHUD_LastState], a
    
    ; Limpiamos el tile del HUD
    call HUD_Hide
    ret

; -----------------------------------------------------------------------------
; HUD_Update - Actualiza el HUD basándose en PLAYER_INT_BOOL
; -----------------------------------------------------------------------------
HUD_Update::
    ; Verificamos el estado actual del jugador
    ld a, [player_data + PLAYER_INT_BOOL]
    ld b, a  ; Guardamos el estado actual en B
    
    ; Verificamos el estado anterior
    ld a, [wHUD_LastState]
    
    ; Si son iguales, no hacemos nada
    cp b
    ret z
    
    ; El estado cambió, actualizamos
    ld a, b
    ld [wHUD_LastState], a
    
    ; Si tiene bloque (1), mostramos el tile
    cp 1
    jr z, HUD_Show
    
    ; Si no tiene bloque (0), ocultamos el tile
    call HUD_Hide
    ret

; -----------------------------------------------------------------------------
; HUD_Show - Muestra el icono del bloque
; -----------------------------------------------------------------------------
HUD_Show::
    call wait_vblank_start
    
    ; Escribimos el tile del bloque en la posición del HUD
    ld hl, HUD_VRAM_ADDR
    ld a, HUD_TILE_BLOCK
    ld [hl], a
    
    ret

; -----------------------------------------------------------------------------
; HUD_Hide - Oculta el icono del bloque
; -----------------------------------------------------------------------------
HUD_Hide::
    call wait_vblank_start
    
    ; Escribimos un tile vacío en la posición del HUD
    ld hl, HUD_VRAM_ADDR
    ld a, HUD_TILE_EMPTY
    ld [hl], a
    
    ret