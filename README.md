# Langkeeper.nvim

## Getting Started

Go to [https://langkeeper.tortitas.eu](https://langkeeper.tortitas.eu), register
an account and follow the instructions.

## Installation

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'TortitasT/langkeeper.nvim'
  config = function()
    require 'langkeeper'.setup()
  end
}
```

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "TortitasT/langkeeper.nvim",
  config = function()
    require 'langkeeper'.setup()
  end
},
```

Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'TortitasT/langkeeper.nvim'
lua require 'langkeeper'.setup()
```

Using [dein](https://github.com/Shougo/dein.vim)

```vim
call dein#add('TortitasT/langkeeper.nvim')
lua require 'langkeeper'.setup()
```

## Configuration

Configuration file is located in `~/.config/nvim/langkeeper.json`, you can open this file via `:LangkeeperConfig` command.

Configuration parameters

```json
{
  "address": "https://langkeeper.tortitas.eu",
  "email": "your@email.com",
  "password": "secret"
}
```
