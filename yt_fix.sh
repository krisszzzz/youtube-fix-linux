#!/bin/sh -e

# require networkManager to acquire wifi device
NET_IFACE=$(nmcli --get-values GENERAL.DEVICE,GENERAL.TYPE device show | grep -B 2 wifi | head -1)

# path to zapret binaries, change for coresponding arch
ZAPRET_BIN=zapret/binaries/x86_64
echo using wife device: ${NET_IFACE}, path to zapret: ${ZAPRET_BIN}

sudo ${ZAPRET_BIN}/nfqws --qnum=200 --dpi-desync=disorder2 --dpi-desync-split-pos=1 --hostlist=youtube-domain.txt &
sudo iptables -I OUTPUT -o ${NET_IFACE} -p tcp --dport 443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
sudo ip6tables -I OUTPUT -o ${NET_IFACE} -p tcp --dport 443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass


