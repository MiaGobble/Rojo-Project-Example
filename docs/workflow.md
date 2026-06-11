---
sidebar_position: 3
---

# Project workflow
The workflow on this project is pretty simple!

## Editing code
Code is edited locally, using a tool like Visual Studio Code. Use Rojo to sync your code to your local `build.rbxl` place file.

Create `build.rbxl`, just run the following command in your project's terminal:

```
lune run lune/build
```

:::danger

**DO NOT EDIT/SYNC CODE IN `game.rbxlx`**! This can lead to massive, difficult-to-fix merge conflicts.

:::

## Editing assets or services
Edit assets/services directly in `game.rbxlx`. Save these changes by saving the file normally.

## Editing remotes
Edit remote events/functions in `src/Shared/Remotes.model.json`, using [Rojo model.json format](https://rojo.space/docs/v7/sync-details/#json-models).

:::info

It's important that your game file is a `rbxlx` file, not `rbxl`. This makes merging on GitHub much easier!

:::

## Publishing
To publish your game, simply push or merge to the main branch on Git! A GitHub action will build and publish the game for you.

## Building docs
Documentation is also built when pushing or merging to the main branch. A GitHub action handles this!

As a note, the first time you push, you should set up GitHub pages. Go to your GitHub repository, *settings*, and then *Pages*. Select the newly created `gh-pages` branch as the branch, and then save.

:::danger

**You cannot use GitHub pages on a private repository without the proper subscription!** In this case, you can view docs locally by running `moonwave dev --code src` in your folder's terminal.

:::

## Using Wally packages
To add packages to your game, check out what you can get at https://wally.run/. Copy the dependencies and paste them into `wally.toml`.

To install Wally packages, run the following in the terminal:
* `wally install` (to install the packages folder)
* `wally-package-types --sourcemap sourcemap.json Packages/` (to fix typechecking)