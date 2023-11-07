# @ ----------------------------------------------------------
# TickUtil Text
# Adds many utility scripts that makes it easier to work with
# text.
# Author: 0TickPulse
# @ ----------------------------------------------------------

tickutil_text_prefix:
    type: format
    debug: false
    format: <element[<[text].custom_color[emphasis].bold> ]><element[»].color[dark_gray]>

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
        # Args: text, color
        - define list <list>
        - foreach <[1].split[<n>]> as:line:
            - if <[loop_index]> == 1:
                - define "list:->:<script[icons].parsed_key[red_icons.redstone]> <dark_gray>» <[2].if_null[<&[lore]>]><[line]>"
                - foreach next
            - define "list:->:   <dark_gray>» <[2].if_null[<&[lore]>]><[line]>"
        - determine <[list].separated_by[<n>]>
        lore_section_no_icon:
        # Args: text, color
        - determine <[1].split[<n>].parse_tag[   <dark_gray>» <[2].if_null[<&[lore]>]><[parse_value]>].separated_by[<n>]>
        split_description:
        # Args: text, color
        - define lines <[1].split_lines_by_width[<&sp.repeat[50].text_width.sub[<element[   »].text_width>]>]>
        - determine <[lines].lines_to_colored_list.separated_by[<n>].proc[tickutil_text.script.lore_section].context[<[2].if_null[<&[lore]>]>]>
        split_description_no_icon:
        # Args: text, color
        - define lines <[1].split_lines_by_width[<&sp.repeat[50].text_width.sub[<element[   »].text_width>]>]>
        - determine <[lines].lines_to_colored_list.separated_by[<n>].proc[tickutil_text.script.lore_section_no_icon].context[<[2].if_null[<&[lore]>]>]>
        dark_background:
        - define width <[1].text_width>
        - define times <[width].div[3.5].round_up>
        - define string <empty>
        - foreach <[1].to_list> as:char:
            - define string <[string]>

icons:
    type: data
    discord: DISCORD
    hline: <&sp.repeat[80].strikethrough>
    ranks:
        admin: <element[a].font[tickmc:ranks].color[white]>
    logo: <element[t].font[tickmc:icons].color[white]>
    energy: <element[e].font[tickmc:icons].color[white]>
    spaces:
        1: <element[0].font[tickmc:spaces].color[white]>
        2: <element[1].font[tickmc:spaces].color[white]>
        4: <element[2].font[tickmc:spaces].color[white]>
        8: <element[3].font[tickmc:spaces].color[white]>
        16: <element[4].font[tickmc:spaces].color[white]>
        32: <element[5].font[tickmc:spaces].color[white]>
        64: <element[6].font[tickmc:spaces].color[white]>
        128: <element[7].font[tickmc:spaces].color[white]>
        256: <element[8].font[tickmc:spaces].color[white]>
        512: <element[9].font[tickmc:spaces].color[white]>
    guis:
        resonance_station: <element[r].font[tickmc:guis].color[white]>
    damage_indicators:
        earth: <element[e].font[tickmc:damage_indicators].color[white]>
        ender: <element[n].font[tickmc:damage_indicators].color[white]>
        fire: <element[f].font[tickmc:damage_indicators].color[white]>
        ice: <element[i].font[tickmc:damage_indicators].color[white]>
        light: <element[l].font[tickmc:damage_indicators].color[white]>
        physical: <element[p].font[tickmc:damage_indicators].color[white]>
        shadow: <element[s].font[tickmc:damage_indicators].color[white]>
        thunder: <element[t].font[tickmc:damage_indicators].color[white]>
        water: <element[w].font[tickmc:damage_indicators].color[white]>
        wind: <element[d].font[tickmc:damage_indicators].color[white]>
    elements:
        earth: <element[e].font[tickmc:elements].color[white]>
        ender: <element[n].font[tickmc:elements].color[white]>
        fire: <element[f].font[tickmc:elements].color[white]>
        ice: <element[i].font[tickmc:elements].color[white]>
        light: <element[l].font[tickmc:elements].color[white]>
        physical: <element[p].font[tickmc:elements].color[white]>
        shadow: <element[s].font[tickmc:elements].color[white]>
        thunder: <element[t].font[tickmc:elements].color[white]>
        water: <element[w].font[tickmc:elements].color[white]>
        wind: <element[d].font[tickmc:elements].color[white]>
    red_icons:
        bow: <element[1].font[tickmc:icons].color[white]>
        material: <element[2].font[tickmc:icons].color[white]>
        question: <element[3].font[tickmc:icons].color[white]>
        redstone: <element[4].font[tickmc:icons].color[white]>
        skull: <element[5].font[tickmc:icons].color[white]>
        star: <element[6].font[tickmc:icons].color[white]>
        sword: <element[7].font[tickmc:icons].color[white]>
        potion: <element[8].font[tickmc:icons].color[white]>
