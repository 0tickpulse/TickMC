# @ ----------------------------------------------------------
# Tick's Resource Pack Manager
# A script that will help you manage your resource packs.
# Author: 0TickPulse
# @ ----------------------------------------------------------

##IgnoreWarning invalid_data_line_quotes
resource_pack_data:
    type: data
    debug: false
    pack_link: https://github.com/0tickpulse/tickmc_pack/raw/master/release.zip
    hash_link: https://raw.githubusercontent.com/0tickpulse/tickmc_pack/master/hash.sha1
    pack_prompt: Please accept this pack!
    scripts:
        declined:
        - narrate "<element[TickMC Pack].format[tickutil_text_prefix]> It seems you have the resourcepack disabled! Please download it <element[here].custom_color[emphasis].bold.click_url[https://github.com/0tickpulse/tickmc_pack/raw/master/release.zip]>."
        failed_download:
        - narrate "<element[TickMC Pack].format[tickutil_text_prefix]> It seems the pack failed to download! Please try to download it again <element[here].custom_color[emphasis].bold.click_url[https://github.com/0tickpulse/tickmc_pack/raw/master/release.zip]>."
        accepted:
        - stop
        successfully_loaded:
        - playsound <player> entity.player.levelup custom
resource_pack_store_hash_task:
    type: task
    debug: false
    script:
    - define hash_link <script[resource_pack_data].parsed_key[hash_link]>

    - ~webget <[hash_link]> save:hash
    - define hash <entry[hash].result.split[<&sp>].get[1]>

    - if <server.flag[resource_pack.hash].if_null[null]> == <[hash]>:
        - stop
    - flag server resource_pack.hash:<[hash]>
    - debug log "New resource pack hash cached: <[hash]>"
resource_pack_send_task:
    type: task
    debug: false
    script:
    - define pack_link <script[resource_pack_data].parsed_key[pack_link]>
    - define prompt <script[resource_pack_data].parsed_key[pack_prompt]>

    - define hash <server.flag[resource_pack.hash]>

    - resourcepack url:<[pack_link]>#<[hash]> hash:<[hash]> prompt:<[prompt]>
resource_pack_update_command:
    type: command
    name: updatepack
    aliases:
    - updaterp
    - updateresourcepack
    - grp
    - getresourcepack
    - getpack
    description: Updates the resource pack. Won't work if you have it disabled.
    usage: /updatepack
    script:
    - run resource_pack_send_task

resource_pack_world:
    type: world
    debug: false
    events:
        on player joins:
        - ~run resource_pack_send_task
        on resource pack status:
        - define status <context.status>
        - if <script[resource_pack_data].list_keys[scripts].contains[<[status]>]>:
            - inject resource_pack_data path:scripts.<[status]>
        on system time minutely:
        - run resource_pack_store_hash_task