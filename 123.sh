#!/bin/bash
#这个脚本格式很乱
if [ -z "$1" ]; then
	echo "缺少参数"
	exit 1
fi

dir="/tmp/test"
file="output.txt"

function say_hello() {
	name=$1
	if [ -n "$name" ]; then
		echo "Hello, $name!"
	else
		echo "Hello, World!"
	fi
}

# 遍历目录
for f in *; do
	if [ -f "$f" ]; then
		echo "File: $f"
	fi
done

case "$1" in
start)
	echo "Starting..."
	;;
stop)
	echo "Stopping..."
	;;
*)
	echo "Unknown command"
	;;
esac

arr=("apple" "banana" "cherry")
for fruit in "${arr[@]}"; do
	echo "I like $fruit"
done

# 嵌套条件
if [ -f "test.txt" ]; then
	if [ -r "test.txt" ]; then
		cat test.txt
	else
		echo "Cannot read"
	fi
else
	echo "File not found"
fi

# 多行命令
long_command="this is a very long string that should be formatted properly but currently is not formatted at all and looks very messy"

# 不一致的缩进
var1=123
var2=456
var3=789

# 函数调用
say_hello "David"
