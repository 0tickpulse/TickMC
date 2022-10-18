tickutil_text:
    type: procedure
    debug: false
    script:
        indefinite_article:
        - if <[1].to_list.get[1]> in a|e|i|o|u:
            - determine an
        - else:
            - determine a
        lore_section:
        - define list <list>
        - foreach <[1].split[<n>]> as:line:
            - if <[loop_index]> == 1:
                - define "list:->:<script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <&[base]><[line]>"
                - foreach next
            - define "list:->:   <dark_gray>» <&[base]><[line]>"
        - determine <[list].separated_by[<n>]>
        lore_section_no_icon:
        - determine <[1].split[<n>].parse_tag[   <dark_gray>» <&[base]><[parse_value]>].separated_by[<n>]>

icons:
    type: data
    damage_indicators:
        earth: <element[e].font[damage_indicators].color[white]>
        ender: <element[n].font[damage_indicators].color[white]>
        fire: <element[f].font[damage_indicators].color[white]>
        ice: <element[i].font[damage_indicators].color[white]>
        light: <element[l].font[damage_indicators].color[white]>
        physical: <element[p].font[damage_indicators].color[white]>
        shadow: <element[s].font[damage_indicators].color[white]>
        thunder: <element[t].font[damage_indicators].color[white]>
        water: <element[w].font[damage_indicators].color[white]>
        wind: <element[d].font[damage_indicators].color[white]>
    elements:
        earth: <element[e].font[elements].color[white]>
        ender: <element[n].font[elements].color[white]>
        fire: <element[f].font[elements].color[white]>
        ice: <element[i].font[elements].color[white]>
        light: <element[l].font[elements].color[white]>
        physical: <element[p].font[elements].color[white]>
        shadow: <element[s].font[elements].color[white]>
        thunder: <element[t].font[elements].color[white]>
        water: <element[w].font[elements].color[white]>
        wind: <element[d].font[elements].color[white]>
    red_icons:
        bow: <element[1].font[icons].color[white]>
        material: <element[2].font[icons].color[white]>
        question: <element[3].font[icons].color[white]>
        redstone: <element[4].font[icons].color[white]>
        skull: <element[5].font[icons].color[white]>
        star: <element[6].font[icons].color[white]>
        sword: <element[7].font[icons].color[white]>