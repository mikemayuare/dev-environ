if status is-interactive
    # Commands to run in interactive sessions can go here
end

# point to where you installed nvm (adjust if different)
set -gx NVM_DIR $HOME/.nvm

function nvm
    bass source $NVM_DIR/nvm.sh --no-use \; nvm $argv
end

oh-my-posh init fish --config ~/.config/fish/ohmyposh_themes/atomic-dracula.omp.json | source

# Load nvm and use default node version
bass source $NVM_DIR/nvm.sh --no-use ';' nvm use default > /dev/null
