# building

```docker build -t="web-app" -f app/Dockerfile .```

# running

```docker run --name demo-app -p 3000:3000 -d web-app```

or use the compose file to run Sauce Connect + the web-app. `-d` uses detached mode.

```docker compose up -d```