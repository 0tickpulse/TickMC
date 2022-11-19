tickcore_auto_spawning_templates:
    type: data
    templates:
        vanilla_like:
            entity: cow
            location conditions:
            - <[location].is_spawnable>
            script:
            - spawn <[data.entity]>
        vanilla_nighttime:
            entity: zombie
            location conditions:
            - <[location].is_spawnable>
            - <[location].world.is_night>
            script:
            - spawn <[data.entity]>