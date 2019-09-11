#!/bin/sh

# allow nifi to read squid logs
sudo usermod -a -G squid nifi
