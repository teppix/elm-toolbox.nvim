# elm-toolbox.nvim

> [!WARNING]
> This is a personal plugin under active development. Features may change without notice.

Neovim plugin that provides Telescope pickers for top-level Elm definitions. It filters LSP document and workspace symbols to only show symbols starting at column 1, giving you a clean overview of your Elm module's public API.

## Requirements

- Neovim >= 0.9
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [elm-language-server](https://github.com/elm-tooling/elm-language-server) (must be configured separately)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "teppix/elm-toolbox.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
}
```

## Keymaps

The plugin does not set any keymaps. Example using lazy.nvim:

```lua
{
    "teppix/elm-toolbox.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
    keys = {
        { "gO", function() require("elm-toolbox").document_symbols() end, desc = "Elm document symbols" },
        { "gW", function() require("elm-toolbox").workspace_symbols() end, desc = "Elm workspace symbols" },
    },
}
```

## Telescope extension

The plugin registers as a Telescope extension:

```vim
:Telescope elm_toolbox document_symbols
:Telescope elm_toolbox workspace_symbols
```
