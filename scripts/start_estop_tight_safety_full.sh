#!/bin/bash
set -e

SESSION='h12_safety'

if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
fi

tmux new-session -d -s "$SESSION" -n main

# initial pane = LEFT_TOP
LEFT_TOP=$(tmux display-message -p -t "$SESSION":main.0 '#{pane_id}')

# create RIGHT pane from LEFT_TOP
RIGHT=$(tmux split-window -h -t "$LEFT_TOP" -P -F '#{pane_id}')

# create LEFT_BOTTOM from LEFT_TOP
LEFT_BOTTOM=$(tmux split-window -v -t "$LEFT_TOP" -P -F '#{pane_id}')

# LEFT_TOP command
tmux send-keys -t "$LEFT_TOP" \
    "zsh -lc 'source /home/unitree/core_ws/install/setup.zsh && ros2 run estop estop_node'" C-m

# LEFT_BOTTOM command
tmux send-keys -t "$LEFT_BOTTOM" \
    "zsh -lc 'sleep 8 && cd /home/unitree/core_ws/src/h12_safety_layer && uv run h12_safety_layer/script/safety_layer_main.py --config tight_safety_full'" C-m

# keep RIGHT pane selected and empty
tmux select-pane -t "$RIGHT"

tmux attach -t "$SESSION"
