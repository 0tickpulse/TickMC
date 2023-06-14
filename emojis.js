//@ts-check
const { readFile, writeFile } = require("fs/promises");

async function main() {
    const list = JSON.parse(await readFile("./emojis.json", "utf-8"));

    // here's an example of an item in the list
    // {"codes":"1F600","char":"😀","name":"grinning face","category":"Smileys & Emotion (face-smiling)","group":"Smileys & Emotion","subgroup":"face-smiling"}
    // please convert that to
    // "grinning_face": "😀",
    // ...

    const emojis = list.reduce((acc, { name, char }) => {
        // if its a skin tone, skip it
        if (name.includes("skin tone")) return acc;

        const newName = name
            .replaceAll(" ", "_")
            .replaceAll("-", "_")
            .replaceAll("flag:_", "flag_")
            .replaceAll(":", "_")
            // utf8 quotes
            .replaceAll("“", "")
            .replaceAll("”", "")
            // dots
            .replaceAll(".", "")
            .toLowerCase();
        acc[newName] = char;
        return acc;
    }, {});

    // log in yaml format
    const yaml = Object.entries(emojis)
        .map(([name, char]) => `${name}: "${char}"`)
        .join("\n");

    // write file
    await writeFile("./emojis.yaml", yaml);
}
main();
