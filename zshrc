# History settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY_TIME # Commands are written to hist file right away

# Fine-tune vi mode
bindkey -v
export KEYTIMEOUT=1 # Faster switch to normal vi mode

# Plugins
autoload -Uz compinit && compinit
autoload -Uz promptinit && promptinit
autoload -U colors && colors

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# PROMPT SETTINGS
PROMPT='%F{blue}%~ %B>%b %f'
# Color-coding of vi modes
function zle-line-init zle-keymap-select {
    NORMAL_MODE="%{$fg[blue]%}[% NORMAL]% %{$reset_color%}"
    INSERT_MODE="%{$fg[green]%}%}[% INSERT]% %{$reset_color%}"
    RPROMPT="${${KEYMAP/vicmd/$NORMAL_MODE}/(main|viins)/$INSERT_MODE}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# History search brings up fzf
fzf-history-widget() {
    BUFFER=$(tac $HISTFILE | awk '!seen[$0]++' | fzf);}
zle     -N   fzf-history-widget
bindkey -M vicmd '/' fzf-history-widget

# ENV SETTINGS
export VISUAL="vim"
export EDITOR="vim"
PATH=$PATH:~/Projekty/sk-backend/devtools:~/Projekty/sk-backend/scripts

# Virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export PYTHONPATH=:$PYTHONPATH # To enable running sk-research scripts from the repository root
