SECTION "Render System Code", ROM0

;;;;
;;
;sys_render_init::

DEF OAM_START equ $FE00

sys_render_update::
    call wait_vblank_start  ;;;<<<<----- 
    call man_entity_get_sprite_components
    ;; HL: sprite components
    ;; B: sprite_components_size
    ld de, OAM_START
    call memcpy_256



    ret