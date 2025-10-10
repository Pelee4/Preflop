INCLUDE "manager/entity_manager.inc"

SECTION "Entity Manager Data", WRAM0[$C000] ;;to have all sprites in the same place

components:

sprite_components: DS (MAX_ENTITIES * COMPONENT_SIZE)
sprite_components_end:
DEF sprite_components_size = sprite_components_end - sprite_components

alive_entitites: DS 1 ;;to know hoy many entities are alive

SECTION "Entity Manager Code", ROM0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize Entity Manager
;; Destroys: AF, B, HL
;;
man_entity_init:: ;;Inicializarlo
    ;;Alive entities: 0
    xor a
    ld [alive_entitites], a 

    ;;MEMSET WOWERS OMGW to write the same v,alue in all
    ld hl, sprite_components
    ld b, sprite_components_size
    xor a  
    call memset_256

    ;; Invalidate all components (FF (at 15 min) in first item, Y-coordinate)
    ld hl, sprite_components
    ld de, COMPONENT_SIZE
    ld b, MAX_ENTITIES
    .loop:
        ld [hl], INVALID_COMPONENT
        add hl, de
        dec b
    jr nz, .loop

    ret  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Allocate Space for one entity m.a
;; Destroys: AF, B, HL
;;
;; (EMOJIDERETROMAN) RETURNS
;;  HL: Address of allocated component
;;  
man_entity_alloc:: ;;Inicializarlo
    ld hl, sprite_components
    ld de, COMPONENT_SIZE
    .loop
        ld a, [hl]                   ;; A = Component_Sprite.Y
        cp INVALID_COMPONENT         ;; Y += 1 (Only Zero on FF)
        jr z, .found
        ;; Not found
        add hl, de
    jr .loop

    .found:
    ;;HL = Component Address
    ld [hl], RESERVED_COMPONENT
    ld hl, alive_entitites
    inc [hl]

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Return the address of the sprite component array
;;
;; (EMOJIDERETROMAN) RETURNS
;;  HL: Address of Sprite Component Start
;;  B: Sprite components size
;; 
man_entity_get_sprite_components::
    ld hl, sprite_components
    ld b, sprite_components_size
    ret