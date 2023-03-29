FROM python:3.11.0-slim-bullseye
RUN  apt-get update && apt-get install -y wget
RUN  apt-get install -y libc6-amd64-cross
RUN  ln -s /usr/x86_64-linux-gnu/lib64/ /lib64
ENV  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/lib64:/usr/x86_64-linux-gnu/lib"

EXPOSE 3333
COPY ./start_script.sh .
RUN chmod +x ./start_script.sh
CMD ./start_script.sh
