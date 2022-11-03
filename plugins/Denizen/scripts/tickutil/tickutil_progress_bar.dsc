tickutil_progress_bar_data:
    type: data
    characters:
        full:
            left: <&font[sharp_bar]>L
            middle: <&font[sharp_bar]>M
            right: <&font[sharp_bar]>R
    bars:
        server:
            ram:
                from: 0
                to: <util.ram_allocated>
                value: <util.ram_usage>
                length: 15
                color: red

tickutil_progress_bar_proc:
    type: procedure
    debug: false
    definitions: from|to|value|length
    script:
    - define progress <[value].sub[<[from]>].div[<[from].add[<[to]>]>]>