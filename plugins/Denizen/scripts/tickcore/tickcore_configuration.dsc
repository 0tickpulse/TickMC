
tickcore_ability_data:
    type: data
    trigger_names:
        sneak_left_click: Shift+LMB
        sneak_right_click: Shift+RMB
        left_click: LMB
        right_click: RMB
        sneak: Shift
        attack: Attack
        secondly: Every second
        death: Death
        walk: Walk
        break_block: Break block
        join: Join
        quit: Quit
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
    - <&sp.repeat[50].color[dark_gray].strikethrough>
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
    - reach_distance
    - attack_speed
    - crit_chance
    - crit_damage
    - max_health
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
    - description
    - <&sp.repeat[50].color[dark_gray].strikethrough>
    stats:
        gemstones:
            lore format:
            - <empty>
            - <[value].parse[get[name]].separated_by[<n>]>

        reach_distance:
            item default: 0
            entity default: 3
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Reach distance <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_earth:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.earth]> <dark_gray>» <&[earth]>Earth damage <dark_gray>- <&[earth]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ender:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ender]> <dark_gray>» <&[ender]>Ender damage <dark_gray>- <&[ender]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_fire:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.fire]> <dark_gray>» <&[fire]>Fire damage <dark_gray>- <&[fire]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ice:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ice]> <dark_gray>» <&[ice]>Ice damage <dark_gray>- <&[ice]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_light:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.light]> <dark_gray>» <&[light]>Light damage <dark_gray>- <&[light]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_physical:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.physical]> <dark_gray>» <&[physical]>Physical damage <dark_gray>- <&[physical]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_shadow:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.shadow]> <dark_gray>» <&[shadow]>Shadow damage <dark_gray>- <&[shadow]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_thunder:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.thunder]> <dark_gray>» <&[thunder]>Thunder damage <dark_gray>- <&[thunder]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_water:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.water]> <dark_gray>» <&[water]>Water damage <dark_gray>- <&[water]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_wind:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.wind]> <dark_gray>» <&[wind]>Wind damage <dark_gray>- <&[wind]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        defense_earth:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.earth]> <dark_gray>» <&[earth]>Earth defense <dark_gray>- <&[earth]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_ender:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ender]> <dark_gray>» <&[ender]>Ender defense <dark_gray>- <&[ender]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_fire:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.fire]> <dark_gray>» <&[fire]>Fire defense <dark_gray>- <&[fire]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_ice:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ice]> <dark_gray>» <&[ice]>Ice defense <dark_gray>- <&[ice]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_light:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.light]> <dark_gray>» <&[light]>Light defense <dark_gray>- <&[light]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_physical:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.physical]> <dark_gray>» <&[physical]>Physical defense <dark_gray>- <&[physical]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_shadow:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.shadow]> <dark_gray>» <&[shadow]>Shadow defense <dark_gray>- <&[shadow]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_thunder:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.thunder]> <dark_gray>» <&[thunder]>Thunder defense <dark_gray>- <&[thunder]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_water:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.water]> <dark_gray>» <&[water]>Water defense <dark_gray>- <&[water]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        defense_wind:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.wind]> <dark_gray>» <&[wind]>Wind defense <dark_gray>- <&[wind]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        max_health:
            item default: 0
            entity default: 20
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Max health <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        description:
            lore format:
            - <empty>
            - <[value].parse[proc[tickutil_text.script.lore_section]].separated_by[<n>]>
            item stat calculation: <[map].values>
            player stat calculation: null

        abilities:
            lore format:
            - <empty>
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <[value].parse_tag[<&[emphasis]><script[tickcore_ability_data].parsed_key[trigger_names.<[parse_value.trigger]>].if_null[<[parse_value.trigger].replace[_].with[ ].to_titlecase>]> <dark_gray>» <&[emphasis]><[parse_value.name]><[parse_value].keys.contains[cooldown].if_true[ <dark_gray>(<[parse_value.cooldown]>)].if_false[]><n><&[base]><[parse_value.description].parsed.proc[tickutil_text.script.lore_section_no_icon]>].separated_by[<n.repeat[2]>]>
            item stat calculation: <[map].values.combine.parse[values].combine>
            player stat calculation: <[map].values.combine>

        attack_speed:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Attack Speed <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        crit_chance:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Crit Chance <dark_gray>- <&[emphasis]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        crit_damage:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Crit Damage <dark_gray>- <&[emphasis]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        defense:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Defense <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            new item on generate: <[item].proc[tickcore_proc.script.items.add_attribute].context[<map[generic_armor=0;generic_armor_toughness=0]>]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>