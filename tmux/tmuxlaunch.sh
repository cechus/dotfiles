#!/bin/bash
folder=$@
SESSION=dev
tmux new-sessio -d -s $SESSION
tmux new-window -t $SESSION:1 -n 'local'

tmux select-window -t $SESSION:1
tmux send-keys "cd $@ && yarn watch" C-m
tmux splitw -v -p 80
tmux send-keys "cd $@" C-m C-l
tmux splitw -h -p 45
tmux send-keys "cd $@; art t" C-m C-l
tmux splitw -v -p 30
tmux send-keys "cd $folder; psql -U postgres -p 5432" C-m C-l

tmux neww -t $SESSION:2 -n 'log' "cd $@; lnav storage/logs/laravel.log"

tmux neww -t $SESSION:3 -n 'system-monitor' 'htop'


tmux select-window -t $SESSION:1

tmux attach -t $SESSION
