# nvim-tmux-navigator

This plugin is a rewrite of [Vim Tmux Navigator](https://github.com/christoomey/vim-tmux-navigator) entirely in Lua.

# Installation

This plugin currently requires the use of Neovim 0.5 to enable Lua support.
To install the plugin with [Packer](https://github.com/wbthomason/packer.nvim) include the following in your startup function.

```lua
use 'robaire/nvim-tmux-navigator'
```

The plugin must then be enabled by calling `require('nvim-tmux-navigator').setup{}` anywhere in your `init.lua`.

# Usage

By default the following key bindings are added.
- `<C-H>`: `<C-W><C-H>`
- `<C-J>`: `<C-W><C-J>`
- `<C-K>`: `<C-W><C-K>`
- `<C-L>`: `<C-W><C-L>`

When running Neovim inside of a TMUX environment these bindings will navigate to the adjacent TMUX pane when attempting to navigate past the edge of the Neovim window.
