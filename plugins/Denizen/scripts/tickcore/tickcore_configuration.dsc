
particle_generator:
    type: task
    debug: false
    definitions: element|locations|velocity|offset|quantity
    script:
        - define particle_datas <script[tickcore_effect_data].parsed_key[particle_data.<[element]>].values>
        - foreach <[particle_datas]> as:particle_data:
            - if <[particle_data.special_data].exists>:
                - playeffect effect:<[particle_data.effect]> at:<[locations]> quantity:<[quantity].if_null[1]> velocity:<[velocity].if_null[0,0,0]> offset:<[offset].if_null[<[particle_data.offset].if_null[0.5,0.5,0.5]>]> special_data:<[particle_data.special_data].if_null[]> data:<[particle_data.data].if_null[0]> visibility:<[particle_data.visibility].if_null[30]>
            - else:
                - playeffect effect:<[particle_data.effect]> at:<[locations]> quantity:<[quantity].if_null[1]> velocity:<[velocity].if_null[0,0,0]> offset:<[offset].if_null[<[particle_data.offset].if_null[0.5,0.5,0.5]>]> data:<[particle_data.data].if_null[0]> visibility:<[particle_data.visibility].if_null[30]>
tickcore_impl_data:
    type: data
    damage indicator blacklist:
    - item_frame
    - armor_stand
    - dropped_item

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
    particle_data:
        earth:
            1:
                effect: block_crack
                special_data: dirt
                visibility: 50
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.earth]>
                visibility: 50
        ender:
            1:
                effect: reverse_portal
                visibility: 50
        fire:
            1:
                effect: flame
                visibility: 50
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.fire]>
                visibility: 50
        ice:
            1:
                effect: block_crack
                special_data: ice
                visibility: 50
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.ice]>
                visibility: 50
        light:
            1:
                effect: end_rod
                visibility: 50
        physical:
            1:
                effect: crit
                visibility: 50
        shadow:
            1:
                effect: dust_color_transition
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.shadow]>|black
                visibility: 50
        thunder:
            1:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.thunder]>
                visibility: 50
        water:
            1:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.water]>
                visibility: 50
            2:
                effect: block_crack
                special_data: water
                visibility: 50
        wind:
            1:
                effect: snowball
                visibility: 50

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
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        ender:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        fire:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        ice:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        - define fire_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
        - define lava_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
        - define water_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter_tag[<[filter_value].block.material.name.equals[water].or[<[filter_value].material.waterlogged.if_null[false]>]>].deduplicate>
        - modifyblock <[fire_blocks]> air
        - playsound sound:block_fire_extinguish <[fire_blocks]>
        - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
        - showfake frosted_ice <[water_blocks]> d:3s players:<server.online_players>
        light:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        physical:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        shadow:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        thunder:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        water:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
        - define fire_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
        - define lava_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
        - playsound sound:block_fire_extinguish <[fire_blocks]>
        - modifyblock <[fire_blocks]> air
        - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
        wind:
        - define sound_locations <[entity].location>
        - inject <script> path:sound.<[element]>
        - run particle_generator def.element:<[element]> def.locations:<[locations]>
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
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 21
                    slot: any
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
    - gemstone_slots
    - implementations
    - description
    - <&sp.repeat[50].color[dark_gray].strikethrough>
    stats:
        implementations:
            item default: <list>
            entity default: <list>
            lore format:
            - <empty>
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>This item is a<&co>
            - <[value].parse_tag[<script[tickcore_data].parsed_key[stats.implementations.data.aliases.<[parse_value]>].if_null[<[parse_value]>]>].separated_by[<n>].proc[tickutil_text.script.lore_section_no_icon]>
            data:
                aliases:
                    gemstone_crystal: Crystal gem stone
            item stat calculation: <[map].values.combine>
            player stat calculation: null
        gemstones:
            item default: <list>
            entity default: <list>
            lore format:
            - <empty>
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Gemstones<&co>
            - <[value].parse[proc[tickutil_items.script.display]].parse_tag[   <dark_gray>» <&chr[20E3].custom_color[emphasis]> <[parse_value]>].separated_by[<n>]>
            item stat calculation: <[map].values.combine>
            player stat calculation: null
        gemstone_slots:
            item default: <list>
            entity default: <list>
            lore format:
            - <[stat_map].keys.contains[gemstones].if_true[].if_false[<n><script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Gemstones<&co><n>]><[item].proc[tickcore_gemstones_proc.script.get_remaining_gemstone_slots].if_null[<[value]>].parse_tag[   <dark_gray>» <&chr[20E3]> Empty <[parse_value]> gem slot].separated_by[<n>]>
            item stat calculation: <[map].values.combine>
            player stat calculation: null

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
            - <[value].parse[proc[tickutil_text.script.split_description]].separated_by[<n>]>
            item stat calculation: <[map].values>
            player stat calculation: null

        abilities:
            lore format:
            - <empty>
            - <[value].parse_tag[<script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[emphasis]><script[tickcore_ability_data].parsed_key[trigger_names.<[parse_value.trigger]>].if_null[<[parse_value.trigger].replace[_].with[ ].to_titlecase>]> <dark_gray>» <&[emphasis]><[parse_value.name]><[parse_value].keys.contains[cooldown].if_true[ <dark_gray>(<[parse_value.cooldown]>)].if_false[]><n><&[base]><[parse_value.description].parsed.proc[tickutil_text.script.split_description_no_icon]>].separated_by[<n.repeat[2]>]>
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