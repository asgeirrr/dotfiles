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
MANJARO_SYNTAX_PLUGIN_PATH=/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [[ -f $MANJARO_SYNTAX_PLUGIN_PATH ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
    # Works on Fedora
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
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
alias ykcode='ykman oath accounts code $(ykman oath accounts list | fzf)'
alias hubi='hub issue show $(hub issue | fzf | cut -c 5- | cut -d " " -f1)'
alias dexec='docker exec -it $(docker ps | tail -n +2 | sed "s/[[:space:]]\+/:/g" | cut -d":" -f1,2 | fzf | cut -d ":" -f1) bash'
alias car='conda activate rir'
alias dcp='docker compose'
alias pcp='podman compose'
alias switchcards='rm ~/.gnupg/private-keys-v1.d/BBCCC06A5324A6E6680E7D9AEDBB675A44FB56F8.key ~/.gnupg/private-keys-v1.d/6F78487DCDF7664CB19CA1F336A2DDB1AA898DEF.key ~/.gnupg/private-keys-v1.d/9DA10D269C50F2F761FA5AD8053E87E073FB20A3.key && gpg --card-status'
alias vim="nvim"

# ENV SETTINGS
export VISUAL="nvim"
export EDITOR="nvim"
PATH=$PATH:/usr/share/git/diff-highlight/
PATH=$PATH:~/Projekty/sk-backend/devtools:~/Projekty/sk-backend/scripts:~/Projekty/sk-backend/deliveries
PATH=$PATH:/home/oskar/.cargo/bin
export BUILDAH_FORMAT=docker # Make podman work with docker-style Dockerfiles

# Use GPG as SSH Agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
export GPG_TTY=$(tty)

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# Completions
source <(kubectl completion zsh)

# Rossum
export GITLAB_LOGIN_NAME=oskar@rossum.ai
export PYPI_USERNAME=$GITLAB_LOGIN_NAME
export PYPI_PASSWORD=$GITLAB_PERSONAL_TOKEN
export POSTGRES_PORT=5432
export RABBITMQ_PORT=5672
export MINIO_PORT=9000
export MINIO_CONSOLE_PORT=9001
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# r8-utils
export R8TEAM=rir
export R8PATH=/home/oskar/.rossum
if [ -f "${R8PATH}/r8-utils/scripts/inlined/functions.sh" ]; then
  . "${R8PATH}/r8-utils/scripts/inlined/functions.sh"
fi

# Wayland
export MOZ_ENABLE_WAYLAND=1
