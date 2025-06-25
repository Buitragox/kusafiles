# List of programs used in this config: https://github.com/stars/Buitragox/lists/terminal

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=af-magic

plugins=(git asdf)

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# ===== Aliases ===== #
alias rmine="open -na RubyMine --args nosplash" # Only on MacOS
alias nv="nvim"
alias py="python3"
alias pip="pip3"
alias be="bundle exec" # For ruby
alias zshedit="code ~/.zshrc"
alias zshsource="source ~/.zshrc"

# docker aliases
alias dc="docker compose"
alias dcu="docker compose up -d"
alias dcr="docker compose --force-recreate --build -d"
alias dcs="docker compose stop"

# ===== asdf ===== #
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# ===== Load multiple neovim configs =====
# Taken from https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b with some modifications

# Create aliases for all neovim configurations inside ~/.config/ ()
# neovim config folders must follow the pattern "*-nvim"
nvim_configs=( $(fd --type d --max-depth 1 --format "{/}" --hidden ".+\-nvim" ~/.config) )
for conf in ${nvim_configs[@]}; do
  alias $conf="NVIM_APPNAME=$conf nvim"
done

# Create the `nvims` command for choosing a neovim configuration with fzf
function nvims() {
  items=( "default" )
  items+=( ${nvim_configs[@]} )
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config » " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# ===== fzf =====
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd -H --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Use fd for listing path candidates.
function _fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
function _fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# ===== other tools ===== #
eval "$(zoxide init --cmd cd zsh)"
eval "$(atuin init zsh)"

# ===== syntax highlighting and autosuggestions =====
# IMPORTANT: Must be sourced at the end
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
