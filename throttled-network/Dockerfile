FROM ubuntu:22.04
# in case we run Sauce Connect
RUN  apt-get update && apt-get install -y wget
RUN  apt-get install -y libc6-amd64-cross
RUN  ln -s /usr/x86_64-linux-gnu/lib64/ /lib64
ENV  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/lib64:/usr/x86_64-linux-gnu/lib"
RUN apt-get install iproute2 -y
RUN apt-get install python3 -y
RUN apt-get install curl -y
RUN curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh |  bash
RUN apt-get install speedtest -y
RUN apt-get install wondershaper -y

# for running Sauce Connect Proxy
EXPOSE 3333
COPY ./start_script.sh .
RUN chmod +x ./start_script.sh
# CMD ./start_script.sh
ENTRYPOINT ./start_script.sh