#!/bin/bash

# Run the container in the background (detached)
docker_container_id=$(docker run -d \
  --gpus all \
  --mount type=bind,source="$(pwd)"/training-data,target=/root/training-data \
  --mount type=bind,source="$(pwd)"/easy-train-data,target=/root/easy-train-data \
  nnue-pytorch)

# Copy a usable run_easy_train.sh script in at runtime
docker cp run_easy_train.sh $docker_container_id:/root/
docker exec -it $docker_container_id chmod +x /root/run_easy_train.sh

# Attach a bash shell to the running container
docker exec -it $docker_container_id bash
