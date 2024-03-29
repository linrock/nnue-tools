#!/bin/bash
# Retrain the current master .nnue on the given training dataset
source ./misc/utils.sh
experiment_name=leela93-dfrc99-filt-only-T80octnov
training_dataset=/root/training-data/leela93-dfrc99-filt-only-T80octnov.binpack
nnue_pytorch_branch=linrock/nnue-pytorch/misc-fixes

cd nnue-pytorch/scripts
python3 easy_train.py \
  --early-fen-skipping 28 \
  --max_epoch 800 \
  --start-lambda 1.0 \
  --end-lambda 0.7 \
  --network-testing-games-per-round 1000 \
  --network-testing-threads 24 \
  --num-workers 6 \
  --start-from-engine-test-net True \
  --lr 4.375e-4 \
  --gamma 0.995 \
  --build-engine-arch x86-64-bmi2 \
  --workspace-path /root/easy-train-data \
  --tui False \
  --seed $RANDOM \
  --gpus $(filename_to_gpu_str) \
  --experiment-name $experiment_name \
  --training-dataset $training_dataset \
  --nnue-pytorch-branch $nnue_pytorch_branch
