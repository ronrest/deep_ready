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

# Link to the tensorflow package. Change to desired version
# depending on operating system, and if you want GPU support
# List of available links here: https://www.tensorflow.org/get_started/os_setup
TF_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.1-cp27-none-linux_x86_64.whl


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


echo "==========================================================="
echo "                                   INSTALL PYTHON LIBRARIES"
echo "==========================================================="
echo "UPGRADING PIP"
pip install --upgrade pip
sudo apt-get update

echo "INSTALLING NUMPY AND SCIPY"
sudo apt-get install -y libopenblas-dev  # Speeds up numpy/scipy
sudo apt-get install -y liblapack-dev gfortran # Needed for scipy/numpy
pip install numpy
pip install scipy
# sudo apt-get install -y python-numpy


echo "INSTALLING PANDAS"
sudo apt-get install -y python-tk  # Needed by Pandas
pip install pytz                   # Needed by pandas
pip install pandas

# Libraries for image processing
echo "INSTALLING PILLOW IMAGE PROCESSING LIBRARY"
sudo apt-get install -y libjpeg-dev libpng12-dev    # Needed by pillow
pip install Pillow

echo 'INSTALL MATPLOTLIB'
sudo apt-get build-dep -y matplotlib       # download and build needed dependencies
pip install -U matplotlib                  # force matplotlib rebuild

echo 'INSTALLING ADITIONAL USEFUL PYTHON LIBRARIES'
pip install h5py



echo "==========================================================="
echo "                                         INSTALL TENSORFLOW"
echo "==========================================================="
pip install --upgrade $TF_URL

#
#
