suspicious_beef:
    type: item
    material: rotten_flesh
    display name: <&[item]>Suspicious Beef
    mechanisms:
        custom_model_data: 1
    data:
        tickcore:
            stats:
                description: A particularly suspicious piece of beef. It looks like it's been sitting out for a while. Who knows how it was made.
                implementations:
                - consumable
                restores_food: 4
                effect_modifiers:
                - poison 10s 1
    recipes:
        1:
            type: furnace
            input: rotten_flesh
very_suspicious_beef:
    type: item
    material: rotten_flesh
    display name: <&[item]>Very Suspicious Beef
    mechanisms:
        custom_model_data: 1
    data:
        tickcore:
            stats:
                description: A very suspicious piece of beef. Perhaps you should stop smelting it, you thought, but you wonder what will happen if you keep going.
                implementations:
                - consumable
                restores_food: 3
                effect_modifiers:
                - poison 10s 1
                - hunger 10s 1
    recipes:
        1:
            type: furnace
            input: suspicious_beef

super_suspicious_beef:
    type: item
    material: rotten_flesh
    display name: <&[item]>Super Suspicious Beef
    mechanisms:
        custom_model_data: 1
    data:
        tickcore:
            stats:
                description: An extremely suspicious piece of beef that emanates some otherworldy energy. For some reason, you now have an addiction to smelting this piece of meat. You wonder what happens if you smelt it again. Maybe the furnace will explode?
                implementations:
                - consumable
                restores_food: 2
                effect_modifiers:
                - poison 20s 2
                - hunger 20s 1
                - wither 20s 1
                - blindness 20s 1
                - nausea 20s 2
    recipes:
        1:
            type: furnace
            input: very_suspicious_beef

very_suspicious_beef_world:
    type: world
    debug: false
    events:
        after player clicks in furnace:
        - define inventory <context.inventory>
        - if <[inventory].input> !matches super_suspicious_beef:
            - stop
        - announce test
        - adjust def:inventory furnace_cook_duration_total:1s
        after item moves from inventory to furnace:
        - define inventory <context.destination>
        - if <[inventory].input> !matches super_suspicious_beef:
            - stop
        - announce test
        - adjust def:inventory furnace_cook_duration_total:1s
