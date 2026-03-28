# ~/.bashrc

# 基础设置与别名
alias ls='ls --color=auto'
alias l='lsd -l'
alias ll='lsd -lah'
alias lt='lsd --tree'

STARSHIP_BIN="/run/current-system/sw/bin/starship"
FASTFETCH_BIN="/run/current-system/sw/bin/fastfetch"

# 如果没有 starship 时，作为 bash 的后备提示符
if [[ -n "${BASH_VERSION:-}" ]]; then
    PS1='[\u@\h \W]\$ '
fi

# 只在交互式 shell 中执行以下内容
if [[ $- == *i* ]] && [[ -z "${SHELL_RC_LOADED:-}" ]]; then
    export SHELL_RC_LOADED=1

    if [[ -n "${KITTY_PID:-}" || -n "${KITTY_WINDOW_ID:-}" || "${TERM:-}" == "xterm-kitty" || "${TERM_PROGRAM:-}" == "kitty" ]]; then
        if [[ -x "$FASTFETCH_BIN" ]] && [[ -z "${SHELL_FASTFETCH_SHOWN:-}" ]]; then
            export SHELL_FASTFETCH_SHOWN=1
            "$FASTFETCH_BIN"
        fi
    fi

    if [[ -x "$STARSHIP_BIN" ]]; then
        if [[ -n "${ZSH_VERSION:-}" ]]; then
            eval "$("$STARSHIP_BIN" init zsh)"
        elif [[ -n "${BASH_VERSION:-}" ]]; then
            eval "$("$STARSHIP_BIN" init bash)"
        fi
    fi

    # ble.sh 仅适用于 bash
    if [[ -n "${BASH_VERSION:-}" ]] && [[ -f ~/.local/share/blesh/ble.sh ]]; then
        source ~/.local/share/blesh/ble.sh
    fi
fi
