#!/bin/sh

homedir=`getent passwd root | cut -d: -f6`

yum install -y git
mkdir ${homedir}/repos
cd ${homedir}/repos
git clone https://github.com/carolynduby/ApacheMetronWorkshop.git
git clone https://github.com/carolynduby/MetronSamples.git
