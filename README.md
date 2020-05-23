## Deprecated, [see here](https://github.com/casesolved-co-uk/munin-stress-ng)

# cpu-throughput
Munin plugin for measuring cpu throughput, as a bash shell script

On load testing a web server, I noticed huge variation in VPS latency but couldn't find any real cause, so wrote this to check the cpu throughput.

The idea is:
 - Run a cpu-bound, fixed task and measure the elapsed time. In this case it's the time taken to do a sha512sum of a large block of data from memory. Output sequential measurements to a log over an extended period of time
 - Every munin collection period, calculate the average and maximum measurements, display on a graph, and delete the log

NOTE: This currently only exercises 1 CPU core, so may not be as useful on multi-core machines

## Dependencies
 - munin
 - bash
 - bc
 - od
 - date
 - sha512sum

## How to use
1. Clone the repo in `/root/`

2. Link the `plugin.sh` file to your plugins, for example:

`ln -s /root/cpu-throughput/plugin.sh /etc/munin/plugins/vps`

3. Configure the plugin to run as root (not actually required, but I cloned as root):

`/etc/munin/plugin-conf.d/munin-node`

    [vps]
    user root

5. `service munin-node restart`

6. Run the `cpu-throughput.sh` script:

`./cpu-throughput.sh [1200] &`

  - optionally provide a run time in seconds, by default it runs for a minimum of 20 minutes and quits
