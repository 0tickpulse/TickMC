potion_of_failures:
    type: item
    material: potion
    display name: <reset>Potion of failures
    mechanisms:
        potion_effects:
        - [type=instant_damage;upgraded=true;extended=true]
        - [type=blindness;amplifier=127;duration=10y]
        - [type=confusion;amplifier=127;duration=10y]
        - [type=darkness;amplifier=127;duration=10y]
        - [type=harm;amplifier=127;duration=10y]
        - [type=hunger;amplifier=127;duration=10y]
        - [type=levitation;amplifier=127;duration=10y]
        - [type=poison;amplifier=127;duration=10y]
        - [type=slow;amplifier=127;duration=10y]
        - [type=slow_digging;amplifier=127;duration=10y]
        - [type=unluck;amplifier=127;duration=10y]
        - [type=weakness;amplifier=127;duration=10y]
        - [type=wither;amplifier=127;duration=10y]
splash_potion_of_failures:
    type: item
    material: splash_potion
    display name: <reset>Splash potion of failures
    mechanisms:
        potion_effects: <script[potion_of_failures].data_key[mechanisms.potion_effects]>

potion_of_success:
    type: item
    material: ppotion
    display name: <reset>Potion of success
    mechanisms:
        potion_effects:
        - [type=instant_heal;upgraded=true;extended=true]
        - [type=absorption;amplifier=127;duration=10y]
        - [type=conduit_power;amplifier=127;duration=10y]
        - [type=damage_resistance;amplifier=127;duration=10y]
        - [type=dolphins_grace;amplifier=3;duration=10y]
        - [type=fast_digging;amplifier=127;duration=10y]
        - [type=fire_resistance;amplifier=127;duration=10y]
        - [type=heal;amplifier=127;duration=10y]
        - [type=health_boost;amplifier=127;duration=10y]
        - [type=hero_of_the_village;amplifier=127;duration=10y]
        - [type=increase_damage;amplifier=127;duration=10y]
        - [type=jump;amplifier=3;duration=10y]
        - [type=night_vision;amplifier=127;duration=10y]
        - [type=regeneration;amplifier=127;duration=10y]
        - [type=saturation;amplifier=127;duration=10y]
        - [type=speed;amplifier=3;duration=10y]
        - [type=water_breathing;amplifier=127;duration=10y]

splash_potion_of_success:
    type: item
    material: splash_potion
    display name: <reset>Splash potion of success
    mechanisms:
        potion_effects: <script[potion_of_success].data_key[mechanisms.potion_effects]>