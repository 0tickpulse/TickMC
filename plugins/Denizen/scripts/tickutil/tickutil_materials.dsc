# @ ----------------------------------------------------------
# TickUtil Materials
# Adds many utility scripts that make materials easier to
# manage.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickutil_materials_cache:
    type: world
    debug: false
    events:
        on reload scripts:
        - flag server tickutil_materials.cache.pseudo_indestructible_blocks:<server.material_types.filter[is_block].filter_tag[<[filter_value].block_strength.is_more_than[50].or[<[filter_value].block_strength.equals[-1]>]>].parse[name]>
        #on player breaks block:
        #- define a <proc[tickutil_materials.script.pseudo_indestructible_blocks]>
tickutil_materials:
    type: procedure
    debug: false
    script:
        pseudo_indestructible_blocks:
        - determine <server.flag[tickutil_materials.cache.pseudo_indestructible_blocks].if_null[<server.material_types.filter[is_block].filter_tag[<[filter_value].block_strength.is_more_than[50].or[<[filter_value].block_strength.equals[-1]>]>].parse[name]>]>