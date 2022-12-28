#!/bin/bash

# tc_options="option.Hash=8 tc=10000+10000 nodes=25000"
tc_options="option.Hash=16 tc=10+0.1"

num_games=100000
concurrency=16

experiment=experiment_leela-dfrc-filtered-T80-sep-oct-nov
nn_to_test=run_0/nn-epoch779.nnue
pgn_out=/root/test_gauntlet_sepoctnov_779_stc.pgn

/root/easy-train-data/c-chess-cli/c-chess-cli -gauntlet \
  -games $num_games \
  -rounds 1 -concurrency $concurrency \
  -each option.Threads=1 timeout=20 $tc_options \
  -openings \
    file=/root/easy-train-data/books/UHO_XXL_+0.90_+1.19.epd \
    order=random srand=${RANDOM}${RANDOM} \
  -repeat -resign count=3 score=700 -draw count=8 score=10 \
  -engine \
    cmd=/root/easy-train-data/experiments/$experiment/stockfish_base/src/stockfish \
    name=master \
  -engine \
    cmd=/root/easy-train-data/experiments/$experiment/stockfish_test/src/stockfish \
    name=$nn_to_test \
    option.EvalFile=/root/easy-train-data/experiments/$experiment/training/$nn_to_test \
  -pgn $pgn_out 0
