#!/bin/bash

set -e
set -u
set -o pipefail

# move to script dir
cd $(dirname $0)

VERSION=v0.7.0
CHECKSUM=9803170e07b05b97eb6712e6a9097ad656954d0f
ALPSCRIPT=alpine-make-vm-image
TOOLDIR=../tool
ALPTOOL=${TOOLDIR}/${ALPSCRIPT}

if [ ! -d ${TOOLDIR} ]
then
	echo "FATAL: ${TOOLDIR} is NOT a directory"
	exit 1
fi

if [ ! -f ${ALPTOOL} ]
then
	wget -O ${ALPTOOL} https://raw.githubusercontent.com/alpinelinux/alpine-make-vm-image/${VERSION}/${ALPSCRIPT}
	if echo "${CHECKSUM} ${ALPTOOL}" | sha1sum -c
	then
		chmod u+x ${ALPTOOL}
	else
		echo "FATAL: BAD CHECKSUM removing ${ALPTOOL}"
		rm -f ${ALPTOOL}
		exit 1
	fi
else
	echo "${ALPTOOL} is ALREADY downloaded"
fi
