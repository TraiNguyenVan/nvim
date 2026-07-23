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

## 📥 Installation & Setup

Choose **one** of the two paths below to initialize your development environment:

### 🐳 Option A: Containerized Setup (Easiest & Cleanest)
Run this pre-baked Neovim environment (containing all compilers, LSPs, and plugins) without polluting your host machine's system packages.

#### 🔴 Run with Podman (Fedora default - Rootless & SELinux compatible)
```bash
podman run -it --rm -v "$(pwd):/workspace:Z" docker.io/heodocker/nvim:latest
```

#### 🔵 Run with Docker
```bash
docker run -it --rm -v "$(pwd):/workspace" docker.io/heodocker/nvim:latest
```

#### 🛠️ (Optional) Build & Run Locally
If you prefer to build the Alpine image locally instead of pulling it from DockerHub:
```bash
cd ~/.config/nvim
./docker-run.sh
```

---

### 💻 Option B: Native Host Installation
Use this path to install and run Neovim directly on your local system.

#### 1. Install System Dependencies
Run the command block corresponding to your Linux distribution:

##### 🔵 Fedora Linux
```bash
# Install compilers & debugger
sudo dnf groupinstall "Development Tools"
sudo dnf install gcc-c++ gdb

# Enable Copr repo and install lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit

# Install CLI utilities and terminals
sudo dnf install fzf git ptyxis kitty
```

##### 🟠 Debian / Ubuntu Linux
```bash
# Install compilers, debugger, git, and fzf
sudo apt update && sudo apt install build-essential gdb git fzf -y

# Install terminal emulators (optional, for <F5> launcher)
sudo apt install ptyxis kitty -y

# Install lazygit (via github release binary)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin/
rm lazygit lazygit.tar.gz
```

#### 2. Clone the Configuration
```bash
git clone https://github.com/TraiNguyenVan/nvim.git ~/.config/nvim
```

#### 3. Setup LSPs & Formatters (via Mason)
Open Neovim and run `:Mason` to verify or install the following local packages:
- **`codelldb`** (Required for `<F7>` debug automation)
- **`clangd`** (C/C++ Language Server Protocol)
- **`stylua`**, **`shellcheck`**, **`shfmt`**, **`flake8`** (Formatters & linters)

---

## 🎹 Keyboard Shortcuts & Workflows

This configuration integrates custom keybinds for C/C++ development with standard, highly efficient [LazyVim](https://github.com/LazyVim/LazyVim) shortcuts.

### 🚀 1. Dev-C++ Style Quick Running
Save, compile, and run your single-file C, C++, or Python scripts with one keypress:
* **`<F5>`** — **Compile & Run (External/Floating)**: Compiles the active buffer (using `g++` or `gcc`) and executes it inside an external window (**Ptyxis**, **Kitty**, or **Gnome Terminal**). If no external terminal is installed, it runs in a floating `toggleterm`.
* **`<F6>`** — **Run in Bottom Split**: Compiles and runs the code directly inside a bottom horizontal terminal pane (`toggleterm`).

---

### 🪲 2. Debugging Workflow (`nvim-dap` & `dap-ui`)
A fully-integrated GUI debugging experience for C, C++, Rust, and Python.

- **`<F7>`** — **Build & Start Debugging**: Automates compiling the file with debugging flags (`-g -O0` for C/C++), starts the `dap` session, and opens the DAP UI panel on the right.
- **`<leader>db`** — **Toggle Breakpoint**: Place a breakpoint on the current cursor line.
- **`<leader>dc`** — **Continue**: Resume program execution until the next breakpoint.
- **`<leader>dO`** — **Step Over**: Step to the next line of code without entering functions.
- **`<leader>di`** — **Step Into**: Step inside the function under the cursor.
- **`<leader>do`** — **Step Out**: Finish the current function and return to its caller.
- **`<leader>dt`** — **Terminate**: Instantly end the debugging session.

#### 🎛️ DAP UI Mappings (active inside the debug sidebar):
- **`<CR>`** or **Double-Click** — Expand/Collapse variable details.
- **`o`** — Open/inspect values.
- **`d`** — Remove a watched variable.
- **`e`** — Edit variable values inline.
- **`t`** — Toggle execution frame.

---

### 📁 3. File Browsing & Search
Easily navigate, open, and manage files in your workspace.

- **`<leader>e`** or **`<leader>E`** — **Toggle File Tree**: Opens/closes the **Neo-tree** file explorer.
- **`<leader><space>`** — **Find Files**: Instantly fuzzy search and open files in the current workspace.
- **`<leader>ff`** — **Find Files (Alternate)**: Standard file locator panel.
- **`<leader>/`** or **`<leader>sg`** — **Live Grep**: Search for text patterns across all files in your project.
- **`<leader>fb`** — **Buffers List**: Quick switcher to display and toggle open buffers.

---

### 🎨 4. Code Formatting & LSP
Maintain code quality with auto-formatting and compiler integrations.

- **`<leader>cf`** — **Format Document**: Manually run the code formatter (uses `conform.nvim` with `stylua`, `shfmt` or LSP formatting).
- **`gd`** — **Go to Definition**: Jump to the source code definition of the symbol under your cursor.
- **`gr`** — **Find References**: Lists all locations where the current symbol is referenced.
- **`K`** — **Hover Info**: Displays the type definition, signature, and documentation for the symbol.
- **`<leader>cr`** — **Rename Symbol**: Refactor and rename all instances of a variable or function project-wide.

---

### 🐙 5. Git Workflow & LazyGit Guide
Track, diff, stage, commit, and push your changes seamlessly.

#### 🔍 Inline Hunk Management (`gitsigns`):
- **`]h`** / **`[h`** — **Next/Prev Hunk**: Jump cursor directly to the next/previous code change.
- **`<leader>gf`** — **Git Blame Line**: Show git author and commit info inline for the active line.
- **`<leader>ghd`** — **Diff Hunk**: View side-by-side or inline diff comparing the active code block to the git index.
- **`<leader>ghs`** — **Stage Hunk**: Stage the current block of modifications.
- **`<leader>ghr`** — **Reset Hunk**: Undo changes in the current block back to the last commit.

#### 🎛️ Interactive floating Git GUI (`lazygit`):
- **`<leader>gg`** — **Open LazyGit**: Launches the LazyGit TUI inside a floating terminal.
- **`<leader>gG`** — **Open LazyGit (cwd)**: Launches LazyGit scoped to the current working subdirectory.

Once inside **LazyGit**, use these essential controls:
- **`1` / `2` / `3` / `4` / `5`** — Switch focus to panels: Status, Files, Branches, Commits, Stash.
- **`Space`** — **Stage/Unstage** selected file or changes.
- **`a`** — Stage all files.
- **`c`** — **Commit** staged changes (opens input field to write commit message).
- **`P`** (Shift+p) — **Push** local commits to the remote origin.
- **`p`** (lowercase) — **Pull** remote changes into local branch.
- **`3` $\rightarrow$ Highlight Branch $\rightarrow$ `Space`** — **Switch Branch** (Checkout).
- **`3` $\rightarrow$ `n`** — Create a **New Branch** from current HEAD.
- **`Esc`** or **`q`** — Exit the LazyGit screen.
- **`?`** — Display a full help sheet of shortcuts inside any focused panel.

> [!TIP]
> **WhichKey Integration**: LazyVim has built-in interactive menus. If you're ever unsure about a keybind, simply press your leader key (`<space>`) or the group key (like `g` for Git, `d` for Debug, or `f` for Find) and wait 1 second. A popup menu will display all registered keymaps and their exact functions.

---

### 🖥️ 6. Terminal Management
- **`<C-\>`** — **Toggle Terminal**: Show or hide the bottom split terminal pane (`toggleterm`).
- **`q`** (Normal mode inside terminal) — Close/hide the terminal panel.

---

## 📁 Repository Structure

- [init.lua](file:///home/trai/.config/nvim/init.lua) — The entrypoint bootstrapping the Neovim setup.
- [lua/config/lazy.lua](file:///home/trai/.config/nvim/lua/config/lazy.lua) — Manages plugins and lazy-loads the `clangd` language extra.
- [lua/config/keymaps.lua](file:///home/trai/.config/nvim/lua/config/keymaps.lua) — Defines functional mappings (`<F5>`, `<F6>`, `<F7>`) and compiler wrappers.
- [lua/config/options.lua](file:///home/trai/.config/nvim/lua/config/options.lua) — Indentation settings (4-spaces width).
- [lua/plugins/dap.lua](file:///home/trai/.config/nvim/lua/plugins/dap.lua) — Registers C/C++/Rust and Python launch targets for `nvim-dap` mapping directly to the active buffer.
- [lua/plugins/terminal.lua](file:///home/trai/.config/nvim/lua/plugins/terminal.lua) — Configures bottom split terminal and terminal layout defaults.
