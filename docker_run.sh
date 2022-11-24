#!/bin/bash

docker run -it \
  --gpus all \
  --mount type=bind,source="$(pwd)"/data,target=/root/data \
  nnue-pytorch bash
