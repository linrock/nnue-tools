#!/bin/bash

search_filter=$1
for ordo_file in $(ls -1 easy-train-data/experiments/*/training/ordo.out); do
  if [ -z $search_filter ]; then
    echo $ordo_file
    cat $ordo_file
  else
    if ls $ordo_file | grep ${search_filter} > /dev/null; then
      echo $(echo $ordo_file | grep -oE experiment_.*)
      tail -100 $(dirname $ordo_file)/../logging/easy_train.log | grep Epoch | tail -1
      cat $ordo_file
      echo
    fi
  fi
done
