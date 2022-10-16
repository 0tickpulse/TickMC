tickcore_task:
    type: task
    debug: false
    script:
        entities:
            spawnmob:
            - define id <[1]>
            - define level <[2].if_null[0]>
            - customevent id:tickcore_entity_prespawns context:[id=<[id]>] save:prespawn_event
            - if <entry[prespawn_event].was_cancelled>:
                - stop
            - spawn <[id].proc[tickcore_proc.script.entities.generate]> save:entity
            - define entity <entry[entity].spawned_entity>
            - customevent id:tickcore_entity_spawns context:[id=<[id]>;entity=<[entity]>] save:spawn_event
            - define entity <entry[spawn_event].determination_list.get[1].if_null[<[entity]>]>
            - define stats <script[<[id]>].parsed_key[data.tickcore].parse_value_tag[<map[base=<[parse_value]>]>]>
            # Add level modifiers
            - foreach <script[<[id]>].parsed_key[data.tickcore_level_modifiers]> key:modifier_stat as:modifier_stat_value:
                - define stats.<[modifier_stat]>.LEVEL <[modifier_stat_value].mul[<[level]>]>
            - flag <[entity]> tickcore.id:<[id]>
            - flag <[entity]> tickcore.stats:<[stats]>
tickcore_proc:
    type: procedure
    debug: false
    script:
        core:
            get_all_stat_ids:
            - determine <script[tickcore_data].list_keys[stats]>
        items:
            get_all_scripts:
            - determine <util.scripts.filter[container_type.equals[ITEM]].filter[data_key[data.tickcore].exists]>
            get_all_ids:
            - determine <proc[tickcore_proc.script.items.get_all_scripts].parse[name]>
            # definitions: original_item|attribute_map
            add_attribute:
            - define attribute_map <[2].parse_value_tag[<list[<map[operation=ADD_NUMBER;amount=<[parse_value]>]>]>]>
            - determine <[1].with_single[attribute_modifiers=<[1].attribute_modifiers.include[<[attribute_map]>]>]>
            # definitions: item|stat
            get_stat:
            - if !<[2].exists>:
                - debug error Bad!
            - if !<[1].proc[tickcore_proc.script.items.is_tickitem]>:
                - stop
            - define map <[1].flag[tickcore.stats.<[2]>].if_null[null]>
            - if <[map]> == null:
                - determine null
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.item stat calculation]>
            # definitions: item
            get_stat_map:
            - if !<[1].proc[tickcore_proc.script.items.is_tickitem]>:
                - stop
            - determine <[1].flag[tickcore.stats]>
            # definitions: item
            is_tickitem:
            - determine <[1].has_flag[tickcore.stats]>
            generate:
            - define id <[1]>
            - define default_item_properties "<script[tickcore_data].parsed_key[default item properties].if_null[<map>]>"
            - define item_data <script[<[id]>].data_key[data].if_null[null]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>

            - if <[item_data]> == null || <[stat_global_map]> == null:
                - stop

            - define item <[id].as[item].with_map[<[default_item_properties]>]>

            # Stat manager
            - define stat_map <[item_data.tickcore].parse_value_tag[<map[base=<[parse_value]>]>]>
            - define item <[item].proc[tickcore_proc.script.items.override_stats].context[<[stat_map]>]>

            # Flag the item
            - define item <[item].with_flag[tickcore.id:<[id]>]>

            # Return the item
            - determine <[item]>
            # definitions: item|stat_map
            override_stats:
            - define item <[1]>
            - define stat_map <[2]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>
            - define lore <list>
            - define stats_to_add "<script[tickcore_data].data_key[lore order]>"
            - foreach <[stats_to_add]> as:stat_id:
                - if <[stat_map].keys> !contains <[stat_id]>:
                    - foreach next
                - define map <[stat_map.<[stat_id]>].parse_value_tag[<[parse_value].parsed>]>
                - define value <[stat_global_map.<[stat_id]>.item stat calculation].parsed>
                - if <[stat_global_map.<[stat_id]>].keys> contains "new item on generate":
                    - define item "<[stat_global_map.<[stat_id]>.new item on generate].parsed>"

                - foreach "<[stat_global_map.<[stat_id]>.lore format]>" as:line:
                    - define lore:->:<[line].parsed.parsed>
                - define value:!
            # Flag the item
            - define item <[item].with_flag[tickcore.stats:<[stat_map]>]>
            # Add the generated lore to the item
            - define item <[item].with[lore=<[lore]>]>
            - determine <[item]>
        entities:
            is_tickentity:
            - determine <[1].has_flag[tickcore.stats]>
            get_stat:
            - if <[1].is_player>:
                - determine <[1].proc[tickcore_proc.script.players.get_stat].context[<[2]>]>
            - define map <[1].proc[tickcore_proc.script.entities.get_stat_map].get[<[2]>].if_null[<map[DEFAULT=<script[tickcore_data].parsed_key[stats.<[2]>.default].if_null[null]>]>]>
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.player stat calculation]>
            get_stat_map:
            - define entity <[1]>
            - define map <map>
            - foreach <[entity].equipment_map.include[hand=<[entity].item_in_hand>;offhand=<[entity].item_in_offhand>].if_null[<map>]> key:slot as:item:
                - if <[item].material.name> == AIR || !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                    - foreach next
                - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat:
                    - if <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]> != null:
                        - define map.<[stat]>.ITEM_<[slot]> <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]>
            - determine <[entity].flag[tickcore.stats].if_null[<map>].include[<[map]>]>
            get_all_scripts:
            - determine <util.scripts.filter[container_type.equals[ENTITY]].filter[data_key[data.tickcore].exists]>
            get_all_ids:
            - determine <proc[tickcore_proc.script.entities.get_all_scripts].parse[name]>
            generate:
            - define id <[1]>
            - define entity_data <script[<[id]>].data_key[data].if_null[null]>
            - define stat_global_map <script[tickcore_data].data_key[stats].if_null[null]>

            - if <[entity_data]> == null || <[stat_global_map]> == null:
                - stop

            - define entity <[id].as[entity]>

            # Return the entity
            - determine <[entity]>
        players:
            get_stat_map:
            - define player <[1]>
            - define map <map>
            - foreach <script[tickcore_data].data_key[slots to check for stats].if_null[<list>]> as:slot:
                - define item <[player].inventory.slot[<[slot]>]>
                - if <[item].material.name> == AIR || !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                    - foreach next
                - foreach <proc[tickcore_proc.script.core.get_all_stat_ids]> as:stat:
                    - if <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]> != null:
                        - define map.<[stat]>.ITEM_<[slot]> <[item].proc[tickcore_proc.script.items.get_stat].context[<[stat]>]>
            - determine <[map]>
            # definitions: player|stat
            get_stat:
            - define map <[1].proc[tickcore_proc.script.players.get_stat_map].get[<[2]>].if_null[<map[DEFAULT=<script[tickcore_data].parsed_key[stats.<[2]>.default].if_null[null]>]>]>
            - if <[map]> == null:
                - determine null
            - determine <script[tickcore_data].parsed_key[stats.<[2]>.player stat calculation]>
