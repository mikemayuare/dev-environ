if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
# oh-my-posh init fish --config ~/.config/fish/themes/catppuccin-frappe-minimal.omp.json | source

zoxide init fish --cmd cd | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/migue/google-cloud-sdk/path.fish.inc' ]
    . '/home/migue/google-cloud-sdk/path.fish.inc'
end
