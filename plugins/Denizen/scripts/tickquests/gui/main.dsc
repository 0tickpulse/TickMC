quest_gui_inventory:
    type: inventory
    inventory: chest
    size: 54
    gui: true
    title: <&[emphasis]><bold>Quests

quest_icon_item_proc:
    type: procedure
    definitions: quest
    debug: false
    script:
    - define item <[quest].parsed_key[icon].as[item].if_null[stone]>
    - adjust def:item display:<[quest].parsed_key[name].custom_color[emphasis].bold>
    - define lore <[quest].parsed_key[description].split_lines_by_width[120].custom_color[base].lines_to_colored_list>
    - define lore:->:<empty>
    - define "lore:->:<&[success]><bold>Click to start!"
    - adjust def:item lore:<[lore]>
    - determine <[item]>

quest_gui_open_task:
    type: task
    debug: false
    script:
    - define quests <proc[get_all_quests_proc]>
    - define inv <inventory[quest_gui_inventory]>
    - foreach <[quests]> as:q:
        - inventory d:<[inv]> set slot:<[loop_index]> o:<[q].proc[quest_icon_item_proc]>
    - inventory d:<[inv]> open
