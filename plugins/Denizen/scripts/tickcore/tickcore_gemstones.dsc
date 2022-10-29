
tickcore_gemstones_proc:
    type: procedure
    debug: false
    script:
        get_remaining_gemstone_slots:
        - define item <[1]>
        - if !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
            - determine <list>
        - define gemstones <[item].proc[tickcore_proc.script.items.get_stat_map].get[gemstones].if_null[<map>]>
        - define gemstone_slots <[item].proc[tickcore_proc.script.items.get_stat].context[gemstone_slots]>
        - foreach <[gemstones]> key:type:
            - define gemstone_slots:<-:<[type].replace_text[regex:gemstone_(.*)_\d+].with[$1]>
        - determine <[gemstone_slots]>
        get_gemstones_with_type:
        - define item <[1]>
        - define type <[2]>
        - define i 0
        - define gemstones <[item].proc[tickcore_proc.script.items.get_stat_map].get[gemstones].if_null[<map>]>
        - foreach <[gemstones].keys> as:key:
            - if <[key].starts_with[gemstone_<[type]>_]>:
                - define i:++
        - determine <[i]>
        # Gets what type to apply, or null if can't apply
        get_apply_type:
        - define item <[1]>
        - define gemstone <[2]>
        - if !<[gemstone].proc[tickcore_proc.script.items.is_tickitem]> || !<[item].proc[tickcore_proc.script.items.is_tickitem]>:
            - stop
        - define gemstone_slots <[item].proc[tickcore_proc.script.items.get_stat].context[gemstone_slots]>
        - if <[gemstone_slots]> == null:
            - stop
        - foreach <[gemstone].proc[tickcore_proc.script.items.get_stat].context[implementations]> as:id:
            - if <[gemstone_slots].parse_tag[gemstone_<[parse_value]>]> contains <[id]>:
                - define gemstone_type <[id].after[gemstone_]>
        - if <[item].proc[tickcore_gemstones_proc.script.get_remaining_gemstone_slots].find[<[gemstone_type]>]> == -1:
            - stop
        - determine <[gemstone_type]>
        # @ Warning: This does not check if the item can be applied. This only applies the gemstone's stats.
        apply_gemstone:
        - define item <[1]>
        - define gemstone <[2]>
        - define gemstone_type <[3]>

        - define gemstone_id <[1].proc[tickcore_proc.script.items.get_stat].context[gemstones].size.add[1].if_null[1]>

        - define add_stats <[2].proc[tickcore_proc.script.items.get_stat_map_simple].exclude[implementations].parse_value_tag[<map[gemstone_<[gemstone_type]>_<[gemstone_id]>=<[parse_value]>]>]>
        - define add_stats.gemstones.gemstone_<[gemstone_type]>_<[gemstone_id]>:->:<[gemstone]>
        - determine <[item].proc[tickcore_proc.script.items.add_stats].context[<[add_stats]>]>
        can_apply_gemstone:
        - define item <[1]>
        - define gemstone <[2]>
        - define gemstone_type <[item].proc[tickcore_gemstones_proc.script.get_apply_type].context[<[gemstone]>].if_null[null]>
        - if <[gemstone_type]> == null:
            - determine false
        - determine true
        remove_all_gemstones:
        - define item <[1]>
        - define stat_map <[1].proc[tickcore_proc.script.items.get_stat_map]>
        - define new_map <map>
        - foreach <[stat_map]> key:stat as:map:
            - if <[stat]> == gemstones:
                - foreach next
            - foreach <[map]> key:modifier as:value:
                - if <[modifier].starts_with[gemstone_]>:
                    - foreach next
                - define new_map.<[stat]>.<[modifier]> <[value]>
        - determine <[item].proc[tickcore_proc.script.items.override_stats].context[<[new_map]>]>

