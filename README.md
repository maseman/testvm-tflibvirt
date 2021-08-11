# Custom alpine virtual machine image with installed qemu-guest-agent.

![Image Generation](https://github.com/maseman/testvm-tflibvirt/actions/workflows/ci.yml/badge.svg)

## Download

https://github.com/maseman/testvm-tflibvirt/releases/latest/download/alpine-qemu-agent-static-ip.qcow2


## Utilizes

https://github.com/alpinelinux/alpine-make-vm-image

## Purpose

Used to test qemu-guest-agent bugfix in terraform libvirt provider.

https://github.com/maseman/terraform-provider-libvirt


## Details

This is a minimal alpine image with the qemu-guest-agent package installed.

A static IP address **192.168.111.111** is configured on eth0 in the VM.

This address is returned in the response when running the VM using QEMU via the QMP command shown below.

`{"execute": "guest-network-get-interfaces"}`

This  is used to validate the build.


## Local build

### Requirements

 - wget
 - make
 - qemu-system-x86
 - qemu-utils
 - netcat

### Setup

Requires sudo privileges for ./tool/alpine-make-vm-image and /bin/chown.

(sudo is needed because alpine-make-vm-image requires access to /dev/nbdx and the image is initially created with root ownership).

### Build image

`make`

Creates ./dist/alpine-qemu-agent-static-ip.qcow2

### Make environment options

`QEMU_NOGRAPHICS=yes make`

Adds -nographic to qemu image verification. Used in github workflow.















