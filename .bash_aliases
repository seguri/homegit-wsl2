alias ..='cd ..'
alias homegit='git.exe --git-dir=$HOME/.homegit/ --work-tree=$HOME'
alias g=git
alias gCm='git commit --message'
alias gco='git checkout'
alias gwd='git diff'
alias gwdc='git diff --cached'
alias gwR='git reset --hard'
alias gwr='git reset --soft'
alias gws='git status --short'
alias j=just.exe
alias svba='source venv/bin/activate'
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

delete-duplicates-from-path() {
  export PATH=$(echo "$PATH" | awk -F: '{for(i=1;i<=NF;i++){ if (!seen[$i]++) { out=out $i ":" } } print substr(out,0,length(out)-1)}')
}

git() {
  if [[ $PWD = "$HOME" ]]; then
    command git.exe --git-dir=$HOME/.homegit/ --work-tree=$HOME "$@"
  else
    command git "$@"
  fi
}

jd() {
  cd "$(johnny-decimal.sh $@)"
}

if command -v batcat >/dev/null && [[ ! -L /usr/local/bin/bat ]]; then
  # On Ubuntu, `bat` clashes with Bakula's `bat` and has been renamed to `batcat`
  echo "Linking /usr/local/bin/bat to /usr/bin/batcat..."
  sudo ln -s $(which batcat) /usr/local/bin/bat
fi

if command -v fdfind >/dev/null && [[ ! -L /usr/local/bin/fd ]]; then
  # On Ubuntu, `fd` clashes with something already called `fd`
  echo "Linking /usr/local/bin/fd to /usr/bin/fdfind..."
  sudo ln -s $(which fdfind) /usr/local/bin/fd
fi
