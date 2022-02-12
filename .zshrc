################################################################################
# PREZTO
################################################################################

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

################################################################################
# STARTUP AND CONFIGS
################################################################################

# Reverse history search
bindkey "^R" history-incremental-search-backward

# ASDF
. $(brew --prefix asdf)/asdf.sh

################################################################################
# Autocomplete
################################################################################
fpath=(/usr/local/share/zsh-completions $fpath)

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

if brew command command-not-found-init > /dev/null 2>&1; then
  eval "$(brew command-not-found-init)";
fi


################################################################################
# ALIASES
################################################################################

# Kubectl helpers
alias k=kubectl