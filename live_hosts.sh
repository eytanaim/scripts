#!/bin/bash
rm ./live_hosts

for prefix in 10.100.23 10.100.43
    do for i in {1..255}
    do IP="${prefix}.${i}";
        if ! ping -c1 -w1 "${IP}" &> /dev/null; then
            echo -e "\e[90m $IP is not responding \e[39m";
        else
            echo "$IP is alive:"
            echo $IP >> ./live_hosts
        fi
    done
done

