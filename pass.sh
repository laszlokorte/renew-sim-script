#!/bin/bash

set -e

# Start the target process in the background and set up its input pipe
another_process="$@"

if test -p fifi; then
rm fifi
fi

mkfifo fifi
exec 3<>fifi

$another_process <&3 &
pid=$!

echo $pid >&3

trap "echo 'Killing the background process with PID $pid'; kill $pid; rm fifi" EXIT

# Define the condition to filter lines
filter_condition() {
    local line="$1"
    # Example: omit lines containing "skip"
    if [[ "$line" == *"skip"* ]]; then
        return 1 # False: line will be omitted
    else
        return 0 # True: line will be passed
    fi
}

# Read from stdin line by line
while IFS= read -e -p ">> " line; do
    echo "$line" >&3
done

if ps -p $pid > /dev/null
then
   kill $pid
fi

