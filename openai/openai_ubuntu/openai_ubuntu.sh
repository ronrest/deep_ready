#!/bin/bash

# terminate script if any line returns a non-zero exit status
set -e

#-------------------------------------------------------------------------------
#                                                                      VARIABLES
#-------------------------------------------------------------------------------
# Modify these variables to suit your needs.

PYTHON_VERSION="2.7"             # Change this to 3.5 if desired.
VIRTUAL_ENV_NAME="openai"        # Name you want to give your virtualenv
VIRTUAL_ENV_ROOT="~/virtualenvs" # Where your virtual envs are stored.
                                 # NOTE: no trailing forward slash at the end
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


echo "==========================================================="
echo "                                    SETUP OPENAI VIRTUALENV"
echo "==========================================================="
echo "CREATING VIRTUALENV"
mkdir -p ${VIRTUAL_ENV_ROOT}
cd ${VIRTUAL_ENV_ROOT}
virtualenv -p /usr/bin/python${PYTHON_VERSION} ${VIRTUAL_ENV_NAME}

echo "ENTERING VIRTUALENV"
. ${VIRTUAL_ENV_ROOT}/${VIRTUAL_ENV_NAME}/bin/activate

#
#
