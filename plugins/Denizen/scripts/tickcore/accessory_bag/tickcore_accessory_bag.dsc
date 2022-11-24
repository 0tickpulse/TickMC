tickcore_accessory_bag_gui:
    type: inventory
    title: Accessories
    size: 45
    inventory: chest
    gui: true
    data:
        slots:
            artifact_1:
                slot: 11
                filter: <[item].proc[tickcore_proc.script.items.get_stat].context[implementations].contains[weapon_melee].if_null[false]>
            artifact_2:
                slot: 20
                filter: <[item].proc[tickcore_proc.script.items.get_stat].context[implementations].contains[weapon_melee].if_null[false]>
            artifact_3:
                slot: 29
                filter: <[item].proc[tickcore_proc.script.items.get_stat].context[implementations].contains[weapon_melee].if_null[false]>
tickcore_accessory_bag_open:
    type: task
    debug: false
    script:
    - if !<inventory[tickcore_accessory_bag_<player.uuid>].exists>:
        - note <inventory[tickcore_accessory_bag_gui]> as:tickcore_accessory_bag_<player.uuid>
    - inventory open d:tickcore_accessory_bag_<player.uuid>
tickcore_accessory_bag_erase_task:
    type: task
    debug: false
    script:
    - note remove as:tickcore_accessory_bag_<player.uuid>
tickcore_accessory_bag_world:
    type: world
    debug: false
    events:
        on player clicks in tickcore_accessory_bag_gui bukkit_priority:monitor ignorecancelled:true:
        - if <context.clicked_inventory> !matches tickcore_accessory_bag_gui:
            - stop
        - foreach <script[tickcore_accessory_bag_gui].data_key[data.slots]> key:name as:map:
            - if <[map.slot]> != <context.slot>:
                - foreach next
            - if <context.hotbar_button> == 0:
                - define item <context.cursor_item>
            - else:
                - define item <player.inventory.slot[<context.hotbar_button>]>
            - if <[item]> matches air:
                - determine cancelled:false passively
                - foreach next
            - if !<[map.filter].parsed.if_null[true]>:
                - foreach next
            - determine cancelled:false passively