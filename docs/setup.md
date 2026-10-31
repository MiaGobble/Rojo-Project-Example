---
sidebar_position: 2
---

# Setup
You'll need to do a couple of things get this all set up, including:
* GitHub
* Rojo
* Pesde
* And more!

## First-time stuff
You'll need to do a few things one time only, if you have not already. You only need to do these once for them to work for all of your projects!

### Installing Rokit (once per machine)
You will need [Rokit](https://github.com/rojo-rbx/rokit) to use Rojo, Pesde, rbx-merge, and Lune.

To download Rokit on macOS or Linux, run this in your terminal:

```sh
curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash
```

To download Rokit on Windows, run this in PowerShell:

```sh
Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression
```

## Initializing each project
First, you'll need to publish your repository on GitHub. To do so, do the following in order:
* Create GitHub repository
* Clone repository locally (such as through GitHub desktop)
* Copy-paste everything from the template into the clone directory

### Installing tools (once per clone)
To install the tools included with the project, run `rokit install` in the folder's terminal.

### Installing packages (once per clone)
To install project packages, run `pesde install` in the folder's terminal.

:::warning

You will need to reinstall packages every time you change `pesde.toml`!

:::

### Generating initial sourcemap (once per clone)
To generate the initial sourcemap, run this in your terminal:

```
rojo sourcemap default.project.json --output sourcemap.json
```

### Setting up rbx-merge
rbx-merge is used to clean up diffs in version control over `game.rbxl`.

**Once per repository**, run the following:

```sh
rbx-merge install --write-gitattributes
git add .gitattributes
git commit -m "Mark Roblox files binary"
```

And **once per clone**, run the following:

```sh
rbx-merge install
rbx-merge doctor
```

### Customizing your stuff (once per repository)
It's recommended you do the following to customize your repository further:
* Remove default license
* Change *README* to your own stuff
* Edit *moonwave.toml* (https://eryn.io/moonwave/docs/Configuration)
* Remove these docs

## Setting up GitHub secrets (once per repository)
You will need to set up secrets for automated publishing.

### On Roblox
First, go to the [Roblox Creator page](https://create.roblox.com/), click *All tools*, and click *API Keys*.

Create an API Key, naming it something like "automated publishing".

Scroll down to *Permissions*, and add the following permissions:
* `universe-places` (`write`)

You may choose to restrict by experience and/or IP addresses. Make sure the key does not expire.

On the security warning popup, click the "I understand the security risks" checkbox, and then save & generate key. Save this key by clickikng "copy key to clipboard".

:::warning

**Make sure to save your key! It will go away once you leave the page.**

:::

### On GitHub
Now that you have your Roblox API key, go to your project, then *settings*, then *secrets and variables > actions*.

You are going to create three new repository secrets, each created by clicking "new repository secret".

For the first secret, use these details:
* Name: `ROBLOX_API_KEY`
* Secret: Your API key

For the second secret, use these details:
* Name: `UNIVERSE_ID`
* Secret: Your universe ID (also known as "game" or "experience" id, this it **not your place ID**)

Lastly, you'll need a secret with these details:
* Name: `PLACE_ID`
* Secret: Your main place ID (not the universe ID)

Finally, take a look at `.github/workflows/publish.yml` in your repository. Change the branch that triggers this from `none` to `main`.