tick_discord_error_logger_world:
    type: world
    debug: false
    events:
        after script generates error:
        - definemap embed_map:
                title: A script has generated an error!
                description: Error occured in `<context.script.name.if_null[a /ex command]>` at line `<context.line.if_null[none]>`!
                fields:
                    1:
                        title: Error<&co>
                        value: <context.message>
                color: red
        - if <context.queue.exists>:
            - definemap embed_map.fields.2:
                    title: Additional error information
                    value: Definitions:<n><context.queue.definition_map.parse_value_tag[<[parse_value].as[element].length.is_more_than[50].if_true[<[parse_value].substring[1,50]>...].if_false[<[parse_value]>]>].to_yaml><n>Linked player: <context.queue.player.if_null[none]><n>Linked npc: <context.queue.npc.if_null[none]>
        - if <context.script.exists>:
            - define embed_map.footer "See below for the full script!"
            - define script_text <context.script.to_yaml>
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:tick_discord channel:<script[tick_discord_data].parsed_key[staff channel]> <[embed]>
        - if <[script_text].exists>:
            - ~discordmessage id:tick_discord channel:<script[tick_discord_data].parsed_key[staff channel]> attach_file_text:<[script_text]> attach_file_name:script.yml
        after server generates exception:
        - definemap embed_map:
                title: ⚠️ An exception has been thrown! ⚠️
                description: <context.script.exists.if_true[Exception occured in `<context.script.name.if_null[a /ex command]>` at line `<context.line.if_null[none]>`!<n>].if_false[]>Exception: `<context.type>`: `<context.message>`
                color: red
        - define embed <discord_embed.with_map[<[embed_map]>]>
        - ~discordmessage id:tick_discord channel:<script[tick_discord_data].parsed_key[staff channel]> <[embed]>
