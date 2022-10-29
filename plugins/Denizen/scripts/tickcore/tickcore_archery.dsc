# @ ----------------------------------------------------------
# TickCore Archery
# Overhauls the archery system in Minecraft.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickcore_archery_world:
    type: world
    debug: false
    events:
        on player shoots bow:
        - determine passively cancelled
        - run tickcore_archery_custom_shoot_task def.element_map:[physical=1] def.force:<context.force> def.end_script:explosion_1 def.hit_script:explosion_1 def.shooter:<player>
        - narrate "test cancel"

explosion_1:
    type: task
    definitions: location|force|element_map
    script:
    - playeffect effect:explosion_large at:<[location]> offset:0,0,0
    - narrate <queue.definitions.separated_by[<n>]>

tickcore_archery_custom_shoot_definition_matcher_task:
    type: task
    debug: false
    definitions: 1|2|3|4|locations|shot_entities|last_entity|hit_entities
    script:

    - if <[1]> == null:
        - stop

    - define location <[location]>
    - define shot_entities <[shot_entities]>

    - if <util.scripts.parse[name]> !contains <[1]>:
        - debug error "<[1]> is not a valid hit_script!"
        - stop

    - run <[1]> def.arrow:<[shot_entities].get[1]> def.location:<[location]> def.element_map:<[2]> def.force:<[3]> def.lead:<[4].if_null[null]> def.hit_entities:<[hit_entities]>

tickcore_archery_custom_shoot_task:
    type: task
    debug: false
    definitions: element_map|force|lead|tick_script|hit_script|end_script|deal_damage|shooter
    script:
    - playsound <[shooter].location> sound:entity_arrow_shoot
    - if <[lead].exists>:
        - shoot arrow[damage=0] speed:<[force].if_null[1]> save:arrow lead:<[lead]> def:<[hit_script].if_null[null]>|<[element_map]>|<[force]>|<[lead]> script:tickcore_archery_custom_shoot_definition_matcher_task shooter:<[shooter]>
    - else:
        - shoot arrow[damage=0] speed:<[force].if_null[1]> save:arrow def:<[hit_script].if_null[null]>|<[element_map]>|<[force]> script:tickcore_archery_custom_shoot_definition_matcher_task shooter:<[shooter]>
    - define arrow <entry[arrow].shot_entity>
    - flag <[arrow]> tickcore_archery:<queue.definition_map>
    - while !<[arrow].attached_block.exists> && <[arrow].exists> && <[arrow].is_spawned>:
        - if <[tick_script].exists>:
            - if <util.scripts.parse[name]> contains <[tick_script]>:
                - run <[tick_script]> def.arrow:<[arrow]> def.location:<[arrow].location> def.element_map:<[element_map]> def.force:<[force]> def.lead:<[lead].if_null[null]>
            - else:
                - debug error "<[tick_script]> is not a valid tick_script!"
        - wait 1t
    - wait 10s
    - define arrow:!

tickcore_archery_custom_shoot_world:
    type: world
    debug: false
    events:
        on arrow hits entity:
        - if <context.projectile.has_flag[tickcore_archery]>:
            - determine cancelled
            - definemap run_map:
                    targets: <context.hit_entity>
                    element_map: <context.projectile.flag[tickcore_archery.element_map]>
                    source: <context.shooter>
                    cause: magic
            - run tickcore_impl_do_damage_task defmap:<[run_map]>