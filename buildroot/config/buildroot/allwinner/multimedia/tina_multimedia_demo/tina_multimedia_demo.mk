tina_multimedia_demo_path := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
include ${tina_multimedia_demo_path}/*/*.mk

