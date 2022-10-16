emerald_sword:
    type: item
    material: iron_sword
    display name: <&[emphasis]>Emerald Sword
    data:
        tickcore:
            damage_physical: 8
            attack_speed: 1.6

admins_blade:
    type: item
    material: netherite_sword
    display name: <&[emphasis]>Admin's Blade
    data:
        tickcore:
            damage_earth: 15
            damage_ender: 15
            damage_fire: 15
            damage_ice: 15
            damage_light: 15
            damage_physical: 15
            damage_shadow: 15
            damage_thunder: 15
            damage_water: 15
            damage_wind: 15

ability_test:
    type: item
    material: iron_hoe
    display name: Ability test
    data:
        tickcore:
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
            description: <&[lore]>This is a very cool helmet.
            crit_damage: 50
            defense: 40000
            abilities:
                1:
                    name: Hello world
                    description: Hello world! <[parse_value.data.damage]>
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