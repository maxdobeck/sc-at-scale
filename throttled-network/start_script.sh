#!/bin/sh
wget -c https://saucelabs.com/downloads/sc-4.9.1-linux.tar.gz
tar xvf ./sc-4.9.1-linux.tar.gz
cd ./sc-4.9.1-linux/bin
echo starting sauce connect
./sc -u $USER -k $KEY -v --region eu-central --tunnel-name smooshed &
echo Sauce Connect OK

touch targetfile
python3 -m http.server 3333 &
echo localhost:3333 OK

# Limit all incoming and outgoing network to 1mbit/s
# details https://stackoverflow.com/questions/25497523/how-can-i-rate-limit-network-traffic-on-a-docker-container
# tc qdisc add dev eth0 handle 1: ingress
# tc filter add dev eth0 parent 1: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 1mbit burst 10k drop flowid :1
# tc qdisc add dev eth0 root tbf rate 1mbit latency 25ms burst 10k
# tc qdisc add dev eth0 root netem loss 0.03% 85%
echo Ran TC cmds

# https://docs.docker.com/config/containers/multi-service_container/#:~:text=It's%20ok%20to%20have%20multiple,defined%20networks%20and%20shared%20volumes.
# Wait for any process to exit
wait
  
# Exit with status of process that exited first
# exit $?
