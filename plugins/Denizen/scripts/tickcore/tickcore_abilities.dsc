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
    - define ring <[entity].location.points_around_y[radius=1;points=32]>
    - define origin <[entity].location>
    - repeat 3:
        - foreach <[ring]> as:point:
            - define velocity <[origin].sub[<[point]>]>
            - define particle_locations <[origin]>
            - define sound_locations <[origin]>
            - inject tickcore_effect_data path:particle.light
            - inject tickcore_effect_data path:sound.light
        - definemap damage_context:
                targets: <[origin].find.living_entities.within[10].exclude[<[entity]>]>
                element_map: <map[light=<[data.damage]>]>
                source: <[entity]>
                cause: magic
                knockback: 1
        - run tickcore_impl_do_damage_task defmap:<[damage_context]>
        - wait 5t