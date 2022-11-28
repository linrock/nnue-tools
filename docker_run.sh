#!/bin/bash

# Run the container in the background (detached)
docker_container_id=$(docker run -d \
  --gpus all \
  --mount type=bind,source="$(pwd)"/data,target=/root/data \
  --mount type=bind,source="$(pwd)"/easy_train_data,target=/root/easy_train_data \
  nnue-pytorch)

# Copy a usable run_easy_train.sh script in at runtime
docker cp run_easy_train.sh $docker_container_id:/root/
docker exec -it $docker_container_id chmod +x /root/run_easy_train.sh

# Symlink the data directory to the bind mounted easy_train_data
docker exec -it $docker_container_id \
  ln -s /root/easy_train_data /root/nnue-pytorch/scripts/

# Attach a bash shell to the running container
docker exec -it $docker_container_id bash
