# Minimal Neovim Setup (Vanilla, Quiet, Fully Controlled)

A **clean, framework-free Neovim configuration** focused on stability, modest syntax highlighting, and zero UI noise.

- Vanilla Neovim (no LazyVim, no plugin frameworks)
- One configuration file 
- Modest syntax highlighting for common languages
- No autocomplete popups

---

## Neovim Installation

- **Version:** Neovim 0.11.x
- **Source:** Official Neovim binary
- **Binary location (example):**
  ```
  /opt/nvim-linux-x86_64/bin/nvim
  ```

Verify:

```sh
nvim --version
```

---

## Configuration Layout

### Active configuration

```
~/.config/nvim/
└── init.lua
```

### Intentionally absent

These directories remain empty unless you explicitly add plugins later.

```
~/.local/share/nvim/   (no plugins)
~/.local/state/nvim/
~/.cache/nvim/
```
---

## Complete `init.lua`

```lua
-- ==============================
-- Vanilla Neovim configuration
-- ==============================

-- UI
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = false
vim.opt.showmode = false

-- Editing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Quiet behavior
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.updatetime = 300

-- Filetype detection and indentation
vim.cmd("filetype plugin indent on")

-- Built-in syntax highlighting
vim.cmd("syntax on")

-- Colors
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("colorscheme habamax")
```

---

## Enabled Features

### Editor Behavior

- Absolute line numbers
- No relative numbers
- No line wrapping
- No cursor line highlight
- No mode indicator noise
- Predictable indentation
- Fast, quiet UI updates

### Completion Behavior

- **No autocomplete popups**
- No completion engines loaded
- `completeopt` configured conservatively in case completion is added later

---

## Syntax Highlighting Strategy

### Built-in Vim syntax only (no plugins)

- Uses Neovim’s built-in syntax files
- No Treesitter
- No LSP
- No external dependencies

Supported out of the box:

- Bash (`sh`)
- Python
- Rust
- Go
- SQL

Verify filetype detection:

```vim
:set ft?
```

---

## Colorscheme and Theme

### Base theme

- Built-in colorscheme: `habamax`

```lua
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd("colorscheme habamax")
```

---

## Optional Color Overrides

```lua
vim.api.nvim_set_hl(0, "Comment",  { fg = "#7a7a7a", italic = true })
vim.api.nvim_set_hl(0, "String",   { fg = "#8fb573" })
vim.api.nvim_set_hl(0, "Function", { fg = "#82aaff" })
vim.api.nvim_set_hl(0, "Type",     { fg = "#4ec9b0" })
```

Inspect highlight groups interactively:

```vim
:Inspect
```

---

## Verification Checklist

### Confirm vanilla state

```vim
:scriptnames
```

Expected output:
- Neovim runtime files
- `~/.config/nvim/init.lua`

No plugin files should appear.

### Confirm no config leakage

```sh
ls ~/.local/share/nvim
```

Should return:
```
No such file or directory
```

---

## Reset Procedure (if ever needed)

To return to a pristine state:

```sh
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
```

Recreate `init.lua` afterward.



