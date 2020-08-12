#
# .zshrc
#
# @author Jeff Geerling
#

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install oh-my-zsh..
export ZSH="/Users/dgunn/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Source p10k theme.
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}$ "

# Enable plugins.
plugins=(git brew kubectl cp command-not-found git-extras gnu-utils history pip python screen ssh-agent docker docker-compose zsh-completions zsh-wakatime taskwarrior zsh-autosuggestions)

# Custom $PATH with extra locations.
export PATH=$HOME/Library/Python/2.7/bin:$PATH
export PATH=/usr/local/opt/libpq/bin:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$HOME/bin:$HOME/go/bin:/usr/local/git/bin:$HOME/.composer/vendor/bin:$PATH

function setupKubeConfigs() {
  KUBECONFIG=""
  for f in $(ls $HOME/.kube/configs); do
   export KUBECONFIG=$KUBECONFIG:$HOME/.kube/configs/$f;
  done
}


setupKubeConfigs

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

# Completions.
autoload -Uz compinit && compinit
# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Git upstream branch syncer.
# Usage: gsync master (checks out master, pull upstream, push origin).
function gsync() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a branch."
     return 0
 fi

 BRANCHES=$(git branch --list $1)
 if [ ! "$BRANCHES" ] ; then
    echo "Branch $1 does not exist."
    return 0
 fi

 git checkout "$1" && \
 git pull upstream "$1" && \
 git push origin "$1"
}


# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# Ask for confirmation when 'prod' is in a command string.
prod_command_trap () {
 if [[ $BASH_COMMAND == *prod* ]]
 then
   read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
   if [[ $REPLY =~ ^[Yy]$ ]]
   then
     echo -e "\nRunning command \"$BASH_COMMAND\" \n"
   else
     echo -e "\nCommand was not run.\n"
     return 1
   fi
 fi
}

listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

#shopt -s extdebug
#trap prod_command_trap DEBUG
