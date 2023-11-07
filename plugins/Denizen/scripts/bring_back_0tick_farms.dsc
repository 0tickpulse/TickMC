bring_back_0tick_farms_world:
    type: world
    debug: false
    events:
        after piston extends:
        # sugarcane/bamboo
        - define blocks <context.blocks.parse[above[1]]>

        # cactus
        - define forward <context.location.add[<context.direction>]>
        - define blocks:|:<[forward].center.find_blocks[cactus].within[1.2]>

        - foreach <[blocks]> as:block:
            - adjust <[block]> vanilla_tick
