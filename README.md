# homegit-wsl2

## Initial setup

```bash
git init --bare $HOME/.homegit
alias homegit='GIT_DIR=$HOME/.homegit/ GIT_WORK_TREE=$HOME git'
homegit config --local status.showUntrackedFiles no
homegit remote add origin git@github.com:seguri/homegit-wsl2.git
homegit add README.md
homegit commit -m 'Initial commit'
homegit push
```

## See also

- The first [repo][1] I created with this technique

[1]: https://github.com/seguri/homegit

