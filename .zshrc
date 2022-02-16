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

alias tree='tree -a -I .git'

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

################################################################################
# ENVIRONMENT VARIABLES
################################################################################

# Set iTerm as the default terminal.
TERM_PROGRAM="iTerm.app"

# Elixir / Erlang
ERLANG_OPENSSL_PATH="/usr/local/opt/openssl"
ERL_AFLAGS="-kernel shell_history enabled"
KERL_BUILD_DOCS=yes
NO_PROXY=localhost,127.0.0.1,LOCALHOST

# Flutter
CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
PATH=$HOME/.flutter/bin:$PATH
PATH=$HOME/.pub-cache/bin:$PATH

# Ruby / GEM
GEM_HOME=$HOME/.gem
PATH=$GEM_HOME/bin:$PATH

# Kubernetes
KUBECONFIG=~/.kube/config:$(ls -d ~/.kube/config.d/* | python -c 'import sys; print(":".join([l.strip() for l in sys.stdin]).strip())')

# Podman
DOCKER_HOST='unix:///tmp/podman.sock'

# Others
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.kubectl-plugins:$PATH
