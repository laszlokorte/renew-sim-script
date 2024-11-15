#!/bin/bash

# Program to wrap (passed as the first argument)
program="$1"

# Start the program in the background
$program &
program_pid=$!  # Capture the PID of the program

# Monitor stdin using tail to detect when stdin is closed
tail -f <&0 &  # Monitor stdin in the background (this waits for data)

# Wait for the tail process to finish (which happens when stdin is closed)
wait $!

# Once stdin is closed, kill the child program
echo "stdin closed, killing the program..."
kill "$program_pid"

# Wait for the child process to exit properly
wait "$program_pid"