slash_get_locations_proc:
    type: procedure
    debug: false
    definitions: data
    script:
    - foreach location|radius|rotation|points|arc as:def:
        - define <[def]> <[data.<[def]>]>
    - foreach arc|points as:def:
        - if <[<[def]>]> < 0:
            - debug error "Data '<[def]>' cannot be negative! (Given: <[<[def]>]>)"
            - stop
    - if <[rotation]> < 0:
        - define <[rotation]> <element[180].add[<[rotation]>]>
    - define list <list>
    # The starting angle
    - define i <[arc].div[-2].add[90]>
    # <[arc].div[2].add[90]> is the ending angle
    - while <[i]> <= <[arc].div[2].add[90]>:
        - define relative_horizontal_offset <[radius].mul[<[arc].div[2].sub[<[i]>].to_radians.sin>]>
        - define horizontal_offset <[relative_horizontal_offset].mul[<[rotation].to_radians.cos>]>
        - define forward_offset <[radius].mul[<[arc].div[2].sub[<[i]>].to_radians.cos>]>
        - define vertical_offset <[rotation].to_radians.sin.mul[<[relative_horizontal_offset]>]>
        - define list:->:<[location].forward[<[forward_offset]>].right[<[horizontal_offset]>].up[<[vertical_offset]>]>
        # Adds the angle interval
        - define i:+:<[arc].div[<[points]>]>
    - determine <[list]>

slash_get_entities_in_locations_proc:
    type: procedure
    debug: false
    definitions: data
    script:
    - define locations <[data].proc[slash_get_locations_proc]>
    - define entities <list>
    - foreach <[locations]> as:location:
        - define entities:|:<[location].points_between[<player.location>].distance[0.2].parse_tag[<[parse_value].find.living_entities.within[1]>].combine>
    - determine <[entities].deduplicate>