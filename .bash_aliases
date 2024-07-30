alias ..='cd ..'
alias homegit='git.exe --git-dir=$HOME/.homegit/ --work-tree=$HOME'
alias g=git
alias gCm='git commit --message'
alias gco='git checkout'
alias gws='git status --short'
alias j=just.exe
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
