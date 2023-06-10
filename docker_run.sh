#!/bin/bash

# Run the container in the background (detached)
docker_container_id=$(docker run -d \
  --gpus all \
  --mount type=bind,source="$(pwd)"/training-data,target=/root/training-data \
  --mount type=bind,source="$(pwd)"/easy-train-data,target=/root/easy-train-data \
  --mount type=bind,source="$(pwd)"/config,target=/root/config \
  --mount type=bind,source=/dev/shm,target=/dev/shm \
  nnue-pytorch)

# Copy a usable run_easy_train.sh script in at runtime
docker cp print_rankings.sh $docker_container_id:/root/
docker cp train.sh $docker_container_id:/root/

docker exec -it $docker_container_id chmod +x /root/print_rankings.sh
docker exec -it $docker_container_id chmod +x /root/train.sh

# Attach a bash shell to the running container
docker exec -it $docker_container_id bash