tickcore_gemstones_world:
    type: world
    debug: false
    events:
        on player prepares smithing item:
        - define item <context.inventory.slot[1]>
        - define gemstone <context.inventory.slot[2]>

        - define gemstone_type <[item].proc[tickcore_gemstones_proc.script.get_apply_type].context[<[gemstone]>].if_null[null]>
        - if <[gemstone_type]> == null:
            - stop

        - define new_item <[item].proc[tickcore_gemstones_proc.script.apply_gemstone].context[<[gemstone]>|<[gemstone_type]>]>
        - determine <[new_item]>
        - take cursoritem
        - inventory set d:<context.clicked_inventory> o:<[new_item]> slot:<context.slot>

tickcore_gemstones_inventory:
    type: inventory
    inventory: chest
    gui: true
    debug: false
    slots:
    - [] [] [] [container_fill] [container_fill] [container_fill] [] [] []
    - [] [] [] [container_fill] [container_fill] [container_fill] [] [] []
    - [] [] [] [container_fill] [container_fill] [container_fill] [] [] []
    - [] [] [] [container_fill] [container_fill] [container_fill] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    title: <script[icons].parsed_key[spaces.8]><script[icons].parsed_key[guis.resonance_station]>
    size: 54
    definitions:
        container_fill: tickutil_inventories_container_fill_item
    data:
        slots:
        - 4
        - 5
        - 6
        - 13
        - 14
        - 15
        - 22
        - 23
        - 24
        - 31
        - 32
        - 33
tickcore_gemstones_inventory_generate_items:
    type: task
    debug: false
    definitions: inventory
    script:
    - define input <[inventory].slot[11]>

    - define gemstone_slots <[input].proc[tickcore_gemstones_proc.script.get_remaining_gemstone_slots].size.if_null[0]>
    - define empty_slot_index <util.list_numbers_to[<[gemstone_slots]>]>
    - define gemstone_slots <[inventory].script.data_key[data.slots]>
    - if !<[empty_slot_index].is_empty>:
        - define slots <[gemstone_slots].get[<[empty_slot_index]>]>
        - foreach <[slots]> as:slot:
            - if <[inventory].slot[<[slot]>]> matches tickutil_inventories_container_fill_item:
                - inventory set slot:<[slot]> o:air d:<[inventory]>
    - foreach <[gemstone_slots].exclude[<[slots].if_null[<list>]>]> as:slot:
        - inventory set slot:<[slot]> o:tickutil_inventories_container_fill_item d:<[inventory]>

    - if !<[slots].exists>:
        - stop
    - define gemstone_items <[gemstone_slots].get[<[slots]>].as[list].parse_tag[<[inventory].slot[<[parse_value]>]>]>
    - define output <[input]>
    - foreach <[gemstone_items]> as:gemstone:
        - if !<[output].proc[tickcore_gemstones_proc.script.can_apply_gemstone].context[<[gemstone]>]>:
            - foreach stop
        - define type <[output].proc[tickcore_gemstones_proc.script.get_apply_type].context[<[gemstone]>]>
        - define output <[output].proc[tickcore_gemstones_proc.script.apply_gemstone].context[<[gemstone]>|<[type]>]>
    - if <[input]> == <[output]>:
        - stop
    - inventory set slot:17 o:<[output]> d:<[inventory]>

tickcore_gemstones_inventory_world:
    type: world
    debug: false
    events:
        after player opens tickcore_gemstones_inventory:
        - run tickcore_gemstones_inventory_generate_items def.inventory:<context.inventory>
        after player clicks in tickcore_gemstones_inventory:
        - run tickcore_gemstones_inventory_generate_items def.inventory:<context.inventory>
        on player clicks in tickcore_gemstones_inventory ignorecancelled:true bukkit_priority:highest:
        - if <context.slot> == 11 && <context.clicked_inventory.script.name.if_null[null]> == tickcore_gemstones_inventory:
            - determine cancelled:false
        - if <script[tickcore_gemstones_inventory].data_key[data.slots]> contains <context.slot> && <context.inventory.slot[<context.slot>]> !matches tickutil_inventories_container_fill_item:
            - determine cancelled:false

uncancel_inventory_inventory:
    type: inventory
    inventory: chest
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
uncancel_inventory_world:
    type: world
    debug: true
    events:
        on player clicks in uncancel_inventory_inventory ignorecancelled:true:
        - if <context.slot> == 1:
            - announce "Uncancelling the event.."
            - determine cancelled:false