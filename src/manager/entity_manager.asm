INCLUDE "man/entity_manager.inc"

SECTION "Entity Manager Data", WRAM0[$C000] ;;to have all sprites in the same place

components:

sprite_components: DS (MAX_ENTITIES * COMPONENT_SIZE)
sprite_components_end
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

    ;;MEMSET WOWERS OMGW, to write the same value in all
    ld hl, sprite_components
    ld b, sprite_components_size
    xor a  
    call memset_256

    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Allocate Space for one entity
;; Destroys: AF, B, HL
;;
man_entity_alloc:: ;;Inicializarlo
    ;;Alive entities: 0
    xor a
    ld [alive_entitites], a 

    ;;MEMSET WOWERS OMGW, to write the same value in all
    ld hl, sprite_components
    ld b, sprite_components_size
    xor a  
    call memset_256

    ret

    