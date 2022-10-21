tickcore_item_overrides_data:
    type: data
    convert on pickup: true
    convert on craft: true
    convert on inventory click: true
    keep enchants: true
    keep attributes: false
    keep display: false
    keep quantity: true
    # special overrides:
    #     bow: stone_hoe
    nbt exceptions:
    - mythic_type

tickcore_item_overrides_world:
    type: world
    debug: false
    events:
        on item recipe formed:
        # Generates tickitems
        - if <context.item.script.exists>:
            - if <context.item.script.name> in <proc[tickcore_proc.script.items.get_all_ids]>:
                - determine <context.item.script.name.proc[tickcore_proc.script.items.generate]>

        - if <script[tickcore_item_overrides_data].data_key[convert on craft]>:
          - define item <context.item.proc[tickcore_item_overrides_proc].if_null[null]>
          - if <[item]> != null:
            - determine <context.item.proc[tickcore_item_overrides_proc]>
        on player picks up item:
        - if <script[tickcore_item_overrides_data].data_key[convert on pickup]>:
          - define item <context.item.proc[tickcore_item_overrides_proc].if_null[null]>
          - if <[item]> != null:
            - determine ITEM:<context.item.proc[tickcore_item_overrides_proc]>
        on player prepares smithing item:
        - if <script[tickcore_item_overrides_data].data_key[convert on craft]>:
          - define item <context.item.proc[tickcore_item_overrides_proc].if_null[null]>
          - if <[item]> != null:
            - determine <context.item.proc[tickcore_item_overrides_proc]>
        on player clicks in inventory:
        - if <script[tickcore_item_overrides_data].data_key[convert on inventory click]>:
          - define item <context.item.proc[tickcore_item_overrides_proc].if_null[null]>
          - if <[item]> != null:
            - determine <context.item.proc[tickcore_item_overrides_proc]>

tickcore_item_overrides_proc:
    type: procedure
    debug: false
    definitions: item
    script:
    - if <[item].script.exists>:
        - stop
    - if <[item].material.name> == air:
        - stop
    - if <[item].raw_nbt.keys.contains_any[<script[tickcore_item_overrides_data].data_key[nbt exceptions]>]>:
        - stop
    # 2. Checks if there's a conversion override for this item. If so, converts it.
    - else if <script[tickcore_item_overrides_data].data_key[special overrides].keys.if_null[<list>]> contains <[item].material.name>:
        - define name <script[tickcore_item_overrides_data].data_key[special overrides.<[item].material.name>]>
        - define new_item <proc[tickcore_proc.script.items.generate].context[<[name]>].as[item].if_null[<[name].as[item]>]>
    # 3. If there's no conversion override, checks if there's a mythic item with the id as the item's material name.
    # If so, converts it.
    - else if vanilla_override_<[item].material.name> in <proc[tickcore_proc.script.items.get_all_ids]>:
        - define new_item <proc[tickcore_proc.script.items.generate].context[vanilla_override_<[item].material.name>]>
    # 4. If all else fails, stops the conversion.
    - else:
        - stop
    # Logic to keep the old item's property based on the configuration.
    - if <script[tickcore_item_overrides_data].data_key[keep enchants].if_null[false]>:
        - adjust def:new_item enchantments:<[item].enchantment_map>
    - if <script[tickcore_item_overrides_data].data_key[keep attributes].if_null[false]>:
        - adjust def:new_item attribute_modifiers:<[item].attribute_modifiers>
    - if <script[tickcore_item_overrides_data].data_key[keep display].if_null[false]>:
        - adjust def:new_item display:<[item].proc[tickutil_items.script.display]>
    - if <script[tickcore_item_overrides_data].data_key[keep quantity].if_null[false]>:
        - adjust def:new_item quantity:<[item].quantity>
    - determine <[new_item]>