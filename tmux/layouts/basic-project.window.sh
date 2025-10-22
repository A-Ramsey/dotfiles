# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "$TMUXIFIER_PROJECT_DIR"

# Create new window. If no argument is given, window name will be based on
# layout file name.
new_window "$TMUXIFIER_SESSION_NAME"

# Split window into panes.
# split_v 20
split_h 25

# Run commands.
#run_cmd "top"     # runs in active pane
#run_cmd "date" 1  # runs in pane 1
run_cmd "if [ -f ./start.sh ]; then 
  ./start.sh 
else
  clear
fi"
run_cmd "nvim" 1

# Paste text
#send_keys "top"    # paste into active pane
#send_keys "date" 1 # paste into pane 1

# Set active pane.
select_pane 1
