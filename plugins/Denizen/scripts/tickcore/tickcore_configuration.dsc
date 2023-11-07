# @ ----------------------------------------------------------
# TickCore Configuration
# The main configuration for TickCore.
# Author: 0TickPulse
# @ ----------------------------------------------------------

particle_generator:
    type: task
    debug: false
    definitions: element|locations|velocity|offset|quantity
    script:
        - define particle_datas <script[tickcore_effect_data].parsed_key[particle_data.<[element]>].values>
        - foreach <[particle_datas]> as:particle_data:
            - if <[particle_data.special_data].exists>:
                - playeffect effect:<[particle_data.effect]> at:<[locations]> quantity:<[quantity].if_null[1]> velocity:<[velocity].if_null[0,0,0]> offset:<[offset].if_null[<[particle_data.offset].if_null[0.5,0.5,0.5]>]> special_data:<[particle_data.special_data].if_null[]> data:<[particle_data.data].if_null[0]> visibility:<[particle_data.visibility].if_null[100]>
            - else:
                - playeffect effect:<[particle_data.effect]> at:<[locations]> quantity:<[quantity].if_null[1]> velocity:<[velocity].if_null[0,0,0]> offset:<[offset].if_null[<[particle_data.offset].if_null[0.5,0.5,0.5]>]> data:<[particle_data.data].if_null[0]> visibility:<[particle_data.visibility].if_null[100]>
tickcore_impl_data:
    type: data
    damage indicator blacklist:
    - item_frame
    - glow_item_frame
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
        custom_damage: Attack
        secondly: Every second
        death: Death
        walk: Walk
        break_block: Break block
        join: Join
        quit: Quit
        custom_arrow_hit: Arrow hit
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
        - playsound sound:block.grass.break at:<[sound_locations]> custom volume:2
        ender:
        - playsound sound:entity.enderman.hurt at:<[sound_locations]> custom volume:2
        fire:
        - playsound sound:entity.blaze.hurt at:<[sound_locations]> custom volume:2
        ice:
        - playsound sound:block.glass.break at:<[sound_locations]> custom volume:2
        light:
        - playsound sound:block.beacon.deactivate at:<[sound_locations]> custom volume:2
        physical:
        - playsound sound:entity.player.attack.sweep at:<[sound_locations]> custom volume:2
        shadow:
        - playsound sound:entity.wither.shoot at:<[sound_locations]> custom volume:2
        thunder:
        - playsound sound:block.beacon.deactivate at:<[sound_locations]> custom volume:2
        water:
        - playsound sound:entity.generic.splash at:<[sound_locations]> custom volume:2
        wind:
        - playsound sound:entity.arrow.shoot at:<[sound_locations]> custom volume:2
    particle_data:
        earth:
            1:
                effect: block_crack
                special_data: dirt
                visibility: 100
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.earth]>
                visibility: 100
        ender:
            1:
                effect: reverse_portal
                visibility: 100
        fire:
            1:
                effect: flame
                visibility: 100
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.fire]>
                visibility: 100
        ice:
            1:
                effect: block_crack
                special_data: ice
                visibility: 100
            2:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.ice]>
                visibility: 100
        light:
            1:
                effect: end_rod
                visibility: 100
        physical:
            1:
                effect: crit
                visibility: 100
        shadow:
            1:
                effect: dust_color_transition
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.shadow]>|black
                visibility: 100
        thunder:
            1:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.thunder]>
                visibility: 100
        water:
            1:
                effect: redstone
                special_data: 1|<script[tickcore_effect_data].parsed_key[color.water]>
                visibility: 100
            2:
                effect: block_crack
                special_data: water
                visibility: 100
        wind:
            1:
                effect: snowball
                visibility: 100

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
tickcore_specialized_sounds_task:
    type: task
    debug: false
    definitions: locations|element
    script:
    - choose <[element]>:
        - case earth:
            - playsound sound:block.grass.break at:<[locations]> custom
        - case ender:
            - playsound sound:entity.enderman.hurt at:<[locations]> custom
        - case fire:
            - playsound sound:entity.blaze.hurt at:<[locations]> custom
        - case ice:
            - playsound sound:block.glass.break at:<[locations]> custom
        - case light:
            - playsound sound:block.beacon.deactivate at:<[locations]> custom
        - case physical:
            - playsound sound:entity.player.attack.sweep at:<[locations]> custom
        - case shadow:
            - playsound sound:entity.wither.shoot at:<[locations]> custom
        - case thunder:
            - playsound sound:block.beacon.deactivate at:<[locations]> custom
        - case water:
            - playsound sound:entity.generic.splash at:<[locations]> custom
        - case wind:
            - playsound sound:entity.arrow.shoot at:<[locations]> custom
