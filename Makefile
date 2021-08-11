
configs = qemu-agent-static-ip

images = $(configs:%=dist/alpine-%.qcow2)
hashes = $(addsuffix .sha256,$(images))

all: $(images) $(hashes)

tool/alpine-make-vm-image:
	script/get_alpine-make-vm-image_script.bash

generated/alpine-%.qcow2: tool/alpine-make-vm-image
	script/make_custom_image.bash $*

dist/alpine-%.qcow2.sha256: dist/alpine-%.qcow2
	cd dist; sha256sum $(<F) > ./$(@F)

dist/alpine-%.qcow2: generated/alpine-%.qcow2
	script/verify_$*.bash ; cp -p $< $@ ;

clean:
	rm -f $(images) $(hashes)

clean-tool:
	rm -f tool/alpine-make-vm-image

cleanall: clean clean-tool

.PHONY: clean  clean-tool cleanall
