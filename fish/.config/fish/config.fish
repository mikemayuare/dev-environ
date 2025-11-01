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
