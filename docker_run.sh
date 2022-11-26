#!/bin/bash

# Run the container in the background (detached)
docker_container_id=$(docker run -d \
  --gpus all \
  --mount type=bind,source="$(pwd)"/data,target=/root/data \
  --mount type=bind,source="$(pwd)"/easy_train_data,target=/root/nnue-pytorch/scripts/easy_train_data \
  nnue-pytorch)

# Copy a usable easy_train.sh script in at runtime
docker cp easy_train.sh $docker_container_id:/root/
docker exec -it $docker_container_id chmod +x /root/easy_train.sh

# Attach a bash shell to the running container
docker exec -it $docker_container_id bash
