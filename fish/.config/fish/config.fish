if status is-interactive
    # Commands to run in interactive sessions can go here
end

# point to where you installed nvm (adjust if different)
set -gx NVM_DIR $HOME/.nvm

function nvm
    bass source $NVM_DIR/nvm.sh --no-use \; nvm $argv
end

if set -q ZELLIJ
else
    zellij
end

# starship init fish | source
oh-my-posh init fish --config ~/.config/fish/themes/catppuccin-frappe-minimal.omp.json | source

# Load nvm and use default node version
bass source $NVM_DIR/nvm.sh --no-use ';' nvm use default >/dev/null

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/migue/google-cloud-sdk/path.fish.inc' ]
    . '/home/migue/google-cloud-sdk/path.fish.inc'
end
