if status is-interactive
    # Commands to run in interactive sessions can go here
end

# starship integration
starship init fish | source

# zoxide integration
zoxide init fish --cmd cd | source

# fzf integration
fzf --fish | source

# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/home/migue/google-cloud-sdk/path.fish.inc' ]
#     . '/home/migue/google-cloud-sdk/path.fish.inc'
# end

# aliases
alias nvs='nvim $(fzf --preview="bat --color=always {}")'
alias nv='nvim'
alias cat='bat'
alias y='yazi'
alias k='kubectl'

# eza
if command -v eza &>/dev/null
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
end

# ~/.tmux/plugins
fish_add_path $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin
# ~/.config/tmux/plugins
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin

# opencode
fish_add_path /home/migue/.opencode/bin

# uv
fish_add_path "/home/migue/.local/share/../bin"
fish_add_path "/home/migue/.npm-global/bin"

# kubectl variables
set -x KUBECONFIG /home/migue/.kube/config

# nvim as default editor
set -x EDITOR nvim
set -x VISUAL nvim

# for keyring
if not set -q XDG_RUNTIME_DIR
    set -gx XDG_RUNTIME_DIR /run/user/(id -u)
end

if not test -d $XDG_RUNTIME_DIR
    sudo mkdir -p $XDG_RUNTIME_DIR
    sudo chown (id -u):(id -g) $XDG_RUNTIME_DIR
    chmod 700 $XDG_RUNTIME_DIR
end
