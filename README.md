# edit_register.nvim

## Features

- Edit registers
- Edit macros (as the are stored in registers)

## Installation

Install with Lazy:
```lua
{
    "simodwall/edit_register.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim"
    }
}
```

## Default Options

The default options are:
```lua
{
    popup = {
        enter = true,
        border = {
            style = "rounded",
            text = {
                top_align = "center",
            },
        },
        position = "50%",
        size = {
            width = "20%",
            height = "20%",
        }
    }
}
```

## Usage

Run `require('edit_register').reg(...)` to edit a register.
Pressing `<cr>` in the popup will save the changes to the register.
Pressing `<esc>` into the popup will close it without saving the changes.
