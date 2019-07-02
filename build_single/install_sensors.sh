#!/bin/bash
pushd sensor_install
./sensor_install_phase.sh ../single-node-es-sensor-config.txt ../sensors pre_ambari.sh
popd
