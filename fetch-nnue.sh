#!/bin/bash

wget --no-check-certificate $1 -O downloaded.nnue
sha256_hash=$(sha256sum downloaded.nnue)
nnue_name=nn-${sha256_hash:0:12}.nnue
mv downloaded.nnue $nnue_name
echo $nnue_name
