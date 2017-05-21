#!/bin/bash
set -e

#clean?
if [ "$1" == "clean" ]; then
    rm -fr build
    exit 0
fi

#SETUP ALIGNMENTS:
ttslab_setup_voicebuild.py \
-w recordings/chunked/wavs \
-u recordings/chunked/utts.data \
-o build

#replace 'default' setup with one in etc...
rm -fr build/etc/*
cp etc/* build/etc
