# History settings
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY_TIME # Commands are written to hist file right away

# Fine-tune vi mode
bindkey -v
export KEYTIMEOUT=1 # Faster switch to normal vi mode

# Plugins
autoload -U colors && colors
autoload edit-command-line
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

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

# Edit command line in an editor, useful for safe copy-paste
zle -N edit-command-line
bindkey -M vicmd V edit-command-line

# Make backspace and delete behave in normal mode
bindkey -v '^?' backward-delete-char
bindkey "\e[3~" delete-char

# History search brings up fzf
fzf-history-widget() {
    BUFFER=$(tac $HISTFILE | awk '!seen[$0]++' | fzf);}
zle     -N   fzf-history-widget
bindkey -M vicmd '/' fzf-history-widget

# Aliases
alias ll='ls -lh --color'
alias ykcode='ykman oath code $(ykman oath list | fzf)'
alias hubi='hub issue show $(hub issue | fzf | cut -c 5- | cut -d " " -f1)'
##################################################
# Virtualenvwrapper

# ENV SETTINGS
export VISUAL="nvim"
export EDITOR="nvim"
PATH=$PATH:/usr/share/git/diff-highlight/
PATH=$PATH:~/Projekty/sk-backend/devtools:~/Projekty/sk-backend/scripts:~/Projekty/sk-backend/deliveries
PATH=$PATH:/home/oskar/.cargo/bin

# Use GPG as SSH Agent
SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh;
##################################################
# Virtualenvwrapper
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

export PYTHONPATH=$PYTHONPATH:~/Projekty/sk-backend/python
export MYPYPATH=$MYPYPATH:~/Projekty/sk-backend/python
export SPACEKNOW_CLOUD=gcloud
export SPACEKNOW_PLATFORM=devel

# Completions
source <(kubectl completion zsh)
