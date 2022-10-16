tickcore_effect_data:
    type: data
    debug: false
    sound:
        physical: entity.player.attack.sweep
    particle:
        physical: crit
    symbol:
        physical: PHYS
    slash_effects:
        physical:
        - playsound <[entity].location> sound:<script[tickcore_effect_data].parsed_key[sound.<[element]>]> custom
        - playeffect effect:<script[tickcore_effect_data].parsed_key[particle.<[element]>]> at:<[locations].parse[points_between[<[entity].location>].distance[0.15].get[1].to[3]].combine> offset:0,0,0

tickcore_data:
    type: data
    item updating:
        container open: true
        item pickup: true
    slots to check for stats:
    - HEAD
    - CHEST
    - LEGS
    - FEET
    - HAND
    - OFFHAND
    default item properties:
        hides: ALL
    lore order:
    - damage_physical
    - description
    - attack_speed
    - crit_chance
    - crit_damage
    - defense
    - resistance_physical
    - abilities
    - gemstones
    stats:
        gemstones:
            lore format:
            - <empty>
            - <[value].parse[get[name]].separated_by[<n>]>

        damage_physical:
            default: 0
            lore format:
            - <&[base]>Physical damage: <&[emphasis]><[value]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        resistance_physical:
            default: 0
            lore format:
            - <&[base]>Physical resistance: <&[emphasis]><[value]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        description:
            lore format:
            - <[value].separated_by[<n>]>
            - <empty>
            item stat calculation: <[map].values>
            player stat calculation: null

        abilities:
            lore format:
            - <empty>
            - <[value].parse_tag[<&[emphasis]><[parse_value.trigger].replace[_].with[ ].to_titlecase> Ability: <[parse_value.name]><n><&[base]><[parse_value.description].parsed>].separated_by[<n.repeat[2]>]>
            item stat calculation: <[map].values.combine.parse[values].combine>
            player stat calculation: <[map].values.combine>

        attack_speed:
            default: 1
            lore format:
            - <&[base]>Attack Speed: <&[emphasis]><[value]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        crit_chance:
            default: 0
            lore format:
            - <&[base]>Crit Chance: <&[emphasis]><[value].mul[100]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        crit_damage:
            default: 0
            lore format:
            - <&[base]>Crit Damage: <&[emphasis]><[value].mul[100]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        defense:
            default: 0
            lore format:
            - <empty>
            - <&[base]>Defense: <&[emphasis]><[value]>
            new item on generate: <[item].proc[tickcore_proc.script.items.add_attribute].context[<map[generic_armor=0;generic_armor_toughness=0]>]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>