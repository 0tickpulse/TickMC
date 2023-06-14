destiny:
    type: item
    material: bow
    display name: <&[item]>Destiny
    mechanisms:
        custom_model_data: 1
    data:
        tickcore:
            stats:
                implementations:
                - weapon_bow
                damage_shadow: 950
                arrow_speed: 600
                abilities:
                    1:
                        name: Rapid fire
                        trigger: sneak_left_click
                        description: Shoots multiple arrows that deal shadow damage, and launches forward.
                        cooldown: 0.5s
                        script: destiny_rapid_fire
                        data:
                            multiplier: 1.5
                    2:
                        name: Shadow burst
                        trigger: custom_arrow_hit
                        description: Arrows explode on impact.
                        script: destiny_shadow_burst
                        data:
                            multiplier: 3.5
                    3:
                        name: Fate's end
                        trigger: sneak_right_click
                        description: Arrows start to rain from the sky.
                        script: destiny_fates_end
                        data:
                            multiplier: 1.5

destiny_rapid_fire:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define target <[entity].eye_location.ray_trace[range=150;default=air;entities=*;ignore=<[entity]>]>
    - definemap task_data:
        range: 150
        speed: 8
    - definemap element_map:
        light: 0
        shadow: <[entity].proc[tickcore_proc.script.entities.get_stat].context[damage_shadow].mul[<[data.multiplier]>]>

    - define origins <list>
    # Add points along a semicircle
    # 3 radius, 5 points
    # Point 1: (-3, 0)
    # Point 2: (-1.5, 2.598)
    # Point 3: (1.5, 2.598)
    # Point 4: (3, 0)
    # Point 5: (1.5, -2.598)
    - define origins:->:<[entity].eye_location.left[3].up[0]>
    - define origins:->:<[entity].eye_location.left[1.5].up[2.598]>
    - define origins:->:<[entity].eye_location.right[1.5].up[2.598]>
    - define origins:->:<[entity].eye_location.right[3].up[0]>
    - define origins:->:<[entity].eye_location.right[1.5].up[-2.598]>

    # Add eye location
    - define origins:->:<[entity].eye_location>

    # Launch forward
    - define velocity <[entity].eye_location.direction.vector.mul[4]>
    - adjust <[entity]> velocity:<[velocity]>

    - foreach <[origins]> as:origin:
        - run tickcore_archery_shoot_task def.data:<[task_data]> def.entity:<[entity]> def.element_map:<[element_map]> def.origin:<[origin]> def.target:<[target]>
        - wait 1t

destiny_shadow_burst:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define origin <[context.point]>
    - define radius 7.5

    - run tickcore_specialized_sounds_task def.locations:<[origin]> def.element:shadow

    # Do damage
    - define entities <[origin].find.living_entities.within[<[radius]>].exclude[<[entity]>]>
    - define new_element_map <[context.element_map].parse_value_tag[<[parse_value].mul[<[data.multiplier]>]>]>
    - run tickcore_impl_do_damage_task def.source:<[entity]> def.element_map:<[new_element_map]> def.targets:<[entities]>

    - define random_locations <[origin].repeat_as_list[750].parse[with_yaw[<util.random.int[-180].to[180]>].with_pitch[<util.random.int[-180].to[180]>].forward[<[radius]>]]>
    # - run particle_generator def.locations:<[location]> def.element:water def.offset:0
    - run tickcore_specialized_effects_task def.element:shadow def.locations:<[random_locations]> def.offset:0 def.entity:<[entity]> def.sound:false
    - run tickcore_specialized_sounds_task def.locations:<[origin]> def.element:shadow
    - playsound sound:entity_generic_explode <[origin]> volume:2.5 pitch:1
    - wait 1t

destiny_fates_end:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define loc <[entity].location>
    - repeat 25 as:offset:
        # play particles
        - define loc <[loc].above[1]>
        - run tickcore_specialized_effects_task def.element:shadow def.locations:<[loc]> def.offset:0 def.entity:<[entity]> def.sound:false
        - wait 1t
    - playsound sound:block_beacon_deactivate <[entity]> volume:3 pitch:1
    - repeat 10 as:radius:
        - define circle <[loc].points_around_y[radius=<[radius]>;points=100]>
        - run tickcore_specialized_effects_task def.element:shadow def.locations:<[circle]> def.offset:0 def.entity:<[entity]> def.sound:false
        - wait 1t
    - define points <[loc].repeat_as_list[10].parse[random_offset[10,0,10]]>
    - definemap element_map:
        light: 0
        shadow: <[entity].proc[tickcore_proc.script.entities.get_stat].context[damage_shadow].mul[<[data.multiplier]>]>
    - definemap data:
        range: 150
        speed: 0.5
    - foreach <[points]> as:point:
        - run tickcore_archery_shoot_task def.data:<[data]> def.entity:<[entity]> def.element_map:<[element_map]> def.origin:<[point]> def.target:<[point].below[5]>
        - run tickcore_specialized_effects_task def.element:shadow def.locations:<[circle]> def.offset:0 def.entity:<[entity]> def.sound:false
        - wait 4t
