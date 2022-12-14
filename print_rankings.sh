#!/bin/bash

search_filter=$1
for ordo in $(ls -1 easy-train-data/experiments/*/training/ordo.out); do
  if [ -z $search_filter ]; then
    echo $ordo
    cat $ordo
  else
    if ls $ordo | grep ${search_filter}; then
      cat $ordo
    fi
  fi
done
