# ==============================================================
# 1️⃣  Dot‑files helper – thin wrapper around a bare git repo
# ==============================================================

function config
    # Forward every argument to the git command that works on the dot‑files repo
    command git --git-dir=$HOME/.macstar-dotfiles --work-tree=$HOME $argv
end

# Tell the bare repo not to show untracked files (mirrors the Zsh line)
config config --local status.showUntrackedFiles no


# ==============================================================
# 2️⃣  Common aliases / shortcuts
# ==============================================================

# Use Neovim for both `vim` and as the default editor
alias vim='nvim'
set -gx EDITOR nvim          # default editor
set -gx VISUAL $EDITOR       # visual editor

# Update Nix/Darwin – keeps the original working directory
function update
    pushd /etc/nix-darwin
    sudo nix flake update
    sudo darwin-rebuild switch
    popd
end

# Optional: kick‑start alias (commented out in the original)
# alias nvimk='NVIM_APPNAME="nvim-kickstart" nvim'

# Use Kitty’s SSH wrapper
alias ssh='kitten ssh'

pay-respects fish | source

# ==============================================================
# 3️⃣  History / sharing options (Zsh `setopt` equivalents)
# ==============================================================

set -U fish_share_history true

# ==============================================================
# 4️⃣  Git‑related helper (stash count) – mirrors the Zsh function
# ==============================================================

function __git_stash_count
    if git rev-parse --verify refs/stash >/dev/null 2>&1
        git stash list | wc -l | string trim
    else
        echo 0
    end
end


# ==============================================================
# 5️⃣  Prompt definition (colours approximate the Zsh version)
# ==============================================================

function fish_prompt
    # ── user@host (green)
    set_color green
    printf '%s@%s ' (whoami) (hostname)

    # ── current directory (blue)
    set_color blue
    printf '%s ' (prompt_pwd)

    # ── Git branch / status (magenta) – uses Fish’s built‑in git prompt helper
    set -l vcs (fish_git_prompt)
    if test -n "$vcs"
        set_color magenta
        printf '%s ' $vcs
    end

    # ── Stash count (yellow)
    set_color yellow
    printf '(%s) ' (__git_stash_count)

    # ── Prompt symbol: # for root (red), $ for normal user (yellow)
    if test (id -u) -eq 0
        set_color red
        printf '# '
    else
        set_color yellow
        printf '$ '
    end

    set_color normal
end

# Right‑hand prompt – shows exit status of the previous command (cyan)
function fish_right_prompt
    set_color cyan
    printf '%s' $status
    set_color normal
end


# ==============================================================
# 6️⃣  Completion system tweaks (mirrors Zsh’s `menu select`)
# ==============================================================

set -g fish_complete_autosuggest true
bind \t complete   # Tab triggers completion menu


# ==============================================================
# 7️⃣  Fastfetch guard – run only in an interactive terminal
# ==============================================================

if status is-interactive
    # Adjust the path to your fastfetch config if it differs
    fastfetch -c ~/.config/fastfetch/myconfig.jsonc
    # fastfetch -c ~/.config/fastfetch/myconfig.jsonc | lolcat
    ddate | lolcat
end
