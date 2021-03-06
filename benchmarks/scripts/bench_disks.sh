#!/bin/bash

device=$1
bench_file=$2
echo 3 | sudo tee /proc/sys/vm/drop_caches

write_out=$((dd if=/dev/zero of=$device bs=2M count=512 conv=notrunc status=progress)  2>&1)
echo ${write_out}
write_bw=`echo ${write_out} | awk '{print $(NF-1),",",$NF}' | tr -d ' '`
echo ${device},write,${write_bw} >> ${bench_file}

cached_out=$((dd if=$device of=/dev/null bs=2M count=512 status=progress) 2>&1)
echo ${cached_out}
cached_bw=`echo ${cached_out} | awk '{print $(NF-1),",",$NF}' | tr -d ' '`
echo ${device},cached,${cached_bw} >> ${bench_file}

echo 3 | sudo tee /proc/sys/vm/drop_caches
read_out=$((dd if=$device of=/dev/null bs=2M count=512 status=progress) 2>&1)
echo ${read_out}
read_bw=`echo ${read_out} | awk '{print $(NF-1),",",$NF}' | tr -d ' '`
echo ${device},read,${read_bw} >> ${bench_file}

rm $device

