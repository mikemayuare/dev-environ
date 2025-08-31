# My Personal Dotfiles for a Data Analyst Workflow

These are my personal configuration files for various tools I use in my daily work as a data analyst. The setup is highly customized to provide an efficient and enjoyable experience, with a strong focus on keyboard-driven workflows, session management, and a pleasant aesthetic.

## Philosophy

The main goal of this setup is to create a powerful and distraction-free environment for data analysis. This is achieved by:

-   **Keyboard-driven workflow:** Minimizing the need for a mouse and keeping hands on the keyboard.
-   **Seamless navigation:** Moving between windows, panes, and tools with ease.
-   **Session persistence:** Restoring workspaces and sessions automatically.
-   **Aesthetics:** Using a consistent and pleasant color scheme (Dracula) and fonts across all tools.
-   **Reproducibility:** Keeping all configurations version-controlled.

## Tools

### Terminal Emulators

I use a few different terminal emulators, each with its own strengths:

-   **Alacritty:** A fast, GPU-accelerated terminal emulator.
-   **Kitty:** A feature-rich and extensible terminal emulator.
-   **Ghostty:** A modern, GPU-accelerated terminal emulator.

All terminals are configured to use the **Dracula** theme and a Nerd Font for good icon support in the prompt and other tools.

### Terminal Multiplexer: Tmux

[Tmux](https://github.com/tmux/tmux/wiki) is used to manage multiple terminal sessions and windows. My configuration includes:

-   **Vim-like navigation:** Using `Ctrl-h/j/k/l` to navigate between panes, thanks to `vim-tmux-navigator`.
-   **Session persistence:** Using `tmux-resurrect` and `tmux-continuum` to automatically save and restore tmux sessions, so I can pick up where I left off after a reboot.
-   **Dracula theme:** A beautiful theme that also displays CPU, GPU, and RAM usage, which is useful for monitoring data processing tasks.
-   **Custom keybindings:** For splitting windows, resizing panes, and reloading the configuration.

### Code Editor: Neovim

[Neovim](https://neovim.io/) is my primary code editor. The configuration is written in Lua and is highly customized for data analysis with the following features:

#### Key Plugins for Data Analysis

-   **REPL Integration (`iron.nvim`):** Seamlessly interact with a Python REPL, sending lines or blocks of code from the editor to the REPL. This is essential for iterative data exploration and analysis.
-   **LSP (`lspconfig`, `mason.nvim`):** Full-featured Language Server Protocol support for Python (`pyright`), providing code intelligence features like completion, go-to-definition, hover documentation, and diagnostics.
-   **Completion (`nvim-cmp`):** Fast and extensible autocompletion engine.
-   **Syntax Highlighting (`nvim-treesitter`):** Advanced syntax highlighting and code parsing for better code comprehension.
-   **Fuzzy Finding (`telescope.nvim`):** Quickly find files, buffers, and more.

#### Other Notable Plugins

-   **Plugin Manager (`lazy.nvim`):** A modern and fast plugin manager for Neovim.
-   **UI Enhancements:**
    -   `alpha-nvim`: A fancy dashboard.
    -   `lualine.nvim`: A feature-full and fast statusline.
    -   `bufferline.nvim`: A nice tabline.
    -   `nvim-tree.lua`: A file explorer.
    -   `dracula.nvim`: The Dracula theme.
-   **Git Integration:**
    -   `gitsigns.nvim`: Git decorations in the sign column.
    -   `lazygit.nvim`: A terminal UI for git.
-   **Formatting and Linting:** Code formatting and linting to ensure code quality.
-   **Session Management (`auto-session`):** Automatically save and restore sessions.

## Installation

To use these dotfiles, you can clone this repository and symlink the configuration files to the appropriate locations in your home directory.

**Note:** This is a personal setup, so you might need to adapt it to your own needs and install the necessary dependencies (e.g., fonts, plugins, language servers).
