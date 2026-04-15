#!/bin/zsh
set -e

SESSION='h12_safety'

if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n main

# initial pane = TOP
TOP=$(tmux display-message -p -t "$SESSION":main.0 '#{pane_id}')

# create BOTTOM from TOP
BOTTOM=$(tmux split-window -v -t "$TOP" -P -F '#{pane_id}')

# TOP command
tmux send-keys -t "$TOP" \
    "zsh -lc 'source /home/unitree/core_ws/install/setup.sh && ros2 launch h12_ros2_controller robot_safety_launch.py'" C-m

# keep bottom pane selected and empty
tmux select-pane -t "$BOTTOM"

tmux attach -t "$SESSION"
