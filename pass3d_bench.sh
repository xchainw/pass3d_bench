#!/bin/bash

iterations=1

obj_path="objs/*.obj"

error_output="error.log"
total_objs=0
total_below_10_seconds=0
total_error=0
for obj in $obj_path; do
    total_objs=$((total_objs + 1))
    # initial parameters
    min_duration=999999
    max_duration=0
    total_duration=0
    below_10_seconds=0
    error_obj=0
    obj_name=$(basename "$obj")
    for ((j=0; j<iterations;j++));do
        start_time=$(date +%s.%N)
        echo "[$obj_name] start tokenization test..."
        if ! ./pass3d -s 12 -g 8 -a grid2d_v3a -d 10 -i "${obj}" > /dev/null 2> "$error_output"
        then
            error_obj=$((error_obj + 1))
            echo "[$obj_name] tokenization error: "
            cat "$error_output"
            break
        fi
        end_time=$(date +%s.%N)
        duration=$(echo "$end_time - $start_time" | bc -l | xargs printf "%.2f")
        if (( $(echo "$duration < $min_duration" | bc -l) )); then
            min_duration=$duration
        fi
        if (( $(echo "$duration > $max_duration" | bc -l) )); then
            max_duration=$duration
        fi
        if (( $(echo "$duration < 10" | bc -l) )); then
            below_10_seconds=$((below_10_seconds + 1))
            total_below_10_seconds=$((total_below_10_seconds + 1))
        fi
        total_duration=$(echo "$total_duration + $duration" | bc -l)
    done
    if [[ $error_obj -eq 0 ]];then
        average_duration=$(echo "$total_duration / $iterations" | bc -l | xargs printf "%.2f")
        echo "[$obj_name] MIN: $min_duration s, MAX: $max_duration s, AVG: $average_duration s"
        echo "[$obj_name] below 10 seconds: ${below_10_seconds}/${iterations}"
    fi
    total_error=$((total_error + error_obj))
done
echo "total error: ${total_error}"
echo "total below 10 seconds: ${total_below_10_seconds}/$((total_objs * iterations))"
if [[ $total_error -eq 0 ]];then
    rm -f "$error_output"
fi