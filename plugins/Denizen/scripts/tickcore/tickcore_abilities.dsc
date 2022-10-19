attack_ability_test:
    type: task
    debug: false
    script:
    - narrate "I attacked!" targets:<server.online_players>

tickcore_ability_lights_burst:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define ring <[entity].location.points_around_y[radius=1;points=64]>
    - define ring:|:<[entity].location.points_around_x[radius=1;points=64]>
    - define ring:|:<[entity].location.points_around_z[radius=1;points=64]>
    - define origin <[entity].location>
    - repeat 3:
        - foreach <[ring]> as:point:
            - run particle_generator def.locations:<[origin]> def.element:light def.velocity:<[origin].sub[<[point]>]>

        - define random_locations <[origin].repeat_as_list[35].parse[random_offset[1,1,1]]>
        - foreach <[random_locations]> as:location:
            - run particle_generator def.locations:<[origin]> def.element:light def.velocity:<[origin].sub[<[location]>]>

        - define sound_locations <[origin]>
        - playeffect flash at:<[origin]>
        - inject tickcore_effect_data path:sound.light
        - definemap damage_context:
                targets: <[origin].find.living_entities.within[10].exclude[<[entity]>]>
                element_map: <map[light=<[data.damage]>]>
                source: <[entity]>
                cause: magic
                knockback: 1
        - run tickcore_impl_do_damage_task defmap:<[damage_context]>
        - wait 5t

tickcore_ability_lights_beam:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define loc <[entity].eye_location.if_null[null]>
    - if <[loc]> == null:
        - stop
    - playsound <[loc]> sound:entity_lightning_bolt_impact
    - playsound <[loc]> sound:entity_lightning_bolt_thunder
    - playsound <[loc]> sound:block_respawn_anchor_deplete
    - define beam_target <[loc].ray_trace[range=70;default=air]>
    - define beam_ring_locations <[beam_target].points_between[<[loc]>].distance[10].parse[with_yaw[<[loc].yaw>].with_pitch[<[loc].pitch>]]>
    - foreach <[beam_ring_locations]> as:beam_ring_location:
        - define ring_locations <proc[slash_util_ring_proc].context[0.5|32].parse_tag[<[beam_ring_location].up[<[parse_value.forward]>].right[<[parse_value.right]>]>]>
        - foreach <[ring_locations]> as:point:
            - run particle_generator def.locations:<[point]> def.element:light def.velocity:<[point].sub[<[beam_ring_location]>]> def.offset:0,0,0
        - playeffect effect:flash at:<[beam_ring_location]> visibility:50
        - playeffect effect:explosion_large at:<[beam_ring_location]> velocity:5,5,5 visibility:50

    - define points <[beam_target].points_between[<[loc]>].distance[0.25]>
    - run particle_generator def.locations:<[points]> def.element:light def.offset:1,1,1

    - define entities <[points].parse[find.living_entities.within[5]].combine.deduplicate.exclude[<player>]>
    - definemap damage_context:
            targets: <[entities]>
            element_map: <map[light=<[data.damage]>]>
            source: <[entity]>
            cause: magic
            knockback: 1
    - run tickcore_impl_do_damage_task defmap:<[damage_context]>

    - foreach <[points]> as:point:
        - run particle_generator def.locations:<[point]> def.element:light def.velocity:<[point].random_offset[0.5,0.5,0.5].sub[<[point]>]>
