#!/bin/bash

FOLDER_NAME=Bank
MAX_PRESETS=10
MAX_FILES=10
MAX_SAMPLE_LENGTH=20 # NOTE: In milliseconds from 1 to 999. CP-100 cuts it at 20.5ms anyway.

FILES=(*.wav)

function convert_file {
    # NOTE: as told by "soxi -V4" for original samples. Seems to work fine.
    local mSecLength="$(printf "%03d" $MAX_SAMPLE_LENGTH)"
    sox "$1" -t wavpcm -b 24 -e signed-integer -r 48000 -c 1 "$2" trim 0 00:00:00.$mSecLength
}

function create_preset {
    local file=$1
    local preset_name=Preset_$2
    local preset_folder_name=$FOLDER_NAME/$preset_name
    local sample_name=$preset_folder_name/$file

    mkdir -p $preset_folder_name
    convert_file "$file" "$sample_name"
}

rm -rf $FOLDER_NAME

folderCounter=0
processedFiles=0
for ((i=0; i < ${#FILES[@]}; i++)); do
    if [ $processedFiles -ge $MAX_FILES ] ; then 
        let "folderCounter = $folderCounter + 1"; 
        processedFiles=0; 
    fi
    if [ $folderCounter -ge $MAX_PRESETS ] ; then 
        break; 
    fi

    FILE=${FILES[i]}
    create_preset "${FILE}" "$folderCounter"

    let "processedFiles = $processedFiles + 1"

    echo "Processed \"$FILE\" as Preset #$folderCounter"
done
