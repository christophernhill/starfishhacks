#!/bin/bash

#
# remote involked script to run starfish job on cluster internal node
#

echo hello `date`
( exec nohup ssh -l cnh starfish.cm.cluster "sudo /cnh/files-acmtimesize-7mo1G.sh; sudo /cnh/files-acmtimesize-6mo1G.sh" ) </dev/null >>clog.txt 2>&1 &
disown
echo done
