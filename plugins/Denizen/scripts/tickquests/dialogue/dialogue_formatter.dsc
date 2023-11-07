# id: (string)
# speaker:
#   title (string)
#   text (string)
# options: (list of strings)

tickquests_dialogue_update_text_task:
    type: task
    definitions: dialogue|dialogue_entity|selected[The selected option index.]
    debug: false
    script:
    - if !<[dialogue_entity].is_spawned>:
        - stop
    - define title <[dialogue.speaker.title]>
    - define text <[dialogue.speaker.text]>
    - define lines <list>
    # TITLE
    - define lines:->:<empty>
    - define lines:->:<&sp><[title].custom_color[emphasis].bold>
    # TEXT
    - define lines:->:<empty>
    - define lines:->:<&[base]><[text].split[<n>].parse_tag[ <[parse_value]> ].separated_by[<n>]>

    - define text <[lines].separated_by[<n>]>
    - define line_width <[dialogue_entity].line_width>
    - define height <[text].split_lines_by_width[<[line_width]>].split[<n>].size>

    # OPTIONS
    - define lines:->:<empty>
    - define line_heights <list>
    - foreach <[dialogue.options]> as:opt:
        - if <[selected].if_null[0]> == <[loop_index]>:
            - define "lines:->:<&sp><white>» <[opt].custom_color[fire].bold> <white>«"
        - else:
            - define "lines:->:<&sp><gray>» <[opt].color[white]>"
        - define option_split_line <[opt].split_lines_by_width[<[line_width]>].split[<n>].size>
        - define line_heights:->:<[option_split_line]>
    - define lines:->:<empty>

    - define text <[lines].separated_by[<n>]>
    - adjust <[dialogue_entity]> text:<[text]>
    - flag <[dialogue_entity]> tickquests.dialogue:<[dialogue]>
    - flag <[dialogue_entity]> tickquests.line_heights:<[line_heights].reverse>
    - if <[selected].exists>:
        - flag <[dialogue_entity]> tickquests.selected:<[selected]>

tickquests_dialogue_create_task:
    type: task
    definitions: dialogue|loc|dialogue_entity|players
    description: Creates a dialogue entity at the given location and shows it to the given players. Creates interaction entities for each option.
    debug: false
    script:
    - define id <[dialogue.id]>
    - if <server.has_flag[tickquests.dialogues.<[id].escaped>]>:
        - define dialogue_entity <server.flag[tickquests.dialogues.<[id].escaped>]>
    - if !<[dialogue_entity].as[entity].exists> || !<[dialogue_entity].as[entity].is_spawned>:
        - fakespawn tickquests_dialogue_text_display <[loc].with_pitch[0]> save:text players:<[players]>
        - define dialogue_entity <entry[text].faked_entity>
    - else:
        - teleport <[dialogue_entity]> <[loc].with_pitch[0]>
    - define loc <[dialogue_entity].location>

    - remove <[dialogue_entity].flag[tickquests.hover_entities].filter[is_spawned].if_null[<list>]>
    - run tickquests_dialogue_update_text_task def.dialogue:<[dialogue]> def.dialogue_entity:<[dialogue_entity]>
    - flag server tickquests.dialogues.<[id].escaped>:<[dialogue_entity]> expire:10s
    - define base_height <[dialogue_entity].scale.y.mul[0.25]>
    - define acc_height_unit 0
    - define hover_entities <list>
    - define lhs <[dialogue_entity].flag[tickquests.line_heights]>
    - foreach <[lhs]> as:lh:
        - define offset <[base_height].mul[<[acc_height_unit]>].add[0.25]>
        - spawn tickquests_dialogue_hover_entity <[loc].above[<[offset]>]> save:opt_entity
        # - define opt_entity <entry[opt_entity].faked_entity>
        - define opt_entity <entry[opt_entity].spawned_entity>
        - define hover_entities:->:<[opt_entity]>
        - adjust <[opt_entity]> height:<[base_height].mul[<[lh]>]>
        - adjust <[opt_entity]> width:1.5
        - flag <[opt_entity]> tickquests.dialogue:<[dialogue]>
        - flag <[opt_entity]> tickquests.loc:<[loc]>
        - flag <[opt_entity]> tickquests.dialogue_entity:<[dialogue_entity]> expire:10s
        - flag <[opt_entity]> tickquests.opt_index:<[lhs].size.sub[<[loop_index]>].add[1]>
        - flag <[opt_entity]> tickquests.players:<[players]>
        - define acc_height_unit:+:<[lh]>
    - flag <[dialogue_entity]> tickquests.hover_entities:<[hover_entities]> expire:10s
    - wait 10s
    - remove <[hover_entities].filter[is_spawned]>

tickquests_dialogue_text_display:
    type: entity
    entity_type: text_display
    mechanisms:
        background_color: black
        pivot: vertical
        display: left
        scale: 0.7,0.7,0.7
        line_width: 200
        # see_through: true

tickquests_dialogue_hover_entity:
    type: entity
    entity_type: interaction
