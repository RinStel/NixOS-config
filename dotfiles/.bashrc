# ~/.bashrc

# 基础设置与别名
alias ls='ls --color=auto'
alias l='lsd -l'
alias ll='lsd -lah'
alias lt='lsd --tree'

# 如果没有 starship 时，作为后备的提示符
PS1='[\u@\h \W]\$ '

# GO代理
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct

# 输入法（可选）
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# PATH 设置
[[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Kitty 终端特效
if [[ "$TERM" == "xterm-kitty" ]] ; then
    fastfetch -c /run/current-system/sw/share/fastfetch/presets/examples/21.jsonc \
              --logo ~/.config/fastfetch/openbit.png \
              --logo-type kitty-direct \
              --logo-width 12 \
              --logo-height 0
fi

#if [[ "$TERM" == "xterm-kitty" ]] ; then
#    fastfetch -c /run/current-system/sw/share/fastfetch/presets/examples/21.jsonc
  # --kitty-direct ~/.config/fastfetch/openbit.png
#fi

# 只在交互式 shell 中执行以下内容
if [[ $- == *i* ]]; then
    # 初始化 Starship
    eval "$(starship init bash)"

    # 加载 ble.sh（语法高亮 + autosuggest）
    [[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh
fi
