tickcore_death_messages_world:
    type: world
    debug: false
    events:
        on player dies:
        - define entity <context.damager.if_null[null]>
        - define victim <context.entity>
        - define cause <context.cause>

        - if <[entity].proc[tickcore_proc.script.entities.is_tickentity].if_null[false]>:
            - if <[entity].script.list_deep_keys> contains data.tickcore.death_messages:
                - define death_messages <[entity].script.parsed_key[data.tickcore.death_messages]>

        - if <[death_messages].exists>:
            - determine <[death_messages].random>