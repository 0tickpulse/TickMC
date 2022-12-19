hotbar_limiter_data:
    type: data
    categories:
        melee_weapon:
            matcher: <[item].raw_nbt.keys.contains[meleeweapon]>
            max: 1
            message: You can only have one melee weapon in your hotbar!
        ranged_weapon:
            matcher: <[item].raw_nbt.keys.contains[rangedweapon]>
            max: 1
            message: You can only have one ranged weapon in your hotbar!

hotbar_limiter_evaluate_hotbar_proc:
    type: procedure
    debug: false
    definitions: inventory
    script:
    - define messages <list>
    - define categories <script[hotbar_limiter_data].data_key[categories]>
    - define category_items <map>
    - foreach <[inventory].map_slots> key:slot as:item:
        - if <[slot]> > 9:
            - foreach next
        - foreach <[categories]> key:category as:category_data:
            - if <[category_data.matcher].parsed.if_null[false]>:
                - define category_items.<[category]>:+:<[item].quantity>
    - foreach <[categories]> key:category as:category_data:
        # if they exceed the maximum amount
        - if <[category_items.<[category]>].if_null[0]> > <[category_data.max]>:
            - define messages:->:<[category_data.message]>
    - definemap output:
        messages: <[messages]>
        cancel: <[messages].any>
    - determine <[output]>

hotbar_limiter_evaluate_hotbar_injection:
    type: task
    debug: false
    definitions: inventory
    script:
    - define output <proc[hotbar_limiter_evaluate_hotbar_proc].context[<[inventory]>]>
    - if <[output.messages].any>:
        - narrate <[output].get[messages].separated_by[<n>]>
    - if !<[output.cancel]>:
        - stop
    - inventory set d:<[inventory]> slot:<context.slot> o:<context.old_item>
    - define empty_slots <util.list_numbers_to[36].parse_tag[<map.with[<[parse_value]>].as[<[inventory].slot[<[parse_value]>]>]>].merge_maps.filter_tag[<[filter_value].advanced_matches[air]>].keys.exclude[1|2|3|4|5|6|7|8|9]>
    - if <[empty_slots].is_empty>:
        # If stack
        #- if <context.new_item.stac>
        - drop <context.new_item>
        - stop
    - inventory set d:<[inventory]> slot:<[empty_slots].first> o:<context.new_item>

hotbar_limiter_listener_world:
    type: world
    debug: false
    events:
        after player inventory slot changes:
        - if <context.slot> > 9:
            - stop
        - define inventory <player.inventory>
        - inject hotbar_limiter_evaluate_hotbar_injection