#!/bin/bash

train_month_array=(01 03 04 05 07 08 10 11 12)
valid_month_array=(02 06 09)

mkdir -p outputs/train
mkdir -p outputs/test

for month in "${train_month_array[@]}"; do
    if [ -d outputs/training_rundirs/2016${month}0100 ]; then
        cp outputs/training_rundirs/2016${month}0100/rundir/netcdf_output/*.nc outputs/train
    fi
done

for month in "${valid_month_array[@]}"; do
    if [ -d outputs/training_rundirs/2016${month}0100 ]; then
        cp outputs/training_rundirs/2016${month}0100/rundir/netcdf_output/*.nc outputs/test
    fi
done
