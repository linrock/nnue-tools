#!/bin/bash
# Modified from https://github.com/official-stockfish/Stockfish/wiki/Advanced-topics
# set -eu -o pipefail

_bench () {
${1} << EOF > /dev/null 2>> ${2}
bench 16 1 ${depth} default depth
EOF
}
# _bench function customization example
# setoption name SyzygyPath value C:\table_bases\wdl345;C:\table_bases\dtz345
# bench 128 4 ${depth} default depth

if [[ ${#} -ne 4 ]]; then
cat << EOF
usage: ${0} ./stockfish_base ./stockfish_test depth n_runs
fast bench:
${0} ./stockfish_base ./stockfish_test 13 10
slow bench:
${0} ./stockfish_base ./stockfish_test 20 10
EOF
exit 1
fi

sf_base=${1}
sf_test=${2}
depth=${3}
n_runs=${4}

# preload of CPU/cache/memory
printf "preload CPU"
(_bench ${sf_base} sf_base0.txt)&
(_bench ${sf_test} sf_test0.txt)&
wait

# temporary files initialization
: > sf_base0.txt
: > sf_test0.txt
: > sf_temp0.txt

# bench loop: SMP bench with background subshells
for ((k=1; k<=${n_runs}; k++)); do
    printf "\rrun %3d /%3d" ${k} ${n_runs}

    # swap the execution order to avoid bias
    if [ $((k%2)) -eq 0 ]; then
        (_bench ${sf_base} sf_base0.txt)&
        (_bench ${sf_test} sf_test0.txt)&
        wait
    else
        (_bench ${sf_test} sf_test0.txt)&
        (_bench ${sf_base} sf_base0.txt)&
        wait
    fi
done

# text processing to extract nps values
cat sf_base0.txt | grep second | grep -Eo '[0-9]{1,}' > sf_base1.txt
cat sf_test0.txt | grep second | grep -Eo '[0-9]{1,}' > sf_test1.txt

for ((k=1; k<=${n_runs}; k++)); do
    echo ${k} >> sf_temp0.txt
done

printf "\rrun   sf_base   sf_test      diff\n"
paste sf_temp0.txt sf_base1.txt sf_test1.txt | gawk '{printf "%3d  %8d  %8d  %8+d\n", $1, $2, $3, $3-$2}'
# paste sf_temp0.txt sf_base1.txt sf_test1.txt | awk '{printf "%3d  %8d  %8d  %8+d\n", $1, $2, $3, $3-$2}'
# paste sf_temp0.txt sf_base1.txt sf_test1.txt | awk '{printf "%3d\t%8d\t%8d\t%7+d\n", $1, $2, $3, $3-$2}'
paste sf_base1.txt sf_test1.txt | gawk '{printf "%d\t%d\t%d\n", $1, $2, $2-$1}' > sf_temp0.txt

# compute: sample mean, 1.96 * std of sample mean (95% of samples), speedup
# std of sample mean = sqrt(NR/(NR-1)) * (std population) / sqrt(NR)
cat sf_temp0.txt | gawk '{sum1 += $1 ; sumq1 += $1**2 ;sum2 += $2 ; sumq2 += $2**2 ;sum3 += $3 ; sumq3 += $3**2 } END {printf "\nsf_base = %8d +/- %6d (95%)\nsf_test = %8d +/- %6d (95%)\ndiff    = %8d +/- %6d (95%)\nspeedup = %.5f% +/- %.3f% (95%)\n\n", sum1/NR , 1.96 * sqrt(sumq1/NR - (sum1/NR)**2)/sqrt(NR-1) , sum2/NR , 1.96 * sqrt(sumq2/NR - (sum2/NR)**2)/sqrt(NR-1) , sum3/NR  , 1.96 * sqrt(sumq3/NR - (sum3/NR)**2)/sqrt(NR-1) , 100*(sum2 - sum1)/sum1 , 100 * (1.96 * sqrt(sumq3/NR - (sum3/NR)**2)/sqrt(NR-1)) / (sum1/NR) }'

# remove temporary files
rm -f sf_base0.txt sf_test0.txt sf_temp0.txt sf_base1.txt sf_test1.txt
