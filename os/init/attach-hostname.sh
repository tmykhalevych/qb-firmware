#!bin/sh

QB_HOSTNAME="qb"

echo "$QB_HOSTNAME" > $PWD/etc/hostname
echo "127.0.0.1 localhost\n127.0.1.1 $QB_HOSTNAME" > $PWD/etc/hosts
