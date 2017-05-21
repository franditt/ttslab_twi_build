#!/bin/bash
set -e

#setup paths to find tools:
source paths.sh


#args:
VOICEFILE=$1
PROCESS=$2


#temporarily setup paths to find tools:                                                
export ORIGSYSPATH=$PATH
export PATH=$EST_BIN:$ORIGSYSPATH

if [ "$PROCESS" == "feats" ]; then
    cd build
    ttslab_make_wordunits.py $VOICEFILE ./etc/feats.conf make_features
fi

if [ "$PROCESS" == "catalogue" ]; then
    cd build
    ttslab_make_wordunits.py $VOICEFILE ./etc/feats.conf make_catalogue
fi

#restore original paths:                                                                                  
export PATH=$ORIGSYSPATH
