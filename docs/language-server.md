---
sidebar_position: 5
---

# Language server
Many Roblox developers opt to use the [Luau Language Server extention](https://open-vsx.org/extension/JohnnyMorganz/luau-lsp). It's recommended to use this as part of your workflow.

## Recommended settings
If you're using Luau Language Server on Visual Studio Code, it's recommended you use the following settings:

```sh
luau-lsp.fflags.enableNewSolver: true # Use the new type solver
luau-lsp.completion.autocompleteEnd: true # Write "end" automatically for things like if statements
luau-lsp.completion.fillCallArguments: false # This can be pretty annoying
luau-lsp.completion.showAnonymousAutofilledFunction: false # Also very annoying when it happens
```

Also ensure that the plugin is regenerating the Rojo sourcemap when your tree updates! This is handy for many of the other tools.