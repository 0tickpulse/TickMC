tickcore_accessory_bag_gui:
    type: inventory
    title: Accessories
    size: 54
    inventory: chest
    gui: true
    slots:
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
    - [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item] [tickutil_inventories_container_fill_item]
tickcore_accessory_bag_open:
    type: task
    debug: false
    script:
    - if !<inventory[tickcore_accessory_bag_<player.uuid>].exists>:
        - note <inventory[tickcore_accessory_bag_gui]> as:tickcore_accessory_bag_<player.uuid>
    - inventory open d:tickcore_accessory_bag_<player.uuid>
