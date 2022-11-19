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