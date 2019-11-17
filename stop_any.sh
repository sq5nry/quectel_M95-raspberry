#!/bin/bash
echo stopping any running wvdial...
killall wvdial

while pgrep wvdial >/dev/null; do
	echo waiting for wvdial session to terminate...
	sleep 1
done

echo session terminated successfully

