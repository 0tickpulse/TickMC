dPrevention_config:
    type: data
    debug: false
    options:
        #Whether or not players are able to hijack tamed entities from other players.
        vehicle-hijacking: false
    claims:
        #Default depth of claims, claimed via dPrevention_tool.
        depth: 0
        flags:
            #Key: value structure of flags that will be applied upon creation by default. True means it prevents it. Read the Documentation for more information about possible flags. https://github.com/Hydroxycobalamin/dPrevention/wiki/Documentation
            block-break: false
            block-place: false
            tnt: true
            lighter: true
            pvp: false
            piston: false
            container-access: true
            teleport-item: false
            item-frame-rotation: false
            vehicle-move: false
        ##If the flag need additional input, use a map with a list of values instead, format:
            #entities:
              #- COW
              #- ZOMBIE
            vehicle-place:
                - HOPPER_MINECART
        #Default priority that will be set on the area, upon creation.
        priority: 1
        #List world names in which users are able to create claims.
        worlds:
        - world
        - world_nether
        - world_the_end
    user:
        #Max blocks obtainable per time
        max-blocks-per-time: 2000
        #Amount of blocks a user receives, every 5 minutes of online time until max-blocks-per-time is reached.
        blocks-per-5-min: 25
    shop:
        #Price per block
        block-price: 1.5
        #Packets in which are blocks buyable (You can set up to 27 different packets). Values must be integers.
        blocks:
            - 1
            - 2
            - 10
            - 25
            - 50
            - 100
            - 250
            - 500
            - 1000
    inventories:
        #The filler item, which will be shown in unused spots of inventories. Handy if you're using a resource pack to hide the slot.
        filler-item: air
        hide-flag-permissions: true
        hide-flag-item: gray_stained_glass_pane
dPrevention_format:
    type: format
    debug: false
    format: <element[Claims].format[tickutil_text_prefix]> <&[base]><[text]>
