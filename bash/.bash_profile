export HISTIGNORE="run_last*"

# install fzf with 
# sudo apt install fzf
# keybindings activated with
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
elif command -v fzf >/dev/null 2>&1; then
    # version newer than 0.48.0 have this
    eval "$(fzf --bash)"
fi

# atuin
# need bash-preexec to get sync to work after each command
# curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
if [ -f "${HOME}/dotfiles/atuin-server/.env" ]; then
    source "${HOME}/dotfiles/atuin-server/.env"
fi
if [ -f "${HOME}/.atuin/bin/env" ]; then
    source "${HOME}/.atuin/bin/env"
    [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
    eval "$(atuin init bash)"
    echo "Loaded atuin!"
fi

if [ -f  /usr/share/autojump/autojump.sh ]; then
    . /usr/share/autojump/autojump.sh
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

#####################################################
#                  Custom promt
#####################################################
# prompt
FMT_BOLD="\[\e[1m\]"
FMT_DIM="\[\e[2m\]"
FMT_RESET="\[\e[0m\]"
FMT_UNBOLD="\[\e[22m\]"
FMT_UNDIM="\[\e[22m\]"
FG_BLACK="\[\e[30m\]"
FG_BLUE="\[\e[34m\]"
FG_CYAN="\[\e[36m\]"
FG_GREEN="\[\e[32m\]"
FG_GREY="\[\e[37m\]"
FG_MAGENTA="\[\e[35m\]"
FG_RED="\[\e[31m\]"
FG_WHITE="\[\e[97m\]"
BG_BLACK="\[\e[40m\]"
BG_BLUE="\[\e[44m\]"
BG_CYAN="\[\e[46m\]"
BG_GREEN="\[\e[42m\]"
BG_MAGENTA="\[\e[45m\]"
BG_RED="\[\e[41m\]"

parse_git_bg() {
        [[ $(git status -s 2> /dev/null) ]] && echo -e "\e[43m" || echo -e "\e[42m"
}

parse_git_fg() {
        [[ $(git status -s 2> /dev/null) ]] && echo -e "\e[33m" || echo -e "\e[32m"
}

# Start of prompt before
PS1="\n${FG_BLUE}╭─" # begin arrow to prompt
# PS1+="${FG_MAGENTA}${BG_MAGENTA}${FG_CYAN}${FMT_BOLD} ${FG_WHITE}\u${FMT_UNBOLD} " # username container
PS1+="${FG_MAGENTA}${BG_MAGENTA}${FG_CYAN}${FMT_BOLD} ${FG_WHITE}\u@\h${FMT_UNBOLD} " # username container
PS1+="${FG_MAGENTA}${BG_BLUE} ${FG_GREY}\w " # DIRECTORY container
PS1+="${BG_CYAN} ${FG_BLACK}${FMT_BOLD}${FG_WHITE}" # begin FILES container
PS1+="Folders: \$(find . -mindepth 1 -maxdepth 1 -type d | wc -l) " # print number of folders
PS1+="Files: \$(find . -mindepth 1 -maxdepth 1 -type f | wc -l) " # print number of files
PS1+="Symlinks: \$(find . -mindepth 1 -maxdepth 1 -type l | wc -l) " # print number of symlinks
PS1+="${FMT_UNBOLD}${FMT_RESET}${FG_CYAN}"
# Just commented when using bash-git-prompt
PS1+="\$(git branch 2> /dev/null | grep '^*' | colrm 1 2 | xargs -I BRANCH echo -n \"" # check if git branch exists
PS1+="\$(parse_git_bg) " # end FILES container / begin BRANCH container
PS1+="${FG_BLACK} BRANCH " # print current git branch
PS1+="${FMT_RESET}\$(parse_git_fg)\")\n" # end last container (either FILES or BRANCH)
PS1+="${FG_BLUE}╰ " # end arrow to prompt
PS1+="${FG_WHITE}[\$(date +%H:%M:%S)] "
PS1+="${FG_CYAN}\\$ " # print prompt
PS1+="${FMT_RESET}"

# folder name as terminal name. Text in between ; and \a
PS1=$PS1'\[\e]2;\w\a\]'
# if you want machine name as well, add \h
PS1=$PS1'\[\e]2;\h: \w\a\]' 

export PS1

#####################################################
#                  bash modification
#####################################################
# modify and parse the history every time you use/update it it
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# up/down search up and down history with what you wrote
# bindkey "\e[A" history-search-backward  
# bindkey "\e[B" history-search-forward


#####################################################
#                     EXPORT
#####################################################
# local software
export PATH=${PATH}:~/programs
export PATH=${PATH}:~/.local/bin/

export TERM=xterm

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=2000000

# https://github.com/keybase/keybase-issues/issues/2798
# if needed, used with signed commits, i.e. needed for gpg with git
export GPG_TTY=$(tty)

# xmodmap -e 'keycode 65 = space'
