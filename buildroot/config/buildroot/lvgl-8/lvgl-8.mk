lvgl_path := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
include ${lvgl_path}/*/*.mk
include ../config/buildroot/lvgl-8/sunxifb.mk
