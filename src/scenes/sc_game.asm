;; EXAMPLE FILE. IT MAKES A LEVEL BASICALLY
;; AQUI DEBERIAMOS PONER NUESTRO MAIN ACTUAL PERO NO TENGO COJONES A CAMBIARLO

SECTION "Scene Game", ROM0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SCENE GAME INIT
sc_game_init::
    call man_entity_init
    call man_entity_alloc
    ;; HL: Address (para hacer luego)
    ;; ESTO ES UNA REFERENCIA EJEMPLO DE UN SPRITE
    ;;;;;;;;;;;;;;;;;;
    ;;ld d, h
    ;;de e, l
    ;; ld hl, sprite_1
    ;;ld b, 4
    ;;call memcpy_256
    ;;;;;;;;;;;;;;;;


    call wait_vblank_start

    ;; set background palette
    ;;
    ;;TURNS OFF THE SCREEN
    call lcd_off
    ;; SET_BGP DEFAULT_PAL
    ;; SET_OBP1 DEFAULT_PAL
    ;; MEMCPY_256 sc_game_fence_tiles, VRAM_TILE_20, 2*VRAM_TILE_SIZE

    ;; TURNS ON THE SCREEN
    call lcd_on

    ;; MOVE TO RAM
    ;;


    ret

sc_game_run::
    .loop:
        call sys_render_update
        ;; sys.....
    jr .loop

    ret