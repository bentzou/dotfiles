# dotfiles

Shell configuration for bash, git, ssh, tmux, and vim.

## Quickstart

1. Clone the repo:

   ```
   git clone git@github.com:bentzou/dotfiles.git
   ```

2. Source the setup script:

   ```
   . setuphome
   ```

3. Initialize:

   ```
   theresnoplacelikehome
   ```

This symlinks config files, sets bash as the default shell, sources the bashrc, and installs vim plugins.

## What's included

### Bash

- **bashrc** - Main shell config: aliases, functions, environment variables, and imports
- **functions** - Utility functions (`join`, `split`, `lines`, `indent`, `path`, `backup`, `swap`, etc.)
- **completions** - Tab completions for git, docker, ssh, make, maven, java, and yarn
- **inputrc** - Readline config (case-insensitive completion, show-all-if-ambiguous, Shift-Tab cycling)
- **ps1** - Smart prompt showing git branch (red for main/master, green for feature branches), virtualenv, and working directory
- **postcd** - Auto-switches Node versions via nvm when entering directories with `.nvmrc`

### Git

- **gitconfig** - Aliases (`co`, `br`, `st`, `ci`, `unstage`, `prune`), auto push setup, user config

### SSH

- **sshconfig** - Compression, multiplexing, persistent connections, agent forwarding, keep-alive

### Tmux

- **tmuxconf** - `C-Space` prefix, vi-mode, vim-like pane navigation/splitting/resizing

### Vim

- **vimrc** - Space as leader, `jk` to escape, dark theme, code folding, persistent undo, NERDTree, CtrlP, fugitive, Pathogen

### Modules (git submodules)

- **[uptown](https://github.com/bentzou/uptown)** - Navigate up/down your directory hierarchy with Alt+Arrow keys
- **[backtothefolder](https://github.com/bentzou/backtothefolder)** - Navigate forward/backward through cd history with Shift+Alt+Arrow keys
- **[flash](https://github.com/bentzou/flash)** - Fast find and grep with context-aware exclusions (node_modules, .git, venv, etc.)

### Apps

- **apps/ghostty** - Ghostty terminal config (macOS)
- **apps/tilix.dconf** - Tilix terminal emulator settings (Linux)

### Other

- **pg** - Quick PostgreSQL connection helper using `~/.pgpass`

## Aliases

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `c <repo>` | `cd ~/Code/<repo>` (with tab completion) |
| `f <name>` | Find file by name |
| `g <pattern>` | Grep recursively |
| `ga` | `git add` |
| `gb` | `git branch --sort=-committerdate` |
| `gc` | `git checkout` |
| `gd` | `git diff` |
| `gs` | `git status` |
| `gl` | `git log` (one-line graph) |
| `ll` | `ls -alh` |
| `lr` | `ls -alhtr` (by time, reversed) |

## Docker support

Set up dotfiles inside a running container:

```
theresnoplacelikedocker <container_name>
```
