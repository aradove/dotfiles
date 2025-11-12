# ls color by default
# https://superuser.com/questions/665274/how-to-make-ls-color-its-output-by-default-without-setting-up-an-alias
## Colorize the ls output ##
alias ls='ls --color=auto'

## Use a long listing format ##
alias ll='ls -la'

## Show hidden files ##
alias l.='ls -d .* --color=auto'

# https://stackoverflow.com/questions/9969414/always-include-first-line-in-grep
grep1() { awk -v pattern="${1:?pattern is empty}" 'NR==1 || $0~pattern' "${2:-/dev/stdin}"; }

run_last() {
  if [[ -z "$1" || "$1" -le 0 ]]; then
    echo "Usage: run_last <number>"
    return 1
  fi

  local count=$1
  local self_name="run_last"
  local histfile="${HISTFILE:-$HOME/.bash_history}"

  # Read from the history file, reverse it, filter out self, and get the last N
  local cmds=()
  while IFS= read -r line; do
    if [[ "$line" != *"$self_name"* ]]; then
      cmds+=("$line")
    fi
    if [[ ${#cmds[@]} -ge $count ]]; then
      break
    fi
  done < <(tac "$histfile")

  # Reverse the array to run in original order
  for ((i=${#cmds[@]}-1; i>=0; i--)); do
    echo "Running: ${cmds[i]}"
    eval "${cmds[i]}"
  done
}

# Aliases
alias rl='run_last'
alias cat='bat --paging=never'
alias findpkg='apt-cache search'
#function findinstall {
#      PACKAGE_NAME=$(apt-cache search $1 | fzf | cut --delimiter=" " --fields=1)
#      if [ "$PACKAGE_NAME" ]; then
#          echo "Installing $PACKAGE_NAME"
#          sudo apt install $PACKAGE_NAME
#      fi
# }
alias searchpkg='apt-cache search'
alias findpkgversion='apt-cache policy'
alias searchpkgversion='apt-cache policy'
alias findfile='find . -name'
findline() {
    rg . | fzf | cut -d "$@" -f 1 # sudo apt install ripgrep
}
alias mountdrive='rclone --vfs-cache-mode writes mount OneDrive:  ~/OneDrive &'
alias debinstall='sudo dpkg -i'

# find users
alias listusers="awk -F':' '{ print \$1}' /etc/passwd"

# bazel aliases
alias bazelfix='buildifier --warnings=all -lint fix -mode fix '
#alias bazel='bazelisk'
bazeldeps() {
  bazel query --keep_going --notool_deps --noimplicit_deps "deps(${1})" --output graph
}
vbazeldeps() {
  xdot <(bazel query --keep_going --notool_deps --noimplicit_deps "deps(${1})" --output graph)
}

# Use cheat.sh
cheat() {
  local cheatarguments=""
  local delimiter=""
  for arg in "$@"; do
        cheatarguments="${cheatarguments}${delimiter}${arg}"
        local delimiter="%20"
  done
  # Ask cheat.sh website for details about a Linux command.
  curl -m 10 "http://cheat.sh/${cheatarguments}" 2>/dev/null || printf '%s\n' "[ERROR] Something broke"
}

loghere() {
  "$@" 2>&1 | tee "loghere.log";
}

alias fpr="gh pr list -L300 | fzf --ansi --preview 'gh pr diff {+1} | delta' | cut -f 1 | xargs gh pr checkout"

# fbr - checkout git branch (including remote branches), sorted by most recent commit, limit 30 last branches
fbr() {
  local branches branch
  branches=$(git for-each-ref --count=200 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

alias tf="testfinder | fzf -i"

alias gitrebase='git pull --rebase origin master'

rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

function cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

androidreboot() {
	adb reboot
	adb wait-for-device
	adb root
	sleep 1
	adb remount
	sleep 1
	adb shell setenforce 0
}

androidroot() {
	adb root
	sleep 1
	adb remount
	sleep 1
	adb shell setenforce 0
}


openandroidports() {
	adb forward tcp:5001 tcp:5001
	adb forward tcp:5002 tcp:5002
	adb reverse tcp:5004 tcp:5004
}

androidwake()
{
	adb shell input keyevent KEYCODE_WAKEUP
}

androidhome()
{
	adb shell input keyevent KEYCODE_HOME
}

androidsettings()
{
	adb shell am start com.android.settings; adb shell am force-stop com.sony.xrhomeapp
}

b() ( spd-say 'done'; zenity --info --text "$(date);$(pwd)" & )


# NETWORKING
alias portsused='sudo netstat -tulpn | grep LISTEN'
alias showports='netstat -lnptu'
alias showlistening='lsof -i -n | egrep "COMMAND|LISTEN"'

# fix rdp
alias fixrdp="loginctl unlock-session $(loginctl list-sessions | awk '/seat/ {print $1}')"

# Docker
# Execute a command in the latest container
docker-exec-latest() {
  docker exec "$(docker ps -lq)" "$@"
}

# Logs of the latest container
docker-logs-latest() {
  docker logs "$(docker ps -lq)" "$@"
}

# Stop the latest container
docker-stop-latest() {
  docker stop "$(docker ps -lq)"
}

# Remove the latest container
docker-rm-latest() {
  docker rm "$(docker ps -lq)"
}

# Inspect the latest container
docker-inspect-latest() {
  docker inspect "$(docker ps -lq)"
}

# Shell into the latest container
docker-sh-latest() {
  docker exec -it "$(docker ps -lq)" sh
}

# Bash into the latest container
docker-bash-latest() {
  docker exec -it "$(docker ps -lq)" bash
}
