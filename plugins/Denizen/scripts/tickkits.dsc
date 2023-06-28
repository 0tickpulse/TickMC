tickkits_data:
    type: data
    kits:
        starter:
            name: <&[emphasis]><&l>Starter kit
            display_item:
                material: stone_pickaxe
                hides:
                - ALL
            description:
            - <gray>A basic loadout of items to start
            - <gray>your journey.
            cooldown: 1h
            items:
            - [item=<proc[tickcore_proc.script.items.generate].context[vanilla_override_stone_sword]>;amount=1]
            - [item=stone_axe;amount=1]
            - [item=stone_shovel;amount=1]
            - [item=stone_hoe;amount=1]
            - [item=stone_pickaxe;amount=1]
            - [item=cooked_chicken;amount=10]
        copper:
            name: <&[emphasis]><&l>Copper kit
            display_item:
                material: copper_ingot
            description:
            - <gray>A set of copper tools and armor.
            cooldown: 0
            items:
            - [item=<proc[tickcore_proc.script.items.generate].context[copper_helmet]>]
            - [item=<proc[tickcore_proc.script.items.generate].context[copper_chestplate]>]
            - [item=<proc[tickcore_proc.script.items.generate].context[copper_leggings]>]
            - [item=<proc[tickcore_proc.script.items.generate].context[copper_boots]>]
    items:
        back_item:
            material: arrow
            display: <red>Back to kits
            custom_model_data: 5
        prev_page_item:
            material: arrow
            display: <red>Previous page
            custom_model_data: 3
        next_page_item:
            material: arrow
            display: <red>Next page
            custom_model_data: 4
        default_item:
            material: stone
            lore:
            - <[description]>
            - <dark_gray><&sp.repeat[46].strikethrough>
            - <[cooldown_lore]>
            - <[effects_lore]>
            - <&sp>
            - <&[emphasis]><&l>Items<&co>
            - <[kit_item_lore]>
            - <&sp>
            - <dark_gray><&sp.repeat[46].strikethrough>
            - <&[emphasis]>LMB <&7>to get this kit!
            - <&[emphasis]>RMB <&7>to view kit items.
    lore_format:
        kit_item_lore:
            text:
            -   <dark_gray>• <&[emphasis]><[amount]>x <gray><[name]>
            #- <aqua><[amount]>x <&[emphasis]><[name]>
            # Recommended to set, since errors will occur if lore gets too long
            limit: 10
            cutoff:   <dark_gray>• <gray>.. and more!
        cooldown_lore:
            text:
            #- <&sp>
            - <&[emphasis]><&l>Cooldown: <&[base]><[cooldown]>
        effects_lore:
            text:
            - <&sp>
            - <&[emphasis]><&l>Effects<&co>
            - <[effects]>

# Commands
tickkits_shortcut_command:
    type: command
    debug: false
    name: kit
    aliases:
    - kits
    description: Tick-kit player shortcut command.
    usage: /kit (kit)
    tab completions:
        1: <script[tickkits_data].data_key[kits].keys.if_null[<list>].filter_tag[<player.has_permission[tickkits.kit.<[filter_value]>.get]>]>
    script:
    - if <context.args.get[1].exists>:
        - if <script[tickkits_data].data_key[kits].keys.if_null[<list>]> contains <context.args.get[1]>:
            - run tickkits_give_kit_task def:<context.args.get[1]>|<player>|<player>
    - else:
        - run tickkits_browser_open_task def.page:1
