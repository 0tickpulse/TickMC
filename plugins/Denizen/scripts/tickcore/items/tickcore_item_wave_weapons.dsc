spear_of_waves:
    type: item
    material: iron_sword
    display name: <&[item]>Spear of Waves
    mechanisms:
        custom_model_data: 1
    data:
        tickcore:
            stats:
                implementations:
                - weapon_melee
                damage_water: 5
                attack_speed: 2.4
                abilities:
                    1:
                        name: Cycle of life
                        trigger: custom_damage
                        description: Creates a circular slash around the target's location.
                        cooldown: 0.3s
                        cooldown message: false
                        script: tickcore_ability_spear_of_waves_cycle_of_life
                        data:
                            damage_multiplier: 0.5
                            radius: 2

tickcore_ability_spear_of_waves_cycle_of_life:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - wait 0.3s
    - if !<[context.entity].is_spawned>:
        - stop
    - define location <[context.entity].eye_location.with_pitch[<util.random.decimal[-45].to[45]>]>
    - define locations <proc[slash_util_ring_proc].context[<[data.radius]>|32].parse_tag[<[location].up[<[parse_value.forward]>].right[<[parse_value.right]>]>]>
    - run tickcore_specialized_effects_task def.entity:<[entity]> def.locations:<[locations]> def.element:water

    - run tickcore_specialized_sounds_task def.locations:<[location]> def.element:water

    - define damage <[data.damage_multiplier].mul[<[entity].proc[tickcore_proc.script.entities.get_stat].context[damage_water]>]>
    - definemap defmap:
            targets: <[location].find.living_entities.within[<[data.radius]>].exclude[<[entity]>]>
            element_map: <map.with[water].as[<[damage].parsed>]>
            source: <[entity]>
            trigger_event: false
    - foreach <[defmap.targets]> as:entity:
        - adjust <[entity]> no_damage_duration:0
    - run tickcore_impl_do_damage_task defmap:<[defmap]>

bow_of_waves:
    type: item
    material: bow
    display name: <&[item]>Bow of Waves
    mechanisms:
        custom_model_data: 1
    flags:
        tickcore_archery_block: sea_lantern
    data:
        tickcore:
            stats:
                implementations:
                - weapon_bow
                damage_water: 6.5
                abilities:
                    1:
                        #something different than the spear
                        name: Bubble
                        trigger: custom_arrow_hit
                        description: Creates an exploding bubble around the target's location, dealing damage to nearby enemies.
                        cooldown: 2s
                        cooldown message: false
                        script: tickcore_ability_bow_of_waves_bubble
                        data:
                            damage_multiplier: 1
                            radius: 5

tickcore_ability_bow_of_waves_bubble:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - wait 5t
    - define origin <[context.point]>
    - define radius <[data.radius]>

    - run tickcore_specialized_sounds_task def.locations:<[origin]> def.element:water

    # Do damage
    - define entities <[origin].find.living_entities.within[<[radius]>].exclude[<[entity]>]>
    - define new_element_map <[context.element_map].parse_value_tag[<[parse_value].mul[<[data.damage_multiplier]>]>]>
    - run tickcore_impl_do_damage_task def.source:<[entity]> def.element_map:<[new_element_map]> def.targets:<[entities]>

    - repeat <[radius]> as:radius:
        - define random_locations <[origin].repeat_as_list[<[radius].mul[50]>].parse[with_yaw[<util.random.int[-180].to[180]>].with_pitch[<util.random.int[-180].to[180]>].forward[<[radius]>]]>
        # - run particle_generator def.locations:<[location]> def.element:water def.offset:0
        - run tickcore_specialized_effects_task def.element:water def.locations:<[random_locations]> def.offset:0 def.entity:<[entity]> def.sound_locations:<[origin]>
        - wait 1t
