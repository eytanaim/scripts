#!/bin/bash


if [ -z "$1" ]; then
        echo "Using default interval of 5 seconds"
        INTERVAL=5
else
        INTERVAL="$1"
fi

if [ -z "$2" ]; then
        echo "Using default port number of oracle (1521)"
        PORT=1521
else
        PORT="$2"
fi

NICS=$(ifconfig -a | grep flags | awk '{print $1}' | tr ':' ' ' )

while true; do
        for NIC in ${NICS}; do
                tcpdump -i"$NIC" "port $PORT && tcp[tcpflags] & (tcp-syn|tcp-ack) == (tcp-syn|tcp-ack)" 2>/dev/null | wc -l > ./"$NIC".count.log &
        done
        
        sleep "$INTERVAL"
        
        for PID in $(jobs -p); do
                kill "$PID"
        done

        TOTAL=0
        for NIC in ${NICS}; do
                DELTA=$(cat ./"$NIC".count.log)
                TOTAL=$((TOTAL + DELTA))
        done

        echo "Rate: $((TOTAL / INTERVAL)), Total: ${TOTAL}"
done

