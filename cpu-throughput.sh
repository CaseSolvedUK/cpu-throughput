#!/usr/bin/env bash

counter=$(od -An -N8 -t uL /dev/random)
datagen() {
  data=""
  for i in $(seq 1 10000)
  do
    printf -v c "%032u" $((counter++))
    data+="$c"
  done
  echo $data
  unset data
}

# Run for 20mins (1200s)
duration="1200"
if [ $1 -gt $duration ]; then duration="$1"; fi

end=$(($(date -u +%s)+duration))
while [ $(date -u +%s) -lt $end ]
do
  start=$(date -u +%s.%N)
  sha512sum >/dev/null 2>&1 <<<$(datagen)
  elapsed=$(bc -l <<<"$(date -u +%s.%N)-$start")
  printf "%s\n" $elapsed >> elapsed.log
done
