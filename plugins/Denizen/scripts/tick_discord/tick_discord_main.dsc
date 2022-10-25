tick_discord_data:
    type: data
    main group: 967071106261458954
    minecraft channel: 967428382721703966
    formatted minecraft to discord message: <[role].exists.if_true[<[role].name> ].if_false[]>**<player.name>** » <[message].strip_color>
    formatted discord to minecraft message: <script[icons].parsed_key[discord]> <[user].nickname[<script[tick_discord_data].data_key[main group]>].if_null[<[user].name>]> <gray>» <white><[message]>
    role group links:
    - [group=admin;role=tick_discord,<script[tick_discord_data].data_key[main group]>,967427661695692880]

tick_discord_connect:
    type: task
    debug: false
    script:
    - ~discordconnect id:tick_discord token:<secret[tick_discord_token]>
tick_discord_connect_world:
    type: world
    debug: false
    events:
        after server start:
        - run tick_discord_connect

tick_discord_world:
    type: world
    debug: false
    events:
        after custom event id:tick_chat_player_sends_message:
        - if <discord_bots.parse[name]> !contains tick_discord:
            - stop
        - define message <context.message>
        - define groups <player.groups>
        - foreach <script[tick_discord_data].data_key[role group links].parse[as[map]]> as:map:
            - if <[groups]> contains <[map.group]>:
                - define role <[map.role].parsed.as[discordrole]>
        - ~discordmessage id:tick_discord channel:<script[tick_discord_data].data_key[minecraft channel]> <script[tick_discord_data].parsed_key[formatted minecraft to discord message]> no_mention
        after discord message received:
        - if <context.channel.id> != <script[tick_discord_data].data_key[minecraft channel].as[discordchannel].id>:
            - stop
        - define user <context.new_message.author>
        - if <[user].is_bot>:
            - stop
        - define message <context.new_message.text>
        - announce <script[tick_discord_data].parsed_key[formatted discord to minecraft message]>
tick_discord_register_commands:
    type: task
    debug: false
    script:
    - ~discordcommand id:tick_discord create group:<script[tick_discord_data].data_key[main group]> name:playerlist "description:Gets a list of online players."
tick_discord_command_manager:
    type: world
    debug: false
    events:
        after discord slash command:
        - define interaction <context.interaction>
        - define command <context.command>
        - define options <context.options.if_null[<map>]>
        - choose <[command].name>:
            - case playerlist:
                - ~discordinteraction defer interaction:<[interaction]>
                - define players <proc[tick_essentials_proc.script.online_players].parse[name]>
                - if <[players].is_empty>:
                    - define message "There are no online players!"
                - else:
                    - define message <[players].comma_separated>
                - ~discordinteraction reply interaction:<[interaction]> <[message]>

# tick_discord_webhook_task:
#     type: task
#     debug: false
#     definitions: group|channel|avatar
#     script:
#     - if !<server.has_flag[tick_discord.webhook_data]>:
#         - ~run tick_discord_webhook_link_task
#     - define webhook_data <server.flag[tick_discord.webhook_data].if_null[null]>
#     - definemap outgoing_data:
#             id: <[webhook_data.id]>
#             type: 1
#             guild_id: <[webhook_data.guild_id]>
#             channel_id: <[webhook_data.channel_id]>
#             name: Tick discord link
#             avatar:
# tick_discord_webhook_link_task:
#     type: task
#     debug: false
#     script:
#     - ~webget <script[tick_discord_data].data_key[webhook url]> save:data
#     - flag server tick_discord.webhook_data:<entry[data].result>