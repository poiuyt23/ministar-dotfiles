# ----- start of dotfiles helper -----
alias config='/usr/bin/git --git-dir=$HOME/.ministar-dotfiles --work-tree=$HOME'
# Make sure Git ignores the .dotfiles folder itself
config config --local status.showUntrackedFiles no
# ----- end of dotfiles helper -----
alias vim="nvim"
alias update='pushd /etc/nix-darwin/; sudo nix flake update; sudo darwin-rebuild switch; sudo mas update; popd'
# alias nvimk='NVIM_APPNAME="nvim-kickstart" nvim'
alias ssh="kitten ssh"
eval "$(pay-respects zsh --alias)" # alias f to "pay-respects"

setopt correct         # typo correction for commands
setopt histignoredups  # don’t store duplicate entries in history
setopt share_history   # keep history synced across multiple terminals
#setopt PROMPT_SUBST

export EDITOR=nvim # default editor
export VISUAL=$EDITOR

autoload -U compinit && compinit && # enable completion system
zstyle ':completion:*' menu select # navigate completions with arrow keys

# Git shell stuff:
# --------------------------------------------
# Enable prompt substitution (allows $(…) inside PROMPT)
# -----------------------------------------
setopt PROMPT_SUBST

# ------------------------------------------
# Load the vcs_info module and make it run before each prompt
# -----------------------------------------

autoload -Uz vcs_info                # make the builtin available
precmd () { vcs_info }         # run vcs_info on every prompt

# ------------------------------------------
# Tell vcs_info we only care about Git and what to show
# -----------------------------------------

zstyle ':vcs_info:*' enable git       # enable only the git backend
zstyle ':vcs_info:git*' action'%b' # %b = short branch name

# (optional) show ongoing Git actions, e.g. rebase:
# zstyle ':vcs_info:git*' actionformats '%b|%a'

# ------------------------------------------
# Helper that counts stash entries (returns 0 if none)
# -----------------------------------------

git_stash_count() {
  if git rev-parse --verify refs/stash >/dev/null 2>&1; then
    git stash list | wc -l | tr -d ' '
  else
    echo 0
  fi
}

# ------------------------------------------
# Assemble the prompt (use double quotes or no quotes)
# ---------------------------------------------

PROMPT="%F{gren}%n@%m%f "                    # user@host (green)
PROMPT+="%F{blue}%~%f "               # cwd (blue)
PROMPT+="%F{magenta}\${vcs_info_msg_0_}%f"    # Git branch (magenta)
PROMPT+=" %F{yellow}\$(git_stash_count)%f"    # stash count (yellow)
PROMPT+=" %(!.%F{red}#%f.%F{yellow}$%f) "    # # for root, $ for user

# (optional) right‑hand prompt – shows exit status of last command

RPROMPT="%F{cyan}%?%f"

# End git prompt

#   Guard: make sure we’re in an interactive shell.
if [[ $- == *i* && -t 1 ]]; then
        command fastfetch -c ~/.config/fastfetch/myconfig.jsonc # | lolcat #lol
	command ddate | lolcat
fi

