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

### Agents

- **agents/claude/** - Claude Code starter settings, instructions, and agent definitions
- **agents/codex/** - Codex starter settings

### Apps

- **apps/ccstatusline/** - Claude Code status-line renderer settings
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

## AI tool configuration

Both tools live under `agents/`. Tracked files contain starter preferences;
full live settings are kept in ignored `local/` directories:

| Tool | Tracked starter | Ignored live config | Symlink |
|------|-----------------|---------------------|---------|
| Claude | `agents/claude/settings.json` | `agents/claude/local/settings.json` | `~/.claude/settings.json` |
| Codex | `agents/codex/config.toml` | `agents/codex/local/config.toml` | `~/.codex/config.toml` |

Setup preserves an existing live config on the first run, or copies the starter
on a fresh machine. Later runs preserve the ignored local file. This keeps
account settings, generated organization context, local runtime paths, and
project trust decisions out of Git, including settings written by either app.
The local directories use mode 700 and new local config files use mode 600.

```bash
source setuphome
init_claude
init_codex
```

Claude instructions and agent definitions remain directly symlinked to tracked
files. Credentials, sessions, and plugin caches stay in each tool's home folder.

To change live settings, edit the application's config or its ignored local
file. To share a preference across machines, copy only that preference into the
tracked starter. Starter changes do not overwrite an existing local config.
Do not force-add `agents/*/local/` to Git.
