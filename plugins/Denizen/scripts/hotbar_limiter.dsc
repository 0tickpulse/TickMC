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

hotbar_limiter_evaluate_hotbar_task:
    type: task
    debug: false
    script:
    - define categories <script[hotbar_limiter_data].data_key[categories]>
    - define category_items <map>
    - foreach <player.inventory.map_slots> key:slot as:item:
        - if <[slot]> > 9:
            - foreach next
        - foreach <[categories]> key:category as:category_data:
            - if <[category_data.matcher].parsed.if_null[false]>:
                - define category_items.<[category]>:++
    - foreach <[categories]> key:category as:category_data:
        - if <[category_items.<[category]>].if_null[0]> > <[category_data.max]>:
            - narrate <[category_data.message]>
            - stop