CC = g++
OPTIMIZATION ?= -O2
WARNINGS = -Wno-missing-field-initializers
DEBUG ?= -g -ggdb
INCLUDE = -Iinclude/fmodex
REAL_CFLAGS = $(OPTIMIZATION) -fPIC $(CFLAGS) $(WARNINGS) $(DEBUG) $(INCLUDE)
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

echo-path:
	@echo $(ROOT_DIR)

default: build

build/wave_encoder.o: src/Nx/Audio/WaveEncoder.cpp src/Nx/Audio/WaveEncoder.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/file.o: src/Nx/IO/File.cpp src/Nx/IO/File.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/music.o: src/Nx/O2Jam/Music.cpp src/Nx/O2Jam/Music.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/music_render.o: src/Nx/O2Jam/MusicRenderer.cpp src/Nx/O2Jam/MusicRenderer.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/ojm.o: src/Nx/O2Jam/OJM.cpp src/Nx/O2Jam/OJM.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/o2jam/ojn.o: src/Nx/O2Jam/OJN.cpp src/Nx/O2Jam/OJN.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/io.o: src/Nx/IO.cpp src/Nx/IO.hpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build/renderer.o: src/RenderOJN.cpp
	$(CC) -c $(REAL_CFLAGS) $< -o $@

build: build/wave_encoder.o build/file.o build/o2jam/music.o \
	build/o2jam/music_render.o build/o2jam/ojm.o build/o2jam/ojn.o \
	build/io.o build/renderer.o
	$(CC) build/wave_encoder.o build/file.o build/o2jam/music.o \
		build/o2jam/music_render.o build/o2jam/ojm.o build/o2jam/ojn.o \
		build/io.o build/renderer.o lib/fmodex/osx/libfmodex.dylib \
		-lboost_program_options -lboost_date_time -ltag -lmp3lame -lsndfile \
		-o bin/ojn_renderer
		
install: build
	cp lib/fmodex/osx/libfmodex.dylib /usr/local/lib/ && \
		rm /usr/local/bin/ojn_renderer && \
		ln -s $(ROOT_DIR)/bin/ojn_renderer /usr/local/bin/ojn_renderer

clean:
	@rm -rf build/**/*.o

.PHONY: build echo-pach
