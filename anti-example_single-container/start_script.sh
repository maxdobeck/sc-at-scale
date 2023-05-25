#!/bin/sh
wget -c https://saucelabs.com/downloads/sc-4.8.2-linux.tar.gz
tar xvf ./sc-4.8.2-linux.tar.gz
cd ./sc-4.8.2-linux/bin
echo starting sauce connect
./sc -u $SAUCE_USERNAME -k $SAUCE_ACCESS_KEY -v --region eu-central --tunnel-name smooshed -l - &

touch targetfile
python3 -m http.server 3333 &

# https://docs.docker.com/config/containers/multi-service_container/#:~:text=It's%20ok%20to%20have%20multiple,defined%20networks%20and%20shared%20volumes.
# Wait for any process to exit
wait
  
# Exit with status of process that exited first
# exit $?
