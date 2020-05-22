#!/usr/bin/env bash

#
# Copyright 2020 Richard Case
#

# munin plugin to display VPS CPU throughput

file="/root/cputime/elapsed.log"
tmp="/root/cputime/tmp.log"
avg="0"
max="0"

mv "$file" "$tmp" >/dev/null 2>&1
if [ ! -f "$tmp" ]; then touch "$tmp"; fi

parse_elapsed() {
  i="0"
  while read -r num
  do
    avg=$(bc -l <<<"((($avg * $i) + $num) / ($i + 1))")
    if [ "1" -eq $(bc -l <<<"$max < $num") ]; then max="$num"; fi
    ((i++))
  done < "$tmp"
  rm "$tmp"
}

if [ "$1" == "config" ]; then
  echo "graph_title CPU throughput"
  echo "graph_category vps"
  echo "graph_vlabel seconds"
  echo "graph_info This graph monitors the time taken to do a fixed amount of work"

  echo "cpu_max.label maximum"
  echo "cpu_max.type GAUGE"
  echo "cpu_max.min 0"
  echo "cpu_max.draw AREA"

  echo "cpu_avg.label average"
  echo "cpu_avg.type GAUGE"
  echo "cpu_avg.min 0"
  echo "cpu_avg.draw LINE2"
else
  parse_elapsed
  echo "cpu_max.value $max"
  echo "cpu_avg.value $avg"
fi
