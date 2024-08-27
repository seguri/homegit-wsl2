EDITOR=vim
VOLTA_HOME="$HOME/.volta"
WIN_HOME="$(wslpath "$(powershell.exe '$env:USERPROFILE' | tr -d '\r')")"
JOHNNY_DECIMAL_HOME="$WIN_HOME/OneDrive/Johnny.Decimal"

if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi

if [ -d "$VOLTA_HOME" ]; then
    PATH="$PATH:$VOLTA_HOME/bin"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/bin" ]; then
    PATH="$PATH:$HOME/bin"
fi

# delete duplicates from PATH
PATH=$(echo "$PATH" | awk -F: '{for(i=1;i<=NF;i++){ if (!seen[$i]++) { out=out $i ":" } } print substr(out,0,length(out)-1)}')
