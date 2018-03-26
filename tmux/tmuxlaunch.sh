#!/bin/bash
SESSION=dev
tmux new-sessio -d -s $SESSION
tmux new-window -t $SESSION:1 -n 'local'

tmux select-window -t $SESSION:1
tmux send-keys 'cd ~/git/wwwachuchus; yarn watch' C-m
tmux splitw -v -p 80
tmux send-keys 'cd ~/git/wwwachuchus' C-m
tmux splitw -h -p 45
tmux send-keys 'cd ~/git/wwwachuchus; art t' C-m
tmux splitw -v -p 30
tmux send-keys 'cd ~/git/wwwachuchus; psql -U postgres -p 5435' C-m

tmux neww -t $SESSION:2 -n 'log' 'cd ~/git/wwwachuchus; lnav storage/logs/laravel.log'

tmux neww -t $SESSION:3 -n 'system-monitor' 'htop'

tmux select-window -t $SESSION:1

tmux attach -t $SESSION
