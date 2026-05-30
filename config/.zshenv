# ~/.zshenv
# 此文件在【所有】zsh 调用时都会加载（包括非交互式 shell、脚本、Emacs 子进程）
# 因此只放环境变量和 PATH，不放 alias / 插件 / 补全等交互式配置

# ── Homebrew (macOS) 必须最先，后面很多东西依赖 brew PATH ──
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# brew 行为调整
export HOMEBREW_NO_ENV_HINTS=1      # 关掉"Hide these hints with..."这类提示
export HOMEBREW_NO_AUTO_UPDATE=1    # install/upgrade 前不自动 update（手动控制 + 提速）

# ── Locale：强制 UTF-8 英文环境，避免 ssh / 某些工具下中文乱码或 locale 报错 ──
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ── 默认编辑器：连接已有 Emacs daemon，没 daemon 时自动启动一个 ──
export EDITOR='emacsclient -a ""'
export VISUAL="$EDITOR"

# ── 语言/工具环境变量 ──
export GOPATH="$HOME/.go"

# gtags（GNU Global，代码索引工具）
export GTAGSOBJDIRPREFIX="$HOME/.cache/gtags/"
export GTAGSCONF="$HOME/.globalrc"
export GTAGSLABEL="native-pygments"

export HF_ENDPOINT=https://hf-mirror.com

# ── PATH 统一在这里设置一次 ──
export PATH="$HOME/.cargo/bin:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH"

# ── Linux 特定 ──
[[ "$XDG_SESSION_TYPE" == "wayland" ]] && export MOZ_ENABLE_WAYLAND=1
