#!/bin/bash
# Retrain the current master .nnue on the given training dataset

experiment_name=Leela-dfrc_n5000
training_dataset=/root/training-data/Leela-dfrc_n5000.binpack
nnue_pytorch_branch=linrock/nnue-pytorch/misc-fixes
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
