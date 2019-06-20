#!/bin/bash

source sensor_install_funcs.sh

if (( $# != 3 )); then
    echo "Usage: " $0 " <config file> <sensors path> <phase_script>"
    exit
fi

config_file=$1
sensor_path=$2
phase_script=$3


read_config_vars $config_file

# make sure sensor config directory exists
if [ ! -d "$sensor_path" ]; then
   echo "Sensor definition path " $sensor_path " does not exist."
   exit
fi 
 
tmpdir=`mktemp -p . -d installout.XXXXXXXXXX`
currentdir=`pwd`
installoutdir=$currentdir/$tmpdir


IFS=","
for sensor in $INSTALLED_SENSORS
do
    script_file="$currentdir/$sensor_path/$sensor/$phase_script"
    if [ -f "$script_file" ]; then
        if [ -x "$script_file" ]; then
            output_file=$installoutdir/${sensor}_${phase_script}_out
            echo Running $script_file Output file is $output_file
            pushd $sensor_path/$sensor && eval "$script_file > $output_file 2>&1" && popd
        else 
            echo "ERROR: Script " $script_file " for sensor " $sensor " is not executable."
        fi
    else
        echo "Sensor " $sensor " does not have script $script_file."
    fi
done
