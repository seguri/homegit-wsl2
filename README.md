# homegit-wsl2

## Initial setup

```bash
git init --bare $HOME/.homegit
alias homegit='git.exe --git-dir=$HOME/.homegit/ --work-tree=$HOME'
homegit config --local status.showUntrackedFiles no
homegit remote add origin git@github.com:seguri/homegit-wsl2.git
homegit add README.md
homegit commit -m 'Initial commit'
homegit push
```

I thought that using `alias ssh=ssh.exe` was enough to be able to push this repository to GitHub through 1Password SSH integration, but it seems I was wrong.
Using `git.exe` fixed the problem and the `homegit` alias is fixed accordingly.

## See also

- The first [repo][1] I created with this technique

[1]: https://github.com/seguri/homegit

