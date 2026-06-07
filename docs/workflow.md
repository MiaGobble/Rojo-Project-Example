---
sidebar_position: 3
---

# Project workflow
The workflow on this project is pretty simple!

## Editing code
Code is edited locally, using a tool like Visual Studio Code. Use Rojo to sync your code to your local `game.rbxlx` place file.

## Editing assets or services
Edit assets/services directly in `game.rbxlx`. Save these changes by saving the file normally.

## Editing remotes
Edit remote events/functions in `src/Shared/Remotes.model.json`, using [Rojo model.json format](https://rojo.space/docs/v7/sync-details/#json-models).

:::info

It's important that your game file is a `rbxlx` file, not `rbxl`. This makes merging on GitHub much easier!

:::