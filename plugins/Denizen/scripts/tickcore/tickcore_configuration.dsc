tickcore_effect_data:
    type: data
    debug: false
    color:
        earth: <color[#609A0F]>
        ender: <color[#A14773]>
        fire: <color[#FA6A0A]>
        ice: <color[#A3EEFF]>
        light: <color[#FFF089]>
        physical: <color[gray]>
        shadow: <color[#5825F1]>
        thunder: <color[#FFF530]>
        water: <color[#249FDE]>
        wind: <color[#FFFFFF]>
    sound:
        earth:
        - playsound sound:block.grass.break at:<[sound_locations]> custom
        ender:
        - playsound sound:entity.enderman.hurt at:<[sound_locations]> custom
        fire:
        - playsound sound:entity.blaze.hurt at:<[sound_locations]> custom
        ice:
        - playsound sound:block.glass.break at:<[sound_locations]> custom
        light:
        - playsound sound:block.beacon.deactivate at:<[sound_locations]> custom
        physical:
        - playsound sound:entity.player.attack.sweep at:<[sound_locations]> custom
        shadow:
        - playsound sound:entity.wither.shoot at:<[sound_locations]> custom
        thunder:
        - playsound sound:block.beacon.deactivate at:<[sound_locations]> custom
        water:
        - playsound sound:entity.generic.splash at:<[sound_locations]> custom
        wind:
        - playsound sound:entity.arrow.shoot at:<[sound_locations]> custom
    particle:
        earth:
        - playeffect effect:block_crack special_data:dirt at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        ender:
        - playeffect effect:reverse_portal at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        fire:
        - playeffect effect:flame at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        ice:
        - playeffect effect:block_crack special_data:ice at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        light:
        - playeffect effect:end_rod at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        physical:
        - playeffect effect:crit at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        shadow:
        - playeffect effect:dust_color_transition special_data:1|<script.parsed_key[color.shadow]>|black at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        thunder:
        - playeffect effect:redstone special_data:1|<script.parsed_key[color.thunder]> at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        water:
        - playeffect effect:splash at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>
        wind:
        - playeffect effect:snowball at:<[particle_locations]> offset:0.05,0.05,0.05 visibility:50  velocity:<[velocity].if_null[<location[0,0,0]>]>

    symbol:
        earth: <reset><script[icons].parsed_key[elements.earth]><&[earth]><bold>
        ender: <reset><script[icons].parsed_key[elements.ender]><&[ender]><bold>
        fire: <reset><script[icons].parsed_key[elements.fire]><&[fire]><bold>
        ice: <reset><script[icons].parsed_key[elements.ice]><&[ice]><bold>
        light: <reset><script[icons].parsed_key[elements.light]><&[light]><bold>
        physical: <reset><script[icons].parsed_key[elements.physical]><&[physical]><bold>
        shadow: <reset><script[icons].parsed_key[elements.shadow]><&[shadow]><bold>
        thunder: <reset><script[icons].parsed_key[elements.thunder]><&[thunder]><bold>
        water: <reset><script[icons].parsed_key[elements.water]><&[water]><bold>
        wind: <reset><script[icons].parsed_key[elements.wind]><&[wind]><bold>
    slash_effects:
        earth:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        ender:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        fire:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        ice:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        - define fire_blocks <[particle_locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
        - define lava_blocks <[particle_locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
        - define water_blocks <[particle_locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter_tag[<[filter_value].block.material.name.equals[water].or[<[filter_value].material.waterlogged.if_null[false]>]>].deduplicate>
        - modifyblock <[fire_blocks]> air
        - playsound sound:block_fire_extinguish <[fire_blocks]>
        - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
        - showfake frosted_ice <[water_blocks]> d:3s players:<server.online_players>
        light:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        physical:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        shadow:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        thunder:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        water:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
        - define fire_blocks <[particle_locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
        - define lava_blocks <[particle_locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
        - modifyblock <[fire_blocks]> air
        - playsound sound:block_fire_extinguish <[fire_blocks]>
        - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
        wind:
        - define particle_locations <[locations]>
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - inject <script> path:particle.<[element]>
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
    - description
    - reach_distance
    - damage_earth
    - damage_ender
    - damage_fire
    - damage_ice
    - damage_light
    - damage_physical
    - damage_shadow
    - damage_thunder
    - damage_water
    - damage_wind
    - max_health
    - attack_speed
    - crit_chance
    - crit_damage
    - defense
    - defense_earth
    - defense_ender
    - defense_fire
    - defense_ice
    - defense_light
    - defense_physical
    - defense_shadow
    - defense_thunder
    - defense_water
    - defense_wind
    - abilities
    - gemstones
    stats:
        gemstones:
            lore format:
            - <empty>
            - <[value].parse[get[name]].separated_by[<n>]>

        reach_distance:
            default: 3
            lore format:
            - <&[base]>Reach distance: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_earth:
            default: 0
            lore format:
            - <&[base]>Earth damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ender:
            default: 0
            lore format:
            - <&[base]>Ender damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_fire:
            default: 0
            lore format:
            - <&[base]>Fire damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ice:
            default: 0
            lore format:
            - <&[base]>Ice damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_light:
            default: 0
            lore format:
            - <&[base]>Light damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_physical:
            default: 0
            lore format:
            - <&[base]>Physical damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_shadow:
            default: 0
            lore format:
            - <&[base]>Shadow damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_thunder:
            default: 0
            lore format:
            - <&[base]>Thunder damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_water:
            default: 0
            lore format:
            - <&[base]>Water damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_wind:
            default: 0
            lore format:
            - <&[base]>Wind damage: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        defense_earth:
            default: 0
            lore format:
            - <&[base]>Earth defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_ender:
            default: 0
            lore format:
            - <&[base]>Ender defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_fire:
            default: 0
            lore format:
            - <&[base]>Fire defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_ice:
            default: 0
            lore format:
            - <&[base]>Ice defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_light:
            default: 0
            lore format:
            - <&[base]>Light defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_physical:
            default: 0
            lore format:
            - <&[base]>Physical defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_shadow:
            default: 0
            lore format:
            - <&[base]>Shadow defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_thunder:
            default: 0
            lore format:
            - <&[base]>Thunder defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_water:
            default: 0
            lore format:
            - <&[base]>Water defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_wind:
            default: 0
            lore format:
            - <&[base]>Wind defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        max_health:
            default: 0
            lore format:
            - <&[base]>Max health: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
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
            - <&[base]>Attack Speed: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
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
            - <&[base]>Defense: <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            new item on generate: <[item].proc[tickcore_proc.script.items.add_attribute].context[<map[generic_armor=0;generic_armor_toughness=0]>]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>