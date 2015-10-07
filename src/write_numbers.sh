#!/bin/bash

set -u

start=$1
end=$2

i=$start
while [ $i -lt $end ]
do
  echo -n "${i} "
  let i=i+1 
done

echo "${i}"
