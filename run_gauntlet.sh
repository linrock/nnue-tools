#!/bin/bash

# tc_options="tc=10000+10000 nodes=25000"
tc_options="tc=10+0.1"
random=${RANDOM}${RANDOM}
experiment=experiment_name
nn_to_test=run_1/nn-epoch799.nnue

/root/easy-train-data/c-chess-cli/c-chess-cli -gauntlet \
  -games 100 \
  -rounds 1 -concurrency 10 \
  -each option.Hash=8 option.Threads=1 timeout=20 $tc_options \
  -openings file=/root/easy-train-data/books/UHO_XXL_+0.90_+1.19.epd \
  order=random srand=$random -repeat -resign count=3 score=700 -draw count=8 score=10 \
  -engine cmd=/root/easy-train-data/experiments/$experiment/stockfish_base/src/stockfish name=master \
  -engine cmd=/root/easy-train-data/experiments/$experiment/stockfish_test/src/stockfish name=$nn_to_test \
  -pgn /root/test_gauntlet.pgn 0
