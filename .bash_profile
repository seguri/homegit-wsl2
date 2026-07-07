CONTEXT7_API_KEY="$(timeout 10 op.exe read 'op://krwjfey5g7p5jhwltepmsjhbcq/v5zb6nlmfih5gjcg72t6t4ceki/credential' 2>/dev/null || true)"
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

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
