CC = g++
OPTIMIZATioN ?= -O2
WARNINGS = -Wno-missing-field-initializers
DEBUG ?= -g -ggdb
INCLUDE = -Iinclude/fmodex
REAL_CFLAGS = $(OPTIMIZATioN) -fPIC $(CFLAGS) $(WARNINGS) $(DEBUG) $(INCLUDE)
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

build: build/wave_encoder.o build/file.o build/o2jam/music.o \
	build/o2jam/music_render.o build/o2jam/ojm.o build/o2jam/ojn.o \
	build/io.o build/renderer.o
	$(CC) build/wave_encoder.o build/file.o build/o2jam/music.o \
		build/o2jam/music_render.o build/o2jam/ojm.o build/o2jam/ojn.o \
		build/io.o build/renderer.o lib/fmodex/osx/libfmodex.dylib \
		-lboost_program_options -lboost_date_time -ltag -lmp3lame -lsndfile \
		-o bin/ojn_renderer

build/wave_encoder.o: src/nx/audio/wave_encoder.cpp src/nx/audio/wave_encoder.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/file.o: src/nx/io/file.cpp src/nx/io/file.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/music.o: src/nx/o2jam/music.cpp src/nx/o2jam/music.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/music_render.o: src/nx/o2jam/music_renderer.cpp src/nx/o2jam/music_renderer.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/ojm.o: src/nx/o2jam/ojm.cpp src/nx/o2jam/ojm.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/ojn.o: src/nx/o2jam/ojn.cpp src/nx/o2jam/ojn.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/io.o: src/nx/io.cpp src/nx/io.h
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/renderer.o: src/render_ojn.cpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

install:
	cp lib/fmodex/osx/libfmodex.dylib /usr/local/lib/ && \
		rm /usr/local/bin/ojn_renderer && \
		ln -s $(ROOT_DIR)/bin/ojn_renderer /usr/local/bin/ojn_renderer

clean:
	@rm -rf build/**/*.o

.PHONY: build
