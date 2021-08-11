#!/bin/bash

set -eu

# move to script dir
cd $(dirname $0)

SUBD=${1}
CONFD=../config/${SUBD}
TOOL=../tool/alpine-make-vm-image
TARGETD=../generated
TARGETFILE=alpine-${SUBD}.qcow2
TARGET=${TARGETD}/${TARGETFILE}
SHRUNKTARGET=${TARGETD}/shrunk-${TARGETFILE}

# check location
test -d ${CONFD} || exit 1

# cleanup old target
rm -f ${TARGET}

sudo ${TOOL} \
	--image-format qcow2 \
	--image-size 512M \
	--repositories-file ${CONFD}/repositories \
	--packages "$(cat ${CONFD}/packages)" \
	--script-chroot \
	${TARGET} -- ${CONFD}/configure.sh

CURRENT_USER=$(id --name --user)
sudo /bin/chown ${CURRENT_USER}:${CURRENT_USER} ${TARGET}

# reclaim sparse space
qemu-img convert -O qcow2 ${TARGET} ${SHRUNKTARGET}
mv ${SHRUNKTARGET} ${TARGET}
