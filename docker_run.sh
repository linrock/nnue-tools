#!/bin/bash

docker run -it \
  --gpus all \
  --mount type=bind,source="$(pwd)"/data,target=/root/data \
  --mount type=bind,source="$(pwd)"/easy_train_data,target=/root/nnue-pytorch/scripts/easy_train_data \
  nnue-pytorch bash
