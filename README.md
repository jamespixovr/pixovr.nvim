# [pixovr.nvim](https://github.com/jarmex/pixovr.nvim)

Utility commands used in Neovim to make it easier to work with different workflows.

![[pixovr-image.png]]

## ⚡ Requirements

- Neovim >= [v0.7.0](https://github.com/neovim/neovim/releases/tag/v0.7.0)

## 📦 Installation

1. Install via your favorite package manager.

```lua
-- lazy.nvim
{
    "jamespixovr/pixovr.nvim",
    dependencies = {
      "stevearc/overseer.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>tc", "<cmd>Pixovr local<cr>"},
      { "<leader>ty", "<cmd>Pixovr lifecycle<cr>"},
    },
    config = true
  },
```

## 🚀 Usage

You can run specific commands with `:Pixovr <command>`

- `:Pixovr local` run pixovr.nvim in local mode
- `:Pixovr lifecycle` run pixovr.nvim in lifecycle mode
