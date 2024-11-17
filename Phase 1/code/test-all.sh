#! /bin/bash
> Vcheck.log
shopt -s nullglob
for i in *.v; do
    if [ "$i" == "project-phase1-testbench.v" ]; then
        continue
    fi
    if [ "$i" == "data_memory.v" ]; then
        continue
    fi
    if [ "$i" == "inst_memory.v" ]; then
        continue
    fi
    if [ "$i" == "D-Flip-Flop.v" ]; then
        continue
    fi
    java Vcheck $i >> Vcheck.log
done