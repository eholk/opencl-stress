PROJECT_ROOT = $(shell pwd)

ifndef RUSTC
	export RUSTC = rustc
endif

ifndef TARGET_DIR
	export TARGET_DIR = $(PROJECT_ROOT)/build
endif

all: deps progs

build:
	mkdir build

deps: build
	make -C external

progs:
	make -C src
