export WIN_HOME="$(wslpath "$(powershell.exe '$env:USERPROFILE')")"

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
