if status is-interactive
    # Commands to run in interactive sessions can go here
end

# point to where you installed nvm (adjust if different)
set -gx NVM_DIR $HOME/.nvm

function nvm
    bass source $NVM_DIR/nvm.sh --no-use \; nvm $argv
end

# Load nvm and use default node version
bass source $NVM_DIR/nvm.sh --no-use ';' nvm use default >/dev/null

# fzf integration
fzf --fish | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/migue/google-cloud-sdk/path.fish.inc' ]
    . '/home/migue/google-cloud-sdk/path.fish.inc'
end

# aliases
alias nvs='nvim $(fzf --preview="bat --color=always {}")'

# eza
if command -v eza &>/dev/null
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
end
