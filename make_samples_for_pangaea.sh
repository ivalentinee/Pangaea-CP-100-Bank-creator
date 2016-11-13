#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_FILE_NAME=preset.pan
CONFIG_FILE_PATH="$SCRIPT_DIRECTORY/$CONFIG_FILE_NAME"
RESULTS_DIRECTORY=Result
BANK_DIRECTORY_NAME=Bank
MAX_PRESETS=10
MAX_BANKS=10
MAX_SAMPLE_LENGTH=20 # NOTE: In milliseconds from 1 to 999. CP-100 cuts it at 20.5ms anyway.

FILES=(*.wav)

function convert_file {
    # NOTE: as told by "soxi -V4" for original samples. Seems to work fine.
    local mSecLength="$(printf "%03d" $MAX_SAMPLE_LENGTH)"
    sox "$1" -t wavpcm -b 24 -e signed-integer -r 48000 -c 1 "$2" trim 0 00:00:00.$mSecLength
}

function add_config_file {
    cp -f $CONFIG_FILE_PATH "$1/$CONFIG_FILE_NAME"
}

function create_preset {
    local file=$1
    local bank_directory_name="$(printf "%s_%s" $BANK_DIRECTORY_NAME $2)"
    local preset_directory_name=Preset_$3

    mkdir -p "$RESULTS_DIRECTORY/$bank_directory_name/$preset_directory_name"
    convert_file "$file" "$RESULTS_DIRECTORY/$bank_directory_name/$preset_directory_name/$file"
    add_config_file "$RESULTS_DIRECTORY/$bank_directory_name/$preset_directory_name/"
}

# Remove old results
rm -rf $RESULTS_DIRECTORY

banksCounter=0
presetsCounter=0
for ((i=0; i < ${#FILES[@]}; i++)); do
    if [ $presetsCounter -ge $MAX_PRESETS ] ; then 
        let "banksCounter = $banksCounter + 1";
        presetsCounter=0;
    fi
    if [ $banksCounter -ge $MAX_BANKS ] ; then 
        break; 
    fi

    FILE=${FILES[i]}
    create_preset "${FILE}" "$banksCounter" "$presetsCounter"

    let "presetsCounter = $presetsCounter + 1"

    echo "Processed \"$FILE\" as Bank #$banksCounter, Preset #$presetsCounter"
done
