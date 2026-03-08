EDITOR=vim
VOLTA_HOME="$HOME/.volta"
#WIN_HOME="$(wslpath "$(powershell.exe '$env:USERPROFILE' | tr -d '\r')")"
WIN_HOME="/mnt/c/Users/msegu"
JOHNNY_DECIMAL_HOME="$WIN_HOME/Sync/Johnny.Decimal"

if [ -f "$HOME/.bashrc" ]; then
. "$HOME/.bashrc"
fi

if [ -d "$VOLTA_HOME" ]; then
    PATH="$VOLTA_HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# delete duplicates from PATH
PATH=$(echo "$PATH" | awk -F: '{for(i=1;i<=NF;i++){ if (!seen[$i]++) { out=out $i ":" } } print substr(out,0,length(out)-1)}')

