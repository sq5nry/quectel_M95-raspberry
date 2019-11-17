#!/bin/bash
VTTY_FILE=/tmp/ttyV0

echo starting script
if test -L "$VTTY_FILE"; then
    echo "$VTTY_FILE already exists. Terminate existing session and try again, exiting."
    exit -2
fi

echo setting HW uart baud rate
stty -F /dev/ttyAMA0 115200

echo starting virtual shadow tty for UART...
#socat /dev/ttyAMA0,raw,echo=0 SYSTEM:'tee in.txt |socat - "PTY,link=/tmp/ttyV0,raw,echo=0,waitslave" |tee out.txt' &
socat /dev/ttyAMA0,raw,echo=0 PTY,link=/tmp/ttyV0,raw,echo=0,waitslave &

echo waiting for virtual tty to come up...
while [ ! -L "$VTTY_FILE" ] ;
do
  echo -ne .
  sleep 1
done
echo
echo ttyV0 found

#echo setting target baud rate...
#stty -F "$VTTY_FILE" 115200
stty -F "$VTTY_FILE" --all

echo starting vwdial
wvdial orange.quectel &
echo done

