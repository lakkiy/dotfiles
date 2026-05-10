# ~/.zshrc
# 仅在【交互式 shell】加载。环境变量请放 ~/.zshenv

# ===== 历史 =====
HISTFILE=~/.zsh_history
# 内存中保留的历史条数（启动时从 HISTFILE 加载这么多到内存）
HISTSIZE=100000
# 写回 HISTFILE 的最大条数（持久化上限）
SAVEHIST=100000

# 多终端实时共享历史：A 终端执行的命令，B 终端按 ↑ 立刻能看到
setopt SHARE_HISTORY
# 任何重复命令都删掉旧的，只保留最新一次（不论是否连续）
setopt HIST_IGNORE_ALL_DUPS
# 搜索历史时（Ctrl+R）跳过重复结果
setopt HIST_FIND_NO_DUPS
# 以空格开头的命令不进历史（用来执行带密码/敏感信息的命令）
setopt HIST_IGNORE_SPACE
# 保存前去掉命令中多余的空白字符
setopt HIST_REDUCE_BLANKS

# ===== 键位 =====
# Emacs 风格快捷键（Ctrl+A 行首、Ctrl+E 行尾、Ctrl+R 搜历史等）
bindkey -e

# ===== 插件管理：zsh_unplugged =====
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# 首次自举：clone zsh_unplugged 自身
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

# 插件列表：plugin-load 函数会自动 clone + source + 加 fpath
repos=(
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting   # 必须放最后，它要 hook 已加载的所有东西
)
plugin-load $repos

# 手动调用：更新所有插件
function plugin-update {
  for d in $ZPLUGINDIR/*/.git(/); do
    echo "Updating ${d:h:t}..."
    command git -C "${d:h}" pull --ff --recurse-submodules --depth 1 --rebase --autostash
  done
}

# ===== 补全（必须在 plugin-load 之后，让 zsh-completions 的 fpath 已加入）=====
autoload -Uz compinit
# 一天只完整重建一次 .zcompdump，平时跳过校验直接用缓存（启动加速）
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# 补全菜单可上下选择（按 Tab 或方向键）
zstyle ':completion:*' menu select
# 补全大小写不敏感：输入小写也能匹配大写文件名
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ===== 工具集成 =====
# $+commands[xxx] 是 zsh 内建 hash 查询，比 `command -v` 快得多（不 fork 子进程）
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

# fzf：Ctrl+R 搜历史 / Ctrl+T 搜文件 / Alt+C cd 到子目录
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
(( $+commands[fzf] )) && source <(fzf --zsh)

# ===== 别名 =====
# grep 跳过二进制文件，避免在二进制里乱匹配
alias grep='grep --binary-files=without-match'

# ls：macOS 默认是 BSD ls，参数和 GNU 不兼容；优先用 brew 装的 gls (coreutils)
if (( $+commands[gls] )); then
    alias ls='gls --color --group-directories-first --human-readable --time-style=long-iso'
elif [[ "$(uname)" == "Linux" ]]; then
    alias ls='ls --color=auto --group-directories-first --human-readable --time-style=long-iso'
else
    alias ls='ls -G'   # macOS BSD ls fallback
fi
alias ll='ls -al'

# ===== Shell 集成 =====
# Emacs eat 终端集成（让 Emacs 知道当前目录、命令边界等）
[[ -n "$EAT_SHELL_INTEGRATION_DIR" ]] && source "$EAT_SHELL_INTEGRATION_DIR/zsh"

# iTerm2 shell 集成（标记命令边界、感知目录变化）
[[ -f "$HOME/.config/zsh/.iterm2_shell_integration.zsh" ]] && \
    source "$HOME/.config/zsh/.iterm2_shell_integration.zsh"

# ===== 本机专属配置（不进 git）=====
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
