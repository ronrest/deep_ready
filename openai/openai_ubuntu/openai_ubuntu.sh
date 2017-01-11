#!/bin/bash

# terminate script if any line returns a non-zero exit status
set -e
echo "==========================================================="
echo "                            INSTALL THE DEVELOPER LIBRARIES"
echo "==========================================================="
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential git  swig
sudo apt-get install -y python-pip python-dev python-wheel python-virtualenv
sudo apt-get install -y unzip

# Needed for Open AI
sudo apt-get install -y golang libjpeg-turbo8-dev make
#
#
