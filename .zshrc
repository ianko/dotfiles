################################################################################
# Zsh for Humans
################################################################################

# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'no'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Don't start tmux.
zstyle ':z4h:' start-tmux       no

# Move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'mac'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'no'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'no'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
# zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
# zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
# zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Creates helpful shortcut aliases for many commonly used commands.
z4h load ohmyzsh/ohmyzsh/plugins/common-aliases

# Prevents any code from actually running while pasting, so you have a chance to
# review what was actually pasted before running it.
z4h load ohmyzsh/ohmyzsh/plugins/safe-paste

# Adds integration with asdf
z4h load ohmyzsh/ohmyzsh/plugins/asdf

# Adds completions for the Elixir's Mix build tool.
z4h load ohmyzsh/ohmyzsh/plugins/mix

# This plugin adds completion for CocoaPods. 
# z4h load ohmyzsh/ohmyzsh/plugins/pod

# Adds completion for the Kubernetes cluster manager, as well as some aliases for
# common kubectl commands. 
#   USAGE: see https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
z4h load ohmyzsh/ohmyzsh/plugins/kubectl

# Extracts any archive. USAGE:
#   extract <filename>
z4h load ohmyzsh/ohmyzsh/plugins/extract

# Helps list the shortcuts that are currently available based on the plugins you
# have enabled. USAGE:
#   acs
#   acs <keyword>
z4h load ohmyzsh/ohmyzsh/plugins/aliases

################################################################################
# LOAD AND CONFIG
################################################################################

# load asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

# increase file size limit
ulimit -n 10240

################################################################################
# KEY BINDINGS
################################################################################

z4h bindkey undo Ctrl+/   Shift+Tab # undo the last command line change
z4h bindkey redo Option+/           # redo the last undone command line change

z4h bindkey z4h-cd-back    Shift+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Shift+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

################################################################################
# ALIASES
################################################################################

# GitHub Copilot aliases
eval "$(gh copilot alias -- zsh)"

# Flutter w/ FVM
alias flutter="fvm flutter"
alias dart="fvm dart"

# Replace docker with podman
alias docker=podman
alias docker-compose=podman-compose

# tree (from homebrew)
alias tree='tree -a -I .git'

# fuck
eval $(thefuck --alias)

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Configure bat
# Use bat to colorize help text (--help)
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
alias cat='bat --paging=never'

################################################################################
# ENVIRONMENT VARIABLES
################################################################################

# Set iTerm as the default terminal.
export TERM_PROGRAM="iTerm.app"

# Configure bat 
# set theme (available: bat --list-themes)
export BAT_THEME="SynthWave 84"
# use bat to colorize man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Elixir / Erlang
export CC="/usr/bin/gcc -I$(brew --prefix unixodbc)/include"
export LDFLAGS="-L$(brew --prefix unixodbc)/lib"
# export ERLANG_OPENSSL_PATH="$(brew --prefix openssl@3)"
export ERLANG_OPENSSL_PATH="$(brew --prefix openssl@1.1)"
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_BUILD_DOCS=yes
export JAVAC="/usr/bin/javac"
export WX_CONFIG="/opt/homebrew/bin/wx-config"
# export KERL_CONFIGURE_OPTIONS="--with-javac=$JAVAC --with-wx-config=$WX_CONFIG"
# export KERL_CONFIGURE_OPTIONS="--with-javac=$JAVAC"
# export KERL_CONFIGURE_OPTIONS="--with-javac=$JAVAC --with-ssl=$ERLANG_OPENSSL_PATH"
export KERL_CONFIGURE_OPTIONS="--with-ssl=$ERLANG_OPENSSL_PATH --without-wx --without-javac"
export NO_PROXY=localhost,127.0.0.1,LOCALHOST

# Flutter
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export PATH=$HOME/fvm/default/bin:$PATH
export PATH=$HOME/.pub-cache/bin:$PATH

# Kubernetes
# export KUBECONFIG=~/.kube/config:$(ls -d ~/.kube/config.d/* | python -c 'import sys; print(":".join([l.strip() for l in sys.stdin]).strip())')
# export PATH=$HOME/.kubectl-plugins:$PATH

# Others

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH="/opt/homebrew/opt/openssl@3/bin":$PATH
export PATH="/usr/local/opt/sqlite/bin":$PATH
export PATH="/opt/homebrew/opt/libpq/bin":$PATH
export PATH="/opt/homebrew/opt/openjdk/bin":$PATH

################################################################################
# GIT FUNCTIONS
################################################################################

# GitHub Copilot aliases
eval "$(gh copilot alias -- zsh)"

# Enhanced git branch cleanup using GitHub CLI
git-prune() {
    echo "🧹 Cleaning up branches using GitHub CLI..."
    
    # Prune remote tracking branches
    git remote prune origin
    
    # Get merged and closed PRs, then delete their local branches
    gh pr list --state merged --limit 100 --json headRefName | \
        jq -r '.[].headRefName' | \
        while read branch; do
            if git show-ref --verify --quiet refs/heads/$branch; then
                echo "Deleting merged PR branch: $branch"
                git branch -D "$branch"
            fi
        done
    
    # Clean up branches whose remotes are gone
    git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads | \
        awk '$2 == "[gone]" {print $1}' | \
        while read branch; do
            echo "Deleting branch with deleted remote: $branch"
            git branch -D "$branch"
        done
    
    echo "✅ Branch cleanup complete!"
}

# Dry run version to see what would be deleted without actually deleting
git-prune-dry-run() {
    echo "🔍 DRY RUN - Showing what would be deleted..."
    
    echo "\n📡 Remote tracking branches that would be pruned:"
    git remote prune origin --dry-run
    
    DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main")
    echo "\n🌿 Local merged branches that would be deleted:"
    git branch --merged $DEFAULT_BRANCH | \
        grep -v "^\*" | \
        grep -v "^[[:space:]]*$DEFAULT_BRANCH$" | \
        grep -v "^[[:space:]]*main$" | \
        grep -v "^[[:space:]]*master$" | \
        grep -v "^[[:space:]]*develop$" | \
        while read branch; do
            if [[ -n "$branch" ]]; then
                echo "  Would delete: $branch"
            fi
        done
    
    echo "\n🗑️  Branches with deleted remotes that would be deleted:"
    git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads | \
        awk '$2 == "[gone]" {print "  Would delete: " $1}'
    
    echo "\n✅ This was a dry run - no branches were actually deleted"
}
