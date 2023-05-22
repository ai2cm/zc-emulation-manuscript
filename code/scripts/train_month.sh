#!/bin/bash

# Example usage: ./train_month.sh 01

timestamp="2016${1}0100"
output_folder=/outputs/training_rundirs/$timestamp

# Create output folder
if [ ! -d "$output_folder" ]; then
  mkdir -p $output_folder
fi

export IC_URL=/fv3gfs_inputs/gfs_initial/monthly/$timestamp
export MONTH_INT=${1}

# Copy in envsubst training file
envsubst < /code/simulation/train-template.yaml > $output_folder/tmp.yaml
prepare-config $output_folder/tmp.yaml > $output_folder/fv3config.yaml
rm $output_folder/tmp.yaml

# Run training simulation
cd $output_folder
runfv3 run-native fv3config.yaml ./rundir
