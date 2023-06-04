#!/bin/bash
# Train a new .nnue from scratch

cd nnue-pytorch/scripts
python3 easy_train.py \
  --training-dataset=/root/training-data/nodes5000pv2_UHO.binpack \
  --experiment-name=new-net-UHO \
  --gpus="0," \
  --lambda=1.0 \
  --tui=False \
  --seed=$RANDOM \
  --max_epoch=400 \
  --auto-exit-timeout-on-training-finished=900 \
  --nnue-pytorch-branch=linrock/nnue-pytorch/misc-fixes \
  --workspace-path=/root/easy-train-data \
  --network-testing-threads 8 \
  --num-workers 12
