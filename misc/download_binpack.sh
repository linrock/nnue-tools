#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: download_binpack.sh <filename:binpack>"
  exit 0
fi

binpack=$1
# binpack=test77-2021-12-dec-16tb7p.v6-dd.min.binpack

if [ -f $binpack ]; then
  echo binpack already exists
  ls -lth $binpack
  exit 0
fi

# test60, test77, test78, test79, test80-2022, test80-2023
source_repo=$(echo $binpack | grep -oE "^test[678][0-9]")
if [[ "$source_repo" == "test80" ]]; then
  source_year=$($echo $binpack | grep -oE "202[234]")
  source_repo=$source_repo-$source_year
fi

source_url=https://huggingface.co/datasets/linrock/$source_repo/resolve/main/$binpack.zst

echo $binpack
echo downloading from:
echo $source_url
echo ...

command="curl -L $source_url | zstd -d --stdout -o $binpack"
echo $command

curl -L $source_url | zstd -d --stdout -o $binpack
ls -lth $binpack
