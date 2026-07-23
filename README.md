# 🚀 C/C++ Optimized LazyVim Setup

A customized [LazyVim](https://github.com/LazyVim/LazyVim) configuration specifically tuned for highly efficient single-file **C/C++** and **Python** development. It features automated compilation, instant execution, and hassle-free debugging out of the box.

---

## ⚡ Core Features

- **Automated Dev-C++ Style compilation & running** (`<F5>`/`<F6>`) without manual Makefile setup.
- **Automated debugging** (`<F7>`) with integrated compiler flags (`-g -O0`) and automatic launching of `nvim-dap`.
- **Preconfigured C++ Language Server** using `clangd` extra module.
- **Embedded horizontal terminal integration** with `toggleterm.nvim` configured to hold terminal outputs upon program exit.
- **Consistent Code Formatting** default configuration with standard 4-space tab indentation.

---

## 🎹 Keyboard Shortcuts & Automation

Here is the custom automation mapped to your functional keys:

| Key | Action | Engine & Behavior |
| :--- | :--- | :--- |
| **`<F5>`** | **Compile & Run (External/Floating)** | Saves the file, compiles it (`g++` / `gcc`), and runs it. Uses **`ptyxis`**, **`kitty`**, or **`gnome-terminal`** if available; otherwise, displays in a floating `toggleterm`. Prompts before closing. |
| **`<F6>`** | **Run in Bottom Split** | Saves, compiles, and runs inside a horizontal bottom-split terminal (`toggleterm`). |
| **`<F7>`** | **Build with Debug Info & Debug** | Compiles using `-g -O0` for debug symbols and automatically initiates debugging session with `nvim-dap`. |
| **`<C-\>`** | **Toggle Terminal** | Shows/hides the horizontal bottom split terminal. |

---

## 📁 Repository Structure

- [init.lua](file:///home/trai/.config/nvim/init.lua) — The entrypoint bootstrapping the Neovim setup.
- [lua/config/lazy.lua](file:///home/trai/.config/nvim/lua/config/lazy.lua) — Manages plugins and lazy-loads the `clangd` language extra.
- [lua/config/keymaps.lua](file:///home/trai/.config/nvim/lua/config/keymaps.lua) — Defines functional mappings (`<F5>`, `<F6>`, `<F7>`) and compiler wrappers.
- [lua/config/options.lua](file:///home/trai/.config/nvim/lua/config/options.lua) — Indentation settings (4-spaces width).
- [lua/plugins/dap.lua](file:///home/trai/.config/nvim/lua/plugins/dap.lua) — Registers C/C++/Rust and Python launch targets for `nvim-dap` mapping directly to the active buffer.
- [lua/plugins/terminal.lua](file:///home/trai/.config/nvim/lua/plugins/terminal.lua) — Configures bottom split terminal and terminal layout defaults.

---

## 📥 Installation

Simply clone this repository to your local Neovim config folder:

```bash
git clone https://github.com/TraiNguyenVan/nvimmm.git ~/.config/nvim
```

---

## 🛠️ System Requirements

To take full advantage of this configuration, ensure the following dependencies are installed:

### 1. Compilers & Debuggers
- `gcc` and `g++` (or `clang`/`clang++`)
- `gdb` or `lldb`

### 2. LSP & Mason Packages
Run `:Mason` in Neovim and ensure the following are installed:
- `codelldb` (Required for F7 debugging automation)
- `clangd` (LSP server for C/C++)
- `stylua`, `shellcheck`, `shfmt`, `flake8` (Linters & formatters)

### 3. Optional Features
- External Terminal: **Ptyxis**, **Kitty**, or **Gnome Terminal** (If available, `<F5>` compiles and spawns your application in a dedicated external window).
