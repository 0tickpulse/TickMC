tickcore_entity_drop_data:
    type: data

tickcore_entity_drop_world:
    type: world
    debug: false
    events:
        on entity dies:
        - if !<context.entity.proc[tickcore_proc.script.entities.is_tickentity]>:
            - stop

        - if !<context.entity.proc[tickcore_entity_drop_proc.script.get_drops_data].exists>:
            - stop

        - define drops_data <context.entity.proc[tickcore_entity_drop_proc.script.get_drops_data]>

        - if <[drops_data.remove_vanilla].if_null[true]>:
            - determine passively no_drops

        - if <[drops_data].keys> contains exp:
            - determine passively <[drops_data.exp]>

        - define items <[drops_data.items].if_null[null]>
        - if <[items]> != null:
            - determine passively <[items]>

        - if <[drops_data].keys> contains money:
            - if <context.damager.exists>:
                - if <context.damager.is_player>:
                    - money give quantity:<[drops_data.money]> players:<context.damager>

tickcore_entity_drop_proc:
    type: procedure
    debug: false
    script:
        get_drops_data:
        - if !<[1].script.exists>:
            - stop
        - if !<[1].script.list_deep_keys.contains[data.tickcore_drops]>:
            - stop
        - determine <[1].script.data_key[data.tickcore_drops]>