#!/bin/bash

for ordo in $(ls -1 easy-train-data/experiments/*/training/ordo.out); do
  echo $ordo
  cat $ordo
done
