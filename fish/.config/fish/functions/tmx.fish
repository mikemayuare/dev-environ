function tmx
    # Get the base name of the current directory
    set session_name (basename $PWD)

    # Check if the session already exists
    if tmux has-session -t $session_name 2>/dev/null
        tmux attach-session -t $session_name
    else
        tmux new-session -s $session_name
    end
end