tickkits_command:
    type: command
    debug: false
    name: tickkits
    description: The main tick-kits command. /help for usage.
    usage: /tickkits (give [player] [kit]/browse [player])
    tab completions:
        1: give|browse
        2: <context.args.get[1].is_in[give|browse].if_true[<server.online_players.parse[name]>].if_false[<empty>]>
        3: <context.args.get[1].is_in[give].if_true[<script[tickkits_data].data_key[kits].keys.if_null[<list>]>].if_false[<empty>]>
    script:
    - if <context.args.size> < 1:
        - narrate <red><script.data_key[usage]>
        - stop
    - choose <context.args.get[1]>:
        - case give:
            - if <context.args.size> < 3:
                - narrate <red><script.data_key[usage]>
                - stop
            - if <server.online_players.parse[name]> !contains <context.args.get[2]>:
                - narrate "<red>Invalid player given!"
                - stop
            - define player <server.match_player[<context.args.get[2]>]>
            - ~run tickkits_give_kit_task def:<context.args.get[3]>|<[player]>|<player> save:promise
            - if <entry[promise].created_queue.determination.exists>:
                - if <entry[promise].created_queue.determination.get[1].get[outcome].if_null[null]> == reject:
                    - narrate <entry[promise].created_queue.determination.get[1].get[error]>
        - case browse:
            - if <context.args.size> < 2:
                - narrate "<red>Invalid player given!"
                - stop
            - if <server.online_players.parse[name]> !contains <context.args.get[2]>:
                - narrate "<red>Invalid player given!"
                - stop
            - define player <server.match_player[<context.args.get[2]>]>
            - ~run tickkits_browser_open_task def.page:1 player:<[player]> save:promise
            - if <entry[promise].created_queue.determination.exists>:
                - if <entry[promise].created_queue.determination.get[1].get[outcome].if_null[null]> == reject:
                    - narrate <entry[promise].created_queue.determination.get[1].get[error]>
        - default:
            - narrate <red><script.data_key[usage]>

# Kit browser
tickkits_kit_browser_open_task:
    type: task
    debug: false
    definitions: kit|kit_map|page
    script:
    - define inventory <inventory[tickkits_kit_browser]>
    - flag player tickkits_browser.kit.<[kit]>.current_page:<[page]>
    - define page_start <[page].sub[1].mul[45]>
    - if <[page_start]> < 1:
        - define page_start 1
    - else:
        - define page_start:++
    - inventory set d:<[inventory]> o:<server.flag[tickkits_browser.kit.<[kit]>.items].sub_lists[45].get[<[page]>]>
    - if <[page]> > 1:
        - inventory set d:<[inventory]> o:<item[stone].with_map[<script[tickkits_data].parsed_key[items.prev_page_item]>].with_flag[item:prev_page_item]> slot:49
    - if <server.flag[tickkits_browser.kit.<[kit]>.items].size> > <[page].mul[45]>:
        - inventory set d:<[inventory]> o:<item[stone].with_map[<script[tickkits_data].parsed_key[items.next_page_item]>].with_flag[item:next_page_item]> slot:51
    - inventory set d:<[inventory]> o:<item[stone].with_map[<script[tickkits_data].parsed_key[items.back_item]>].with_flag[item:back_item]> slot:46
    - inventory open d:<[inventory]>
    - determine <map[outcome=resolve]>
tickkits_browser_open_task:
    type: task
    debug: false
    definitions: page
    script:
    - define inventory <inventory[tickkits_browser]>
    - flag player tickkits_browser.main.current_page:<[page]>
    - define page_start <[page].sub[1].mul[45]>
    - if <[page_start]> < 1:
        - define page_start 1
    - else:
        - define page_start:++
    - define unfiltered_items <server.flag[tickkits_browser.main.items]>
    - define filtered_items <list>
    - foreach <[unfiltered_items]> as:item:
        - if !<player.has_permission[tickkits.kit.<[item].flag[tickkit.kit]>.get]>:
            - foreach next
        - define filtered_items:->:<[item]>
    - if <[filtered_items].is_empty>:
        - determine passively <map[outcome=reject;error=NO_KITS]>
    - else:
        - inventory set d:<[inventory]> o:<[filtered_items].get[<[page_start]>].to[<[page].mul[45]>]>
    - if <[page]> > 1:
        - inventory set d:<[inventory]> o:<item[stone].with_map[<script[tickkits_data].parsed_key[items.prev_page_item]>].with_flag[item:prev_page_item]> slot:49
    - if <[filtered_items].size> > <[page].mul[45]>:
        - inventory set d:<[inventory]> o:<item[stone].with_map[<script[tickkits_data].parsed_key[items.next_page_item]>].with_flag[item:next_page_item]> slot:51
    - inventory open d:<[inventory]>
    - playsound <player> sound:ITEM_BOOK_PAGE_TURN
    - determine <map[outcome=resolve]>
