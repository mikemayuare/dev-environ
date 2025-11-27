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
if [ -f '/home/migue/google-cloud-sdk/path.fish.inc' ]
    . '/home/migue/google-cloud-sdk/path.fish.inc'
end

# aliases
alias nvs='nvim $(fzf --preview="bat --color=always {}")'
alias nv='nvim'
alias cat='bat'

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
