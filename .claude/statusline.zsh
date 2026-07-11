#!/bin/zsh
# Claude Code status line (zsh)
# Format: ▓░░░░░░░░░ 8% [CAVEMAN] suffix | ▓▓▓▓░░░░░░ 42% 2h left | ~/git/repo  branch
#   first bar  = context fill of this conversation
#   second bar = 5h rate-limit window usage, global across sessions, + time to reset
#   both traffic-light colored: green < warn <= yellow < crit <= red (per-bar vars)
# Bar/dir/branch from https://www.tyleo.com/blog/love-letter-to-the-claude-code-docs
# Caveman badge inlined from the caveman plugin's caveman-statusline.sh —
# settings must not point into ~/.claude/plugins/cache/<hash>/, the hash
# dir changes on plugin update and the path goes stale.

zmodload zsh/datetime 2>/dev/null

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')

CYAN=$'\033[96m'
GREEN=$'\033[92m'
YELLOW=$'\033[93m'
RED=$'\033[91m'
ORANGE=$'\033[38;5;172m'
RESET=$'\033[0m'

# Traffic-light thresholds, per bar. Context numbers assume the 1M window
# ([1m] model): Claude Code starts nagging around 300k tokens left (~70%),
# so red lands just before that. 5h bar is budget burn — later is fine.
CTX_WARN=50
CTX_CRIT=65
LIMIT_WARN=80
LIMIT_CRIT=90

bar_color() {
    local pct=$1 warn=$2 crit=$3
    if (( pct >= crit )); then
        print -rn -- "$RED"
    elif (( pct >= warn )); then
        print -rn -- "$YELLOW"
    else
        print -rn -- "$GREEN"
    fi
}

build_bar() {
    local pct=$1 bar=""
    (( pct < 0 )) && pct=0
    (( pct > 100 )) && pct=100
    repeat $(( pct / 10 )) bar+='▓'
    repeat $(( 10 - pct / 10 )) bar+='░'
    print -r -- "$bar"
}

# Context bar — this conversation only
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [[ -n "$used_pct" ]]; then
    pct_int=$(printf '%.0f' "$used_pct")
    context_part="$(bar_color $pct_int $CTX_WARN $CTX_CRIT)$(build_bar $pct_int) ${pct_int}%${RESET}"
else
    context_part="${GREEN}░░░░░░░░░░ 0%${RESET}"
fi

# 5h rate-limit window — absent on auth types without rate_limits, then hidden
limit_part=""
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [[ -n "$five_pct" ]]; then
    five_int=$(printf '%.0f' "$five_pct")
    resets_at=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
    resets_at=${resets_at%%.*}
    left=""
    if [[ -n "$resets_at" && -n "$EPOCHSECONDS" ]]; then
        secs=$(( resets_at - EPOCHSECONDS ))
        if (( secs >= 3600 )); then
            left=" $(( secs / 3600 ))h left"
        elif (( secs >= 0 )); then
            left=" $(( secs / 60 ))m left"
        fi
    fi
    limit_part=" | $(bar_color $five_int $LIMIT_WARN $LIMIT_CRIT)$(build_bar $five_int) ${five_int}%${left}${RESET}"
fi

# Directory
display_dir=$cwd
[[ $cwd == $HOME* ]] && display_dir="~${cwd#$HOME}"

# Git branch (skip optional locks to avoid contention)
branch_part=""
if git -C "$cwd" -c core.fsmonitor= rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.fsmonitor= symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" -c core.fsmonitor= rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        branch_icon=$''
        branch_part=" ${CYAN}${branch_icon} ${branch}${RESET}"
    fi
fi

# Caveman badge. Refuse symlinks and strip control bytes: a local attacker
# could otherwise point the flag at an arbitrary file and have its bytes
# (including ANSI escape sequences) rendered to the terminal on every update.
caveman_part=""
flag="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
if [[ -f "$flag" && ! -L "$flag" ]]; then
    mode=$(head -c 64 "$flag" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')
    case "$mode" in
        off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
            if [[ "$mode" == "full" ]]; then
                caveman_part=" ${ORANGE}[CAVEMAN]${RESET}"
            else
                caveman_part=" ${ORANGE}[CAVEMAN:${(U)mode}]${RESET}"
            fi
            # Savings suffix pre-rendered by /caveman-stats; absent until first run.
            if [[ "${CAVEMAN_STATUSLINE_SAVINGS:-1}" != "0" ]]; then
                savings_file="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-statusline-suffix"
                if [[ -f "$savings_file" && ! -L "$savings_file" ]]; then
                    savings=$(head -c 64 "$savings_file" 2>/dev/null | tr -d '\000-\037')
                    [[ -n "$savings" ]] && caveman_part+=" ${ORANGE}${savings}${RESET}"
                fi
            fi
            ;;
    esac
fi

print -r -- "${context_part}${caveman_part}${limit_part} | ${GREEN}${display_dir}${RESET}${branch_part}"

