emerald_sword:
    type: item
    material: iron_sword
    display name: <&[item]>Emerald Sword
    data:
        tickcore:
            stats:
                damage_physical: 8
                attack_speed: 1.6

all_the_stats:
    type: item
    material: stone
    display name: <&[item]>All the stats!
    data:
        tickcore:
            stats:
                description: <&[lore]>Some description here.
                reach_distance: 1
                damage_earth: 1
                damage_ender: 1
                damage_fire: 1
                damage_ice: 1
                damage_light: 1
                damage_physical: 1
                damage_shadow: 1
                damage_thunder: 1
                damage_water: 1
                damage_wind: 1
                max_health: 1
                attack_speed: 1
                crit_chance: 1
                crit_damage: 1
                defense: 1
                defense_earth: 1
                defense_ender: 1
                defense_fire: 1
                defense_ice: 1
                defense_light: 1
                defense_physical: 1
                defense_shadow: 1
                defense_thunder: 1
                defense_water: 1
                defense_wind: 1
                abilities:
                    1:
                        name: Light's burst
                        description: Creates a burst of light!
                        trigger: sneak_right_click
                        script: tickcore_ability_lights_burst
                        cooldown: 1s
                        data:
                            damage: 150



lights_splendor:
    type: item
    material: netherite_sword
    display name: <&[item]>Light's Splendor
    data:
        tickcore:
            stats:
                reach_distance: 5
                attack_speed: 3
                damage_light: 85
                abilities:
                    1:
                        name: Light's burst
                        description: Creates a burst of light!
                        trigger: sneak_right_click
                        script: tickcore_ability_lights_burst
                        cooldown: 1s
                        data:
                            damage: 150

ability_test:
    type: item
    material: iron_hoe
    display name: Ability test
    data:
        tickcore:
            stats:
                abilities:
                    1:
                        name: Attack test
                        description: a
                        trigger: attack
                        script: attack_ability_test
                        cooldown: 2s

# cool_sword:
#     type: item
#     material: iron_sword
#     display name: <red>Cool sword
#     data:
#         tickcore:
#             description: <gray>This is a very cool sword.<n>Lol
#             damage_physical: 5
#             attack_speed: 2
#             crit_chance: 0.15
#             crit_damage: 0.2
#             abilities:
#                 1:
#                     name: Explosion
#                     description: Causes an explosion dealing <[parse_value.data.damage]> damage.<n><gray>Cooldown: <[parse_value.cooldown].as[duration].formatted>
#                     trigger: attack
#                     script: explosion
#                     cooldown: 3s
#                     cooldown_message: false
#                     data:
#                         damage: 10
#                 2:
#                     name: Laserbeam
#                     description: Shoot a laserbeam dealing <[parse_value.data.damage]> damage.<n><gray>Cooldown: <[parse_value.cooldown].as[duration].formatted>
#                     trigger: sneak_right_click
#                     script: laserbeam
#                     cooldown: 3s
#                     cooldown_message: false
#                     data:
#                         damage: 10
#                 3:
#                     name: Superslash
#                     description: Deal a devastating slash dealing <[parse_value.data.damage]> damage.
#                     trigger: right_click
#                     script: superslash
#                     cooldown: 0.2s
#                     data:
#                         damage: 25
cool_helmet:
    type: item
    material: iron_helmet
    display name: <&[item]>Cool helmet
    data:
        tickcore:
            stats:
                description: <&[lore]>This is a very cool helmet.
                crit_damage: 50
                defense: 40000
                abilities:
                    1:
                        name: Hello world
                        description: Hello world! <[parse_value.1.data.damage]>
                        trigger: sneak
                        script: hello_world
                        cooldown: 3s
                        cooldown_message: true
                        data:
                            damage: 5

test_item_updates:
    type: item
    material: stone_sword
    display name: <green>Test item updates
    data:
        tickcore:
            description: <gray>Item used to test item updates
            crit_damage: 3