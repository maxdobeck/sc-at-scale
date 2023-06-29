FROM python:3.11.0-slim-bullseye
WORKDIR /server
COPY ./i-am-a-pdf.pdf .
EXPOSE 1080
CMD python -m http.server 1080
