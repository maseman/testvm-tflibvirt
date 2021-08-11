#!/bin/bash

set -eu

# move to script dir
cd $(dirname $0)

# default to fail
EXIT_CODE=2

IMAGE=../generated/alpine-qemu-agent-static-ip.qcow2

GRAPHICSOPT=

if [ "${QEMU_NOGRAPHICS=no}" = "yes" ]
then
	GRAPHICSOPT=-nographic
fi

# Start qemu session in the background
qemu-system-x86_64 -m 384 -name myvm \
	 ${GRAPHICSOPT} \
	 -drive file=${IMAGE},if=virtio \
	 -chardev socket,path=/tmp/qga.sock,server,nowait,id=qga0 \
	 -device virtio-serial \
	 -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 &

QEMU_PID=$!

TESTMATCH='"ip-address": "192.168.111.111"'

MAXTESTS=20
TESTDELAY=10

for ((i=1; i <= ${MAXTESTS}; i++))
do
	echo "Qemu Guest Agent Test $i of ${MAXTESTS} will begin in ${TESTDELAY} seconds ...zzzz"
	sleep ${TESTDELAY}

	# Query the guest interfaces via qemu-guest-agent in running vm
	QGARESP=$(echo '{"execute": "guest-network-get-interfaces"}' | nc -w 3 -U /tmp/qga.sock || true )

	if echo "${QGARESP}" | grep -q "${TESTMATCH}"
	then
		echo
		echo "SUCCESS: Found ${TESTMATCH} in "
		echo ""
		echo "${QGARESP}"
		echo
		EXIT_CODE=0
		break
	fi

	echo "Qemu Guest Agent Test $i of ${MAXTESTS} FAILED."
	echo
done


kill ${QEMU_PID} || true
exit ${EXIT_CODE}
