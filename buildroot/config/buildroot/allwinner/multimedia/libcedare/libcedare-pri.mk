cedarx_path := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
include ${cedarx_path}/*/*.mk
#include ../config/buildroot/cedarx/cedarx-demo/cedarx-demo.mk
