#!/bin/bash

search_filter=$1
for ordo_file in $(ls -1 easy-train-data/experiments/*/training/ordo.out); do
  if [ -z $search_filter ]; then
    echo $ordo_file
    cat $ordo_file
  else
    if ls $ordo_file | grep ${search_filter}; then
      cat $ordo_file
      tail -1 $(dirname $ordo_file)/../logging/easy_train.log
    fi
  fi
done
