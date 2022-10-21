tickcore_ability_netherite_swaxovel_gigamine:
    type: task
    debug: false
    definitions: entity|data|context
    script:
    - define location <[entity].eye_location.ray_trace[range=4;return=block;default=air]>
    - define blocks <[location].add[-1,-1,-1].to_cuboid[<[location].add[1,1,1]>].blocks[vanilla_tagged:mineable*]>
    - modifyblock <[blocks]> air source:<[entity]>