ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="Simple"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)
unalias lt # we need `lt` for https://github.com/localtunnel/localtunnel

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init - 2> /dev/null)" && RPROMPT+='[🐍 $(pyenv version-name)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace

# Basic Aliases
alias pd='pwd'
alias c='clear'
alias r='rake'
alias nf='mkdir -p'
alias new='touch'
alias rl='exec zsh'
alias go='cd'
alias nz='nano ~/.zshrc'
alias del='trash'
alias et='osascript -e "tell application \"Finder\" to empty trash"'

# File Aliases
alias dt="cd ~/Desktop"
alias dl="cd ~/Downloads"
alias doc='cd ~/Documents'

# Code Aliases
alias html='touch index.html'
alias css='touch styles.css'
alias js='touch script.js'
alias py='touch script.py'
alias rb='touch script.rb'
alias env='touch .env'
alias java='touch Main.java'
alias ccc='touch main.c'
alias cpp='touch main.cpp'
alias sh='touch script.sh'
alias txt='touch file.txt'
alias md='touch README.md'
alias npm='npm install'
alias gem='gem install'
alias pip='pip3 install'
alias brew='brew install'
alias vs='code .'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gco='git checkout'
alias gl='git log'
alias gpl='git pull'
alias gpp='git pull --prune'
alias gr='git remote'
alias grv='git remote -v'
alias gh='git push'
alias gpom='git push origin master'
alias gpl='git pull'
alias grh='git reset --hard'
alias gm='git merge'
alias grb='git rebase'
alias gcl='git clone'
alias gsta='git stash'
alias gf='git fetch'
alias grm='git rm'

# Website Aliases
alias google='open https://www.google.com/'
alias gpt='open https://chat.openai.com/'
alias docs='open https://ruby-doc.org/3.2.2/'
alias yt='open https://www.youtube.com/'
alias kitt='open https://kitt.lewagon.com/camps/0'
alias fonts='open https://fonts.google.com/'
alias colorhunt='open https://colorhunt.co/'
alias mdn='open https://developer.mozilla.org/en-US/'


run() {
    if [ $# -eq 0 ]; then
        echo "No arguments supplied. Please provide a file to run."
        return 1
    fi

    local file="$1"
    local extension="${file##*.}"

    case $extension in
        "py")
            python3 $file
            ;;
        "rb")
            ruby $file
            ;;
        "js")
            node $file
            ;;
        "java")
            javac $file && java ${file%.*}
            ;;
        "pl")
            perl $file
            ;;
        "php")
            php $file
            ;;
        "swift")
            swift $file
            ;;
        "go")
            go run $file
            ;;
        "r")
            Rscript $file
            ;;
        "sh")
            bash $file
            ;;
        *)
            echo "Unsupported file type: .$extension"
            return 1
            ;;
    esac
}
