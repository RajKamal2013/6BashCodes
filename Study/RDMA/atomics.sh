#! /bin/bash

for i in {1..50}
do
        /usr/bin/sparcv9/qperf localhost ver_rc_compare_swap
done
