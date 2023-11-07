get_all_quests_proc:
    type: procedure
    debug: false
    script:
    - determine <util.scripts.filter_tag[<[filter_value].container_type.equals[data].and[<[filter_value].data_key[tickquest].if_null[false]>]>]>
