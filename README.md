# HML.nvim

Adds `H`/`M`/`L` indicators to your line number column.

![hml.nvim screenshot](https://github.com/user-attachments/assets/7de33eaf-bda4-4876-a291-69f4f858394a)

By default in Neovim, `H`/`M`/`L` jump to the **h**ighest, **m**iddle, and **l**owest line in the current visible window. If you have [`scrolloff`](https://neovim.io/doc/user/options.html#'scrolloff') set, it can be dificult to tell exactly which lines they correspond to. This plugin helps you visualize this.

## Setup


With [lazy.nvim](https://github.com/folke/lazy.nvim/):

```lua
{
  'mawkler/hml.nvim',
  opts = {}
}
```

## Configuration

To set line numbers relative to your cursor's line, see [`:help 'relativenumber'`](https://neovim.io/doc/user/options.html#'relativenumber').

### Default configuration

```lua
{
  signs = {
    H = 'H', -- Sign to use for the `H` line number
    M = 'M', -- Sign to use for the `M` line number
    L = 'L', -- Sign to use for the `L` line number
  },
}
```
