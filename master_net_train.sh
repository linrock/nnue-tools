#!/bin/bash
# Retrain the current master .nnue on the given training dataset

experiment_name=leela93-dfrc99-filt-only-T80octnov
training_dataset=/root/training-data/leela93-dfrc99-filt-only-T80octnov.binpack
nnue_pytorch_branch=linrock/nnue-pytorch/skip28
gpus="0,"

cd nnue-pytorch/scripts
python3 easy_train.py \
  --experiment-name $experiment_name \
  --training-dataset $training_dataset \
  --nnue-pytorch-branch $nnue_pytorch_branch \
  --gpus $gpus \
  --seed $RANDOM \
  --start-from-engine-test-net True \
  --start-lambda 1.0 \
  --end-lambda 0.75 \
  --gamma 0.995 \
  --lr 4.375e-4 \
  --tui False \
  --max_epoch 800 \
  --workspace-path /root/easy-train-data \
  --build-engine-arch x86-64-bmi2 \
  --network-testing-games-per-round 1000 \
  --network-testing-threads 24 \
  --num-workers 6