# Utility procedure scripts
# Item updater
tickcore_update_item:
    type: procedure
    debug: false
    definitions: item
    script:
    - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
        - determine <[item]>
    - determine <[item].script.name.proc[tickcore_proc.script.items.generate]>
tickcore_update_items_task:
    type: task
    debug: false
    definitions: inventory
    script:
    - define contents <[inventory].list_contents>
    - foreach <[contents]> as:item:
        - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
            - foreach next
        - define contents <[contents].overwrite[<[item].proc[tickcore_update_item]>].at[<[loop_index]>]>
    - adjust <[inventory]> contents:<[contents]>
    - determine <[inventory]>
tickcore_update_items_world:
    type: world
    debug: false
    events:
        on player opens inventory:
        - stop "if:<script[tickcore_data].data_key[item updating.container open].if_null[true].not>"
        - if <context.inventory.id_holder.object_type> == location:
            - run tickcore_update_items_task def:<context.inventory>
        on player picks up item:
        - stop "if:<script[tickcore_data].data_key[item updating.item pickup].if_null[true].not>"
        - determine ITEM:<context.item.proc[tickcore_update_item]>

tickcore_main_command:
    type: command
    debug: false
    name: tickcore
    aliases:
    - ti
    description: tickcore main command.
    usage: /tickcore [getitem [item]/getstat [stat] (player)/giveitem [player] [item]/statmap (player)/modifyitemstat [stat] [value]]
    data:
        tab_complete:
            2:
                getitem: <proc[tickcore_proc.script.items.get_all_ids]>
                giveitem: <server.online_players.parse[name]>
                getstat: <proc[tickcore_proc.script.core.get_all_stat_ids]>
                statmap: <server.online_players.parse[name]>
                modifyitemstat: <proc[tickcore_proc.script.core.get_all_stat_ids]>
                spawnmob: <proc[tickcore_proc.script.entities.get_all_ids]>
    tab completions:
        1: getitem|giveitem|getstat|statmap|updateitems|modifyitemstat|spawnmob
        2: <script.parsed_key[data.tab_complete.2.<context.args.get[1]>].if_null[]>
        3: <context.args.get[1].is_in[giveitem|getstat].if_true[<proc[tickcore_proc.script.items.get_all_ids]>].if_false[]>
    script:
    - if <context.args.size> < 1:
        - narrate <&[error]><script.data_key[usage]>
        - stop
    - choose <context.args.get[1]>:

        - case getitem:
            - if <context.args.size> < 2:
                - narrate <&[error]><script.data_key[usage]>
                - stop
            - define id <context.args.get[2]>
            - if <proc[tickcore_proc.script.items.get_all_ids]> !contains <[id]>:
                - narrate "<&[error]>Invalid item ID!"
                - stop
            - give <[id].proc[tickcore_proc.script.items.generate]>

        - case giveitem:
            - if <context.args.size> < 3:
                - narrate <&[error]><script.data_key[usage]>
                - stop
            - define player <server.match_player[<context.args.get[2]>].if_null[null]>
            - if <[player]> == null:
                - narrate "<&[error]>Invalid player name!"
                - stop
            - adjust <queue> linked_player:<[player]>
            - define id <context.args.get[3]>
            - if <proc[tickcore_proc.script.items.get_all_ids]> !contains <[id]>:
                - narrate "<&[error]>Invalid item ID!"
                - stop
            - give <[id].proc[tickcore_proc.script.items.generate]>

        - case getstat:
            - if <context.args.size> < 2:
                - narrate <&[error]><script.data_key[usage]>
                - stop
            - define stat <context.args.get[2]>
            - if <context.args.size> >= 3 || !<player.exists>:
                - if <proc[tickcore_proc.script.core.get_all_stat_ids]> !contains <[stat]>:
                    - narrate "<&[error]>Invalid stat ID!"
                    - stop
                - define player <server.match_player[<context.args.get[3]>].if_null[null]>
                - if <[player]> == null:
                    - narrate "<&[error]>Invalid player name!"
                    - stop
                - adjust <queue> linked_player:<[player]>
            - narrate <player.proc[tickcore_proc.script.players.get_stat].context[<[stat]>]>

        - case statmap:
            - if <context.args.size> > 1 || !<player.exists>:
                - define player <server.match_player[<context.args.get[2]>].if_null[null]>
                - if <[player]> == null:
                    - narrate "<&[error]>Invalid player name!"
                    - stop
                - adjust <queue> linked_player:<[player]>
            - narrate <player.proc[tickcore_proc.script.players.get_stat_map].to_yaml>

        - case updateitems:
            - foreach <server.players.parse[inventory]> as:inventory:
                - run tickcore_update_items_task def:<[inventory]>
            - narrate "<&[success]>Updated items!"

        - case modifyitemstat:
            - if !<player.exists>:
                    - narrate "<&[error]>Only a player can run this."
                    - stop
            - define item <player.item_in_hand>
            - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
                - narrate "<&[error]>This is not a TickCore item."
                - stop
            - if <context.args.size> < 3:
                - narrate <&[error]><script.data_key[usage]>
            - define stat_id <context.args.get[2]>
            - if <proc[tickcore_proc.script.core.get_all_stat_ids]> !contains <[stat_id]>:
                - narrate "<&[error]>Invalid stat ID!"
                - stop
            - define stat_value <context.args.get[3]>

            - define original_flag_map <[item].proc[tickcore_proc.script.items.get_stat_map]>
            - define original_flag_map.<[stat_id]>.MODIFYITEMSTAT_COMMAND <[stat_value]>
            - define item <[item].proc[tickcore_proc.script.items.override_stats].context[<[original_flag_map]>]>
            - inventory set slot:hand o:<[item]>

        - case spawnmob:
            - define location <context.args.get[3].to[last].separated_by[,].as[location].if_null[null]>
            - if <[location]> == null:
                - if <player.exists>:
                    - define location <player.location>
                - else:
                    - narrate "<&[error]>Please specify a location."
                    - stop
            - define id <context.args.get[2]>
            - if <proc[tickcore_proc.script.entities.get_all_ids]> !contains <[id]>:
                - narrate "<&[error]>Invalid entity ID!"
                - stop

            - define level <context.args.get[3].if_null[1]>

            - run tickcore_task path:script.entities.spawnmob def:<[id]>|<[level]>

        - default:
            - narrate <&[error]><script.data_key[usage]>
            - stop