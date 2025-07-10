#!/bin/bash

#
# cp ./busybox/init ${TARGET_DIR}/
#

pwd=`cd $(dirname $0);pwd -P`

add_init_to_ramfs()
{
	rm -rf ${TARGET_DIR}/init
	cp -f ${pwd}/busybox/rdinit ${TARGET_DIR}/init
}

add_init_to_ramfs
