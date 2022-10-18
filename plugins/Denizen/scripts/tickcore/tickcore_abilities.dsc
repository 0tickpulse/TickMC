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
        - define particle_locations <[origin]>
        - foreach <[ring]> as:point:
            - define velocity <[origin].sub[<[point]>]>
            - inject tickcore_effect_data path:particle.light

        - define random_locations <[origin].repeat_as_list[35].parse[random_offset[1,1,1]]>
        - foreach <[random_locations]> as:location:
            - define velocity <[origin].sub[<[location]>]>
            - inject tickcore_effect_data path:particle.light

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