#!/bin/bash

# print the easy_train.py command
python3 /root/yaml_easy_train.py ${1} print
echo

# then run it from the dir containing easy_train.py
command=$(python3 /root/yaml_easy_train.py ${1})
cd /root/nnue-pytorch/scripts
exec $command
