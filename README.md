# sc-at-scale
## running
cd to a directory of your choosing.
`docker compose up` and watch the Sauce Connect Proxies start!

## simple-compose
The Sauce Connect Proxy sits adjacent to a nginx:latest instance. This means you can reach the nginx service from Sauce Labs by going to `nginx` (if you run it as is). You can also play around and [provide the container](https://docs.docker.com/compose/compose-file/compose-file-v3/#container_name) a name with `container_name`. 

`container_name: mockserver` would be reachable from any app or website that tried to hit mockserver via HTTP. This is due to the nature of how docker resolves container names for any valid entries on that docker network.  Read more https://docs.docker.com/config/containers/container-networking/#:~:text=In%20the%20same,on%20that%20network.
## persistent-compose aka Cockroach Proxies
If you need a Sauce Connect Proxy to stay up indefinitely. Some organizations, large or small, need a set of shared Sauce Connect Pools that automatically restart when they go down.