tickcore_specialized_effects_task:
    type: task
    debug: false
    definitions: entity|locations|element|sound|offset|sound_locations[optional - Defaults to entity.location]
    script:
    - if !<queue.definitions.contains[sound]>:
        - define sound true
    - if !<queue.definitions.contains[sound_locations]>:
        - define sound_locations <[entity].location>
    - choose <[element]>:
        - case earth:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:earth
            - run particle_generator def.element:earth def.locations:<[locations]> def.offset:0.1,0.1,0.1
        - case ender:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:ender
            - run particle_generator def.element:ender def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case fire:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:fire
            - run particle_generator def.element:fire def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case ice:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:ice
            - run particle_generator def.element:ice def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
            - define fire_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
            - define lava_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
            - define water_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter_tag[<[filter_value].block.material.name.equals[water].or[<[filter_value].material.waterlogged.if_null[false]>]>].deduplicate>
            - modifyblock <[fire_blocks]> air
            - playsound sound:block_fire_extinguish <[fire_blocks]>
            - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
            - showfake frosted_ice <[water_blocks]> d:3s players:<server.online_players>
        - case light:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:light
            - run particle_generator def.element:light def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case physical:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:physical
            - run particle_generator def.element:physical def.locations:<[locations]>  def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case shadow:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:shadow
            - run particle_generator def.element:shadow def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case thunder:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:thunder
            - run particle_generator def.element:thunder def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
        - case water:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:water
            - run particle_generator def.element:water def.locations:<[locations]>  def.offset:<[offset].if_null[0.5,0.5,0.5]>
            - define fire_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[fire]].deduplicate>
            - define lava_blocks <[locations].parse[points_between[<[entity].location>].distance[0.5]].combine.filter[block.material.name.equals[lava]].deduplicate>
            - playsound sound:block_fire_extinguish <[fire_blocks]>
            - modifyblock <[fire_blocks]> air
            - showfake obsidian <[lava_blocks]> d:3s players:<server.online_players>
        - case wind:
            - if <[sound]>:
                - run tickcore_specialized_sounds_task def.locations:<[sound_locations]> def.element:wind
            - run particle_generator def.element:wind def.locations:<[locations]> def.offset:<[offset].if_null[0.5,0.5,0.5]>
tickcore_data:
    type: data
    elements:
    - earth
    - ender
    - fire
    - ice
    - light
    - physical
    - shadow
    - thunder
    - water
    - wind
    item updating:
        container open: true
        item pickup: true
    player items to check for stats:
    - [name=HEAD;item=<player.inventory.slot[HEAD]>]
    - [name=CHEST;item=<player.inventory.slot[CHEST]>]
    - [name=LEGS;item=<player.inventory.slot[LEGS]>]
    - [name=FEET;item=<player.inventory.slot[FEET]>]
    - [name=HAND;item=<player.inventory.slot[HAND]>]
    - [name=OFFHAND;item=<player.inventory.slot[OFFHAND]>]

    - [name=ACCESSORY_BAG_ARTIFACT_1;item=<inventory[tickcore_accessory_bag_<player.uuid>].slot[11].if_null[<item[air]>]>]
    - [name=ACCESSORY_BAG_ARTIFACT_2;item=<inventory[tickcore_accessory_bag_<player.uuid>].slot[20].if_null[<item[air]>]>]
    - [name=ACCESSORY_BAG_ARTIFACT_3;item=<inventory[tickcore_accessory_bag_<player.uuid>].slot[29].if_null[<item[air]>]>]
    default nonstackable properties:
        attribute_modifiers:
            generic_attack_speed:
                1:
                    operation: ADD_NUMBER
                    amount: 21
                    slot: any
    default properties:
        hides: ALL
    lore order:
    - <&sp.repeat[50].color[dark_gray].strikethrough>
    - implementations
    - damage_earth
    - additional_damage_earth
    - damage_ender
    - additional_damage_ender
    - damage_fire
    - additional_damage_fire
    - damage_ice
    - additional_damage_ice
    - damage_light
    - additional_damage_light
    - damage_physical
    - additional_damage_physical
    - damage_shadow
    - additional_damage_shadow
    - damage_thunder
    - additional_damage_thunder
    - damage_water
    - additional_damage_water
    - damage_wind
    - additional_damage_wind
    - reach_distance
    - attack_speed
    - crit_chance
    - crit_damage
    - arrow_speed
    - arrow_range
    - max_health
    - max_energy
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
    - knockback_resistance
    - restores_health
    - restores_energy
    - restores_food
    - restores_saturation
    - effect_modifiers
    - abilities
    - gemstones
    - gemstone_slots
    - description
    - <&sp.repeat[50].color[dark_gray].strikethrough>
    implementation slots:
        weapon_melee:
        - hand
        weapon_bow:
        - hand
        armor:
        - head
        - chest
        - legs
        - feet
        armor_helmet:
        - head
        armor_chestplate:
        - chest
        armor_leggings:
        - legs
        armor_boots:
        - feet
        consumable:
        - hand
    stats:
        implementations:
            item default: <list>
            entity default: <list>
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]><[value].parse_tag[<script[tickcore_data].parsed_key[stats.implementations.data.aliases.<[parse_value]>].if_null[<[parse_value]>]>].comma_separated>
            - <empty>
            data:
                aliases:
                    gemstone_crystal: Crystal gem stone
                    weapon_melee: Melee weapon
                    weapon_bow: Bow
                    armor: Armor
                    armor_helmet: Helmet
                    armor_chestplate: Chestplate
                    armor_leggings: Leggings
                    armor_boots: Boots
                    consumable: Consumable
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
            - <empty>
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Gemstones<&co>
            - <[stat_map.gemstones].if_null[<list>].parse[proc[tickutil_items.script.display]].parse_tag[   <dark_gray>» <&chr[20E3].custom_color[emphasis]> <[parse_value]>].separated_by[<n>]><[item].proc[tickcore_gemstones_proc.script.get_remaining_gemstone_slots].if_null[<[value]>].parse_tag[   <dark_gray>» <&chr[20E3]> Empty <[parse_value]> gem slot].separated_by[<n>]>
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
        additional_damage_earth:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.earth]> <dark_gray>» <&[earth]>Earth damage <dark_gray>- <&[earth]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ender:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ender]> <dark_gray>» <&[ender]>Ender damage <dark_gray>- <&[ender]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_ender:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ender]> <dark_gray>» <&[ender]>Ender damage <dark_gray>- <&[ender]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_fire:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.fire]> <dark_gray>» <&[fire]>Fire damage <dark_gray>- <&[fire]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_fire:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.fire]> <dark_gray>» <&[fire]>Fire damage <dark_gray>- <&[fire]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_ice:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ice]> <dark_gray>» <&[ice]>Ice damage <dark_gray>- <&[ice]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_ice:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.ice]> <dark_gray>» <&[ice]>Ice damage <dark_gray>- <&[ice]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_light:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.light]> <dark_gray>» <&[light]>Light damage <dark_gray>- <&[light]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_light:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.light]> <dark_gray>» <&[light]>Light damage <dark_gray>- <&[light]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_physical:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.physical]> <dark_gray>» <&[physical]>Physical damage <dark_gray>- <&[physical]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_physical:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.physical]> <dark_gray>» <&[physical]>Physical damage <dark_gray>- <&[physical]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_shadow:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.shadow]> <dark_gray>» <&[shadow]>Shadow damage <dark_gray>- <&[shadow]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_shadow:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.shadow]> <dark_gray>» <&[shadow]>Shadow damage <dark_gray>- <&[shadow]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_thunder:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.thunder]> <dark_gray>» <&[thunder]>Thunder damage <dark_gray>- <&[thunder]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_thunder:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.thunder]> <dark_gray>» <&[thunder]>Thunder damage <dark_gray>- <&[thunder]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_water:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.water]> <dark_gray>» <&[water]>Water damage <dark_gray>- <&[water]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_water:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.water]> <dark_gray>» <&[water]>Water damage <dark_gray>- <&[water]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        damage_wind:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.wind]> <dark_gray>» <&[wind]>Wind damage <dark_gray>- <&[wind]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>
        additional_damage_wind:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[elements.wind]> <dark_gray>» <&[wind]>Wind damage <dark_gray>- <&[wind]><[value].mul[100].proc[tickcore_proc.script.util.sign_prefix]>%
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

        arrow_speed:
            item default: 0
            entity default: 100
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Arrow speed <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        arrow_range:
            item default: 0
            entity default: 500
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Arrow range <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        knockback_resistance:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Knockback resistance <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>%
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

    # - restores_health
    # - restores_energy
    # - restores_food
    # - restores_saturation
    # - effect_modifiers
        restores_health:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Restores <&[emphasis]><[value]> ❤
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        restores_energy:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Restores <&[emphasis]><[value]> ⚡
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        restores_food:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Restores <&[emphasis]><[value]> food
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        restores_saturation:
            item default: 0
            entity default: 0
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Restores <&[emphasis]><[value]> saturation
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        effect_modifiers:
            item default: <list>
            entity default: <list>
            lore format:
            - <empty>
            - <script[icons].parsed_key[red_icons.potion]> <dark_gray>» <&[emphasis]><bold>Effects
            - <[value].parse_tag[   <dark_gray>» <&translate[effect.minecraft.<[parse_value].split[ ].get[1]>].custom_color[emphasis]> <[parse_value].split[ ].get[3].if_null[1].to_roman_numerals.custom_color[emphasis]> for <[parse_value].split[ ].get[2].as[duration].formatted.custom_color[emphasis]>].separated_by[<n>]>
            item stat calculation: <[map].values.combine>
            player stat calculation: <[map].values.combine>

        max_health:
            item default: 0
            entity default: 20
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Max health <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
            item stat calculation: <[map].values.sum>
            player stat calculation: <[map].values.sum>

        max_energy:
            item default: 0
            entity default: 20
            lore format:
            - <script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]>Max energy <dark_gray>- <&[emphasis]><[value].proc[tickcore_proc.script.util.sign_prefix]>
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
            - <[value].parse_tag[<script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[emphasis]><script[tickcore_ability_data].parsed_key[trigger_names.<[parse_value.trigger]>].if_null[<[parse_value.trigger].replace[_].with[ ].to_titlecase>]> <dark_gray>» <&[emphasis]><[parse_value.name]><[parse_value].keys.contains_any[cooldown|energy].if_true[ <dark_gray>(<[parse_value.cooldown].exists.if_true[<[parse_value.cooldown]>].if_false[]><[parse_value.energy].exists.if_true[ <[parse_value.energy]><script[icons].parsed_key[energy]>].if_false[]>)].if_false[]><n><&[base]><[parse_value.description].parsed.proc[tickutil_text.script.split_description_no_icon].context[<&[base]>]>].separated_by[<n.repeat[2]>]>
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