tickkits_browser:
    type: inventory
    size: 54
    gui: true
    title: <&f>
    inventory: chest
tickkits_kit_browser:
    type: inventory
    size: 54
    gui: true
    title: <&f>
    inventory: chest
tickkits_browser_world:
    type: world
    debug: false
    events:
        on player clicks item in tickkits_browser:
        - if <context.item.flag[item].if_null[null]> == prev_page_item:
            - run tickkits_browser_open_task def.items:<player.flag[tickkits_browser.main.current_item_list]> def.page:<player.flag[tickkits_browser.main.current_page].sub[1]>
            - playsound <player> sound:ui_button_click
        - if <context.item.flag[item].if_null[null]> == next_page_item:
            - run tickkits_browser_open_task def.items:<player.flag[tickkits_browser.main.current_item_list]> def.page:<player.flag[tickkits_browser.main.current_page].add[1]>
            - playsound <player> sound:ui_button_click
        - if <context.item.flag[tickkit].exists>:
            - if <context.click> != RIGHT:
                - run tickkits_give_kit_task def:<context.item.flag[tickkit.kit]>|<player>|<player>
            - else:
                - run tickkits_kit_browser_open_task def:<context.item.flag[tickkit.kit]>|<context.item.flag[tickkit.kit_map]>|1
                - playsound <player> sound:ui_button_click
        on player clicks item in tickkits_kit_browser:
        #- if !<context.item.flag[item].exists>:
        #  - give <context.item>
        #  - stop
        - if <context.item.flag[item]> == back_item:
            - run tickkits_browser_open_task def.page:<player.flag[tickkits_browser.main.current_page].if_null[1]>
            - playsound <player> sound:ui_button_click
        - if <context.item.flag[item].if_null[null]> == prev_page_item:
            - run tickkits_kit_browser_open_task def.kit:<player.flag[tickkits_browser.current_kit]> def.kit_map:<script[tickkits_data].parsed_key[kits.<player.flag[tickkits_browser.current_kit]>]> def.page:<player.flag[tickkits_browser.kit.<player.flag[tickkits_browser.current_kit]>.current_page].sub[1]>
            - playsound <player> sound:ui_button_click
        - if <context.item.flag[item].if_null[null]> == next_page_item:
            - run tickkits_kit_browser_open_task def.kit:<player.flag[tickkits_browser.current_kit]> def.kit_map:<script[tickkits_data].parsed_key[kits.<player.flag[tickkits_browser.current_kit]>]> def.page:<player.flag[tickkits_browser.kit.<player.flag[tickkits_browser.current_kit]>.current_page].add[1]>
            - playsound <player> sound:ui_button_click



