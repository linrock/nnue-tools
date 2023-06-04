#!/bin/bash

# print the easy_train.py command
python3 yaml_easy_train.py ${1} print
echo

# then run it from the trainer dir
command=$(python3 yaml_easy_train.py ${1})
cd nnue-pytorch/scripts
exec $command
