#!/bin/bash
set -e

#clean?
if [ "$1" == "clean" ]; then
    rm -fr build/halign build/textgrids
    exit 0
fi

#args:
VOICEFILE=$1

#temporarily setup paths to find tools:
source ./paths.sh
ORIGSYSPATH=$PATH
export PATH=`echo $HTS_BIN`:`echo $ORIGSYSPATH`

#DO ALIGNMENTS:
cd build
ttslab_align.py $VOICEFILE to_textgrid
ttslab_align.py $VOICEFILE alignments_from_textgrid

#restore original paths:
export PATH=$ORIGSYSPATH