# Kit browser item generator
tickkits_browser_item_generator:
    type: procedure
    debug: false
    definitions: kit_id|kit_map
    script:
    - define kit_item_lore <list>

    # lore stuff
    # kit item lore
    - foreach <[kit_map.items].parse[as[map]]> as:item_map:
        - define kit_item <[item_map.item].as[item]>
        - define name <[kit_item].display.if_null[<[kit_item].material.translated_name>]>
        - define amount <[item_map.amount].if_null[1]>
        - define kit_item_lore:->:<script[tickkits_data].parsed_key[lore_format.kit_item_lore.text]>
        - define kit_item_lore <[kit_item_lore].combine>
        - if <[kit_item_lore].size> > <script[tickkits_data].parsed_key[lore_format.kit_item_lore.limit]>:
            - define kit_item_lore <[kit_item_lore].get[1].to[10].include[<script[tickkits_data].parsed_key[lore_format.kit_item_lore.cutoff]>]>

    # cooldown
    - define cooldown <[kit_map.cooldown].as[duration].if_null[<duration[0t]>]>
    - if <[cooldown]> == <duration[0t]>:
        - define cooldown 0s
        - define cooldown_lore <list>
    - else:
        - define cooldown <[cooldown].formatted>
        - define cooldown_lore <script[tickkits_data].parsed_key[lore_format.cooldown_lore.text]>

    # effects
    - define effects <[kit_map.effects.description].if_null[]>
    - if <[effects]> == <empty>:
        - define effects_lore <list>
    - else:
        - define effects_lore <script[tickkits_data].parsed_key[lore_format.effects_lore.text].combine>

    # kit description
    - define description <[kit_map.description].if_null[<list>]>

    - define item <item[stone].with_map[<script[tickkits_data].parsed_key[items.default_item]>].with[display=<[kit_map.name]>].with_map[<[kit_map.display_item]>].with_flag[tickkit:<map[kit=<[kit_id]>;kit_map=<[kit_map]>]>]>
    - define lore <script[tickkits_data].parsed_key[items.default_item.lore].combine>
    #- debug LOG <[lore].separated_by[<n>]>
    - adjust def:item lore:<[lore]>
    - determine <[item]>
# Kit giver and generator
tickkits_give_kit_task:
    type: task
    debug: false
    definitions: kit|player|sender
    script:
    - if <script[tickkits_data].data_key[kits]> !contains <[kit]>:
        - if <[sender].exists>:
            - narrate "<red>Invalid kit!" targets:<[sender]>
        - stop
    - if !<player.has_permission[tickkits.kit.<[kit]>.get]>:
        - narrate "<red>No permission!" targets:<[sender]>
        - stop
    - if <player.has_flag[tickkits_browser.kit.<[kit]>.cooldown]>:
        - if <[sender].exists>:
            - narrate "<red>On cooldown for <player.flag_expiration[tickkits_browser.kit.<[kit]>.cooldown].from_now.formatted>!" targets:<[sender]>
        - stop
    - give <[kit].proc[tickkits_generate_kit_proc]> player:<[player]>
    - if !<player.has_permission[tickkits.kit.<[kit]>.bypass_cooldown]>:
        - flag <player> tickkits_browser.kit.<[kit]>.cooldown expire:<script[tickkits_data].data_key[kits.<[kit]>.cooldown].as[duration].if_null[<duration[0t]>]>
    - playsound <player> sound:ITEM_ARMOR_EQUIP_CHAIN pitch:0.8
    - narrate "<gray>Gave you the kit <script[tickkits_data].parsed_key[kits.<[kit]>.name]><gray>!"

tickkits_generate_kit_proc:
    type: procedure
    debug: false
    definitions: kit
    script:
    - define kit_map <script[tickkits_data].data_key[kits.<[kit]>]>
    - define items <[kit_map.items].parse_tag[<[parse_value].as[map].get[item].parsed.as[item].with[quantity=<[parse_value].as[map].get[amount].if_null[1]>]>]>
    - determine <[items]>

tickkits_load_task:
    type: task
    debug: false
    script:
    - define items <list>
    - foreach <script[tickkits_data].parsed_key[kits]> key:kit_id as:kit_map:
        - define items:->:<[kit_id].proc[tickkits_browser_item_generator].context[<[kit_map]>]>
        - define kit_items.<[kit_id]> <[kit_map.items].parse_tag[<[parse_value].as[map].get[item].as[item].with[quantity=<[parse_value].as[map].get[amount].if_null[1]>]>]>
        - flag server tickkits_browser.kit.<[kit_id]>.items:<[kit_items.<[kit_id]>]>
    - flag server tickkits_browser.main.items:<[items]>

tickkits_load_world:
    type: world
    debug: false
    events:
        after server start:
        - run tickkits_load_task
        after reload scripts:
        - run tickkits_load_task
