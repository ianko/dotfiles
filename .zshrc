################################################################################
# ANTIGEN + OH-MY-ZSH
################################################################################
source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Enhances the terminal environment with 256 colors
antigen bundle chrissicool/zsh-256color

# Fish shell-like syntax highlighting for Zsh.
antigen bundle zsh-users/zsh-syntax-highlighting

# Prevents any code from actually running while pasting, so you have a chance to
# review what was actually pasted before running it.
antigen bundle safe-paste

# Generate tab completion for any shell command by specifying its usage in a
# familiar manpage-like format
antigen bundle compleat

# Adds completions for the Elixir's Mix build tool.
antigen bundle mix

# Fish-like fast/unobtrusive autosuggestions for zsh.
# It suggests commands as you type based on history and completions.
antigen bundle zsh-users/zsh-autosuggestions

# Additional completion definitions for Zsh.
antigen bundle zsh-users/zsh-completions src

# This is a clean-room implementation of the Fish shell's history search
# feature, where you can type in any part of any command from history and then
# press chosen keys, such as the UP and DOWN arrows, to cycle through matches.
antigen bundle zsh-users/zsh-history-substring-search

# This plugin uses the command-not-found package for zsh to provide suggested
# packages to be installed if a command cannot be found.
antigen bundle command-not-found

# Extracts any archive. USAGE:
#   extract <filename>
antigen bundle extract

# Helps remembering those shell aliases and Git aliases you once defined.
antigen bundle djui/alias-tips

# Aliases cheatsheet. USAGE:
#   acs
#   acs <keyword>
antigen bundle aliases

# Adds completion for the Kubernetes cluster manager, as well as some aliases for
# common kubectl commands. 
#   USAGE: see https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
antigen bundle kubectl

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

################################################################################
# STARTUP AND CONFIGS
################################################################################

# ASDF
. $(brew --prefix asdf)/asdf.sh

################################################################################
# ALIASES
################################################################################
