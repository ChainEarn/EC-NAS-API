#!/bin/bash

# 查找第一个可用loop设备
find_available_loop() {
	local loop_dev=$(losetup -f 2>/dev/null)
	if [[ -n "$loop_dev" ]]; then
		echo "$loop_dev"
		return 0
	fi
	return 1
}

# 创建新的loop设备
create_new_loop() {
	# 获取最后一个数字编号的loop设备
	local last_loop=$(ls /dev/loop[0-9]* 2>/dev/null | grep -E '/dev/loop[0-9]+$' | sort -V | tail -1)

	# 计算下一个编号（无设备时默认从0开始）
	local next_num=0
	if [[ -n "$last_loop" ]]; then
		next_num=$(( ${last_loop#/dev/loop} + 1 ))
	fi


	mknod -m 0660 /dev/loop$next_num b 7 $next_num || {
		echo "Failed to create /dev/loop$next_num" >&2
			return 1
		}
	echo "/dev/loop$next_num"
}

main() {
	local loop_dev=$(find_available_loop)
	if [ ! -b "$loop_dev" ]; then
		echo "No available loop device found, creating new one..."
		loop_dev=$(create_new_loop) || exit 1
	fi
	echo "Available loop device: $loop_dev"
}

main

