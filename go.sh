#!/bin/bash -xe
(cd htk && make && cd -) || (printf "\33[31m[Error]\33[0m failed to make htk\n"; exit -1)
printf "\n\33[34mStart running...\33[0m\n"
decoder=htk/HTKLVRec/HDecode.mod

# INPUTS -- mfcc files to decode
scp=data/small.scp 

# INPUTS -- models
LM=data/lm.arpa.txt
AM=data/final.mmf 
lexicon=data/lexicon.txt
tiedlist=data/tiedlist

# Options
beam=13.0
options="-A -T 1 -a 0.1 -s 1.0 -t $beam -z lat -q tvaldm -o M"

# OUTPUTS -- lattices and one-best recognition results
lat_dir=lat
rec_result=dev.rec

mkdir -p $lat_dir
$decoder $options \
	 -l $lat_dir -i $rec_result \
	 -w $LM -H $AM -S $scp $lexicon $tiedlist
