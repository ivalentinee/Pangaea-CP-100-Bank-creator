#!/bin/bash

FOLDER_NAME=Bank
MAX_PRESETS=9
MAX_SAMPLE_LENGTH=3 # NOTE: In milliseconds from 1 to 9. CP-100 cuts it at 2ms anyway.

FILES=(*.wav)

function convert_file {
    # NOTE: as told by "soxi -V4" for original samples. Seems to work fine.
    sox "$1" -t wavpcm -b 24 -e signed-integer -r 48000 "$2" trim 0 00:00:00.0$MAX_SAMPLE_LENGTH
}

function create_preset {
    local file=$1
    local preset_name=Preset_$i
    local preset_folder_name=$FOLDER_NAME/$preset_name
    local sample_name=$preset_folder_name/$file

    mkdir -p $preset_folder_name
    rm -rf $preset_folder_name/*.wav
    convert_file "$file" "$sample_name"
}

for ((i=0; i < ${#FILES[@]}; i++)); do
    if [ $i -gt $MAX_PRESETS ] ; then break ; fi

    FILE=${FILES[i]}
    create_preset "${FILE}"

    echo "Processed \"$FILE\" as Preset #$i"
done
