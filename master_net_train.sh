#!/bin/bash
# Retrain the current master .nnue on the given training dataset

experiment_name=Leela-dfrc_n5000
training_dataset=/root/training-data/Leela-dfrc_n5000.binpack

cd nnue-pytorch/scripts
python3 easy_train.py \
  --experiment-name=$experiment_name \
  --training-dataset=$training_dataset \
  --start-from-engine-test-net True \
  --gpus="0," \
  --start-lambda=1.0 \
  --end-lambda=0.75 \
  --gamma=0.995 \
  --lr=4.375e-4 \
  --tui=False \
  --seed=$RANDOM \
  --max_epoch=800 \
  --nnue-pytorch-branch=linrock/nnue-pytorch/misc-fixes \
  --workspace-path=/root/easy-train-data \
  --build-engine-arch=x86-64-bmi2 \
  --network-testing-games-per-round 1000 \
  --network-testing-threads 8 \
  --num-workers 12

# --network-testing-hash-mb=16 \
# --auto-exit-timeout-on-training-finished=900 \
