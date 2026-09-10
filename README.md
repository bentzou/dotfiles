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

Both tools live under `agents/`. Claude uses a tracked starter and an ignored
live config. Codex uses two native configuration tiers:

| Tool / tier | Repository file | Installed path |
|-------------|-----------------|----------------|
| Claude starter | `agents/claude/settings.json` | Copied only when no live config exists |
| Claude local | `agents/claude/local/settings.json` (ignored) | `~/.claude/settings.json` |
| Codex shared | `agents/codex/config.toml` (tracked) | `/etc/codex/config.toml` |
| Codex local | `agents/codex/local/config.toml` (ignored) | `~/.codex/config.toml` |

Codex loads shared defaults first, then applies local overrides. Shared settings
contain portable preferences; private paths, project trust, account settings,
and machine-managed integrations stay local. Both installed Codex paths are
symlinks, so pulling shared changes updates the defaults for new sessions.

`init_codex` requires administrator access to install the system symlink on a
new laptop. An existing system config is preserved and setup stops rather than
overwriting it. This system tier applies to all users on the machine and points
into this checkout, which must remain available and readable.

Setup preserves existing user settings; on a fresh laptop it creates an empty
local override file. Existing preferences in the local file still override the
shared defaults. The local directories use mode 700 and config files mode 600.

To share a setting changed through Codex, manually move its key from the local
config to `agents/codex/config.toml`, then review and commit the diff. Remove the
local copy so future shared updates take effect. There is no automatic sync.

```bash
source setuphome
init_claude
init_codex
```

Claude's global `CLAUDE.md` instructions remain directly symlinked to the tracked
file. Agent definitions use the same starter/local pattern: tracked templates
are in `agents/claude/agents/`, while live definitions are symlinked to ignored
`agents/claude/local/agents/` files. This preserves project-specific agent context
locally. Credentials, sessions, and plugin caches stay in each tool's home folder.

To change live settings, edit the application's config or its ignored local
file. To share a preference across machines, copy only that preference into the
tracked starter. Starter changes do not overwrite an existing local config.
Do not force-add `agents/*/local/` to Git.
