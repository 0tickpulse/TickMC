quest_dialogue_example:
    type: task
    debug: false
    script:
    - ~run quest_dialogue def.id:test def.queue:<queue> "def.dialogue:What is your name?<n><n><&7>(Right click)|<player.name>|James" save:name def.source:<npc[2]>
    - define name <entry[name].created_queue.determination.first.strip_color>
    - if <[name]> == James:
        - ~run quest_dialogue def.id:test def.queue:<queue> def.stop:false "def.dialogue:Hey, stop lying!|Okay..." def.source:<npc[2]>
        - kill <player>
    - else:
        - ~run quest_dialogue def.id:test def.queue:<queue> "def.dialogue:Hello, <[name]>!|Hello!" def.source:<npc[2]>
    - ~run quest_dialogue_remove def.id:test
        # - ~run quest_objective_set def.quest:Quest1 "def.objective:Second Objective"

quest_dialogue:
    type: task
    definitions: id[Temporary identifier]|queue[The queue that the dialogue is run in. If there's no response in 10 seconds, the dialogue will automatically stop, and if the 'stop' def is not set to false, stopping the queue if it exists, otherwise returning null.]|speaker[The name of the speaker. If unused and there is a NPC as the source, will use the NPC's name]|dialogue[A ListTag where first element is the speaker and rest is the responses.]|source[The location or NPC to run the dialogue at.]|stop[Whether or not to stop the queue if it exists.]
    debug: true
    description: Runs a singular dialogue with a player. If the `~waitable` syntax is used, the queue will wait until the player selects a choice.
    script:
    - if !<[speaker].exists>:
        - define speaker <[source].as[npc].name.if_null[???]>
    - define is_npc false
    - if <[source].as[npc].exists>:
        - define is_npc true
        - define source <[source].as[npc].eye_location.face[<player.location>].forward[1]>
    - definemap d:
        id: <[id]>
        speaker:
            title: <[speaker]>
            text: <[dialogue].as[list].first>
        options: <[dialogue].as[list].remove[1]>
    - flag <player> tickquests.selected:!
    - run tickquests_dialogue_create_task def.dialogue:<[d]> def.loc:<[source]> def.players:<player.as[list]>
    - waituntil <player.has_flag[tickquests.selected]> max:10s
    - define choice <player.flag[tickquests.selected.dialogue.options].get[<player.flag[tickquests.selected.opt_index]>].if_null[null]>
    - if <[choice]> == null:
        - actionbar "<&[error]>You didn't select a choice in time!"
        - if <[queue].exists> && <[stop].if_null[true]>:
            - queue <[queue]> stop
        - stop
    - determine <[choice]>

quest_dialogue_remove:
    type: task
    definitions: id[The identifier of the dialogue to remove.]
    debug: false
    script:
    - define dialogue_entity <server.flag[tickquests.dialogues.<[id].escaped>].if_null[null]>
    - if <[dialogue_entity]> != null:
        - remove <[dialogue_entity].flag[tickquests.hover_entities].if_null[<list>]>
        - remove <[dialogue_entity]>
    - foreach <util.queues> as:q:
        - if <[q].script.name> == quest_dialogue && <[q].player> == <player>:
            - queue <[q]> stop

quest_dialogue_choice_world:
    type: world
    debug: false
    events:
        after delta time secondly:
        - repeat 4:
            - foreach <server.online_players> as:__player:
                - define interaction <player.eye_location.ray_trace_target[ignore=<player>;entities=tickquests_dialogue_hover_entity].if_null[null]>
                - if <[interaction]> == null:
                    # - narrate "no interaction"
                    - stop
                - if <[interaction].flag[tickquests.players]> !contains <player>:
                    # - narrate "not in list"
                    - stop
                # - narrate <[interaction].flag[tickquests.dialogue.options].get[<[interaction].flag[tickquests.opt_index]>]>
                # - narrate "selected something"
                - run tickquests_dialogue_update_text_task def.dialogue:<[interaction].flag[tickquests.dialogue]> def.dialogue_entity:<[interaction].flag[tickquests.dialogue_entity]> def.selected:<[interaction].flag[tickquests.opt_index]>
            - wait 5t
        after player right clicks tickquests_dialogue_hover_entity:
        # ratelimit to prevent double firing
        - ratelimit <player> 5t
        - define interaction <context.entity>
        - if <context.entity.flag[tickquests.players]> !contains <player>:
            - stop
        - flag <player> tickquests.selected.dialogue:<[interaction].flag[tickquests.dialogue]> expire:25t
        - flag <player> tickquests.selected.dialogue_entity:<[interaction].flag[tickquests.dialogue_entity]> expire:25t
        - flag <player> tickquests.selected.opt_index:<[interaction].flag[tickquests.opt_index]> expire:25t
        - playsound sound:ui_button_click <player>
