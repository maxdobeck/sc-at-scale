# Throttled Network
Throttling/degrading network on a container.

What is this? This squishes two things into a docker container. You can use this as a template for putting 1+ things in a container alongside Sauce Connect, but per the Docker manifesto/ethos you should have 1:1 for 1 service living in 1 container. 

However sometimes this is easier. So in this example we are using TC `traffic control` to mess with Sauce Connect's ability to perform. See the various settings like Packet Loss below.

## Running
Build `docker build -t="throttler"  .`

Run `docker run -e USER=$SAUCE_USERNAME -e KEY=$SAUCE_ACCESS_KEY -p 3333:3333 --rm -it --cap-add=NET_ADMIN throttler`

## Notes

#### Show current settings
`tc qdisc show dev eth0`

#### Reset tc settings
`tc qdisc del dev eth0 root`

#### Set Packet Loss %
`tc qdisc change dev eth0 root netem loss 10%`
or a mix: `tc qdisc add dev eth0 root netem loss 0.1% 85%`

#### Really bad internet connection
`tc qdisc add dev eth0 root netem reorder 0.2 duplicate 0.5 corrupt 0.2 delay 500ms`


#### Bad but still working internet connection
`tc qdisc add dev eth0 root netem reorder 0.02 duplicate 0.06 corrupt 0.02 delay 200ms loss`


#### Severely limit upload/download results - Basically Unusable Internet
`tc qdisc add dev eth0 root tbf rate 500kbit burst 16kbit latency 50ms`







Whatever, won't work
```
# tc qdisc add dev eth0 handle 1: ingress
# tc filter add dev eth0 parent 1: protocol ip prio 50 u32 match ip src 0.0.0.0/0 police rate 1mbit burst 10k drop flowid :1
Error: Parent Qdisc doesn't exists.
We have an error talking to the kernel
```


First pass from [comcast](https://github.com/tylertreat/comcast#linux) readme suggestion
```
   Speedtest by Ookla

      Server: YouFibre - Edinburgh (id: 53932)
         ISP: Virgin Media
Idle Latency:   111.72 ms   (jitter: 28.15ms, low: 69.31ms, high: 121.81ms)
    Download:    61.86 Mbps (data used: 89.5 MB)                                                   
                164.90 ms   (jitter: 27.18ms, low: 95.28ms, high: 347.63ms)
      Upload:    50.77 Mbps (data used: 75.4 MB)                                                   
                120.67 ms   (jitter: 28.53ms, low: 47.81ms, high: 692.03ms)
 Packet Loss: Not available.
  Result URL: https://www.speedtest.net/result/c/290470ea-fc5b-45bd-883f-d1c67cea0498
# iptables -A INPUT -m statistic --mode random --probability 0.1 -j DROP
/bin/sh: 17: iptables: not found
# tc qdisc del dev eth0 root netem
# tc qdisc add dev eth0 root netem delay 50ms 20ms dis^C 
```


### Working
OK Now we're gonna have fun. upped to 600ms & 100ms from `$ tc qdisc add dev eth0 root netem delay 50ms 20ms distribution normal`

```
# tc qdisc add dev eth0 root netem delay 600ms 100ms  distribution normal
# speedtest

   Speedtest by Ookla

      Server: Axis Studios Group - Glasgow (id: 56906)
         ISP: Virgin Media
Idle Latency:   624.27 ms   (jitter: 104.17ms, low: 562.49ms, high: 732.19ms)
    Download:    54.94 Mbps (data used: 88.7 MB)                                                   
               1058.02 ms   (jitter: 86.18ms, low: 511.60ms, high: 1635.91ms)
      Upload:    16.70 Mbps (data used: 25.0 MB)                                                   
                935.76 ms   (jitter: 90.84ms, low: 467.17ms, high: 1633.25ms)
 Packet Loss:     0.0%
 ```

 This appears to have worked. 

 So now we add
 `tc qdisc change dev eth0 root netem reorder 0.4 duplicate 0.1 corrupt 0.1 delay 250ms`

 for a total of
 
 ```
 tc qdisc add dev eth0 root netem delay 600ms 100ms  distribution normal
 tc qdisc change dev eth0 root netem reorder 0.4 duplicate 0.1 corrupt 0.1 delay 250ms
 ```

### Packet Loss example
https://www.baeldung.com/linux/throttle-bandwidth

```# tc qdisc change dev eth0 root netem loss 25%
# speedtest

   Speedtest by Ookla

[error] Error: [-3] Try again
[error] Error: [0] Timeout occurred in connect.
[error] Error: [0] Cannot open socket
      Server: Broadband for the Rural North Ltd - Allendale (id: 59030)
         ISP: Virgin Media
Idle Latency:    34.68 ms   (jitter: 119.00ms, low: 29.79ms, high: 262.96ms)
    Download:    61.65 Mbps (data used: 38.2 MB)                                                   
      Upload:    27.60 Mbps (data used: 40.3 MB)                                                   
                171.51 ms   (jitter: 64.03ms, low: 24.98ms, high: 1809.33ms)
 Packet Loss:    21.2%
  Result URL: https://www.speedtest.net/result/c/872afd10-707a-4549-92e5-476b1dbaab25```

  Lets change the packet loss to 10%!
  `tc qdisc change dev eth0 root netem loss 10%`
  The packet loss should hover around 10% now! Your download/upload speed may not change much though, at least when comparing to a speed testing site like speedtest, speed.cloudflare.com, or fast.com.
