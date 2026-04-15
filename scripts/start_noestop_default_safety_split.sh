#!/bin/bash
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
    "zsh -lc 'cd /home/unitree/core_ws/src/h12_safety_layer && uv run h12_safety_layer/script/safety_layer_main.py --config default_safety_split'" C-m

# keep bottom pane selected and empty
tmux select-pane -t "$BOTTOM"

tmux attach -t "$SESSION"
