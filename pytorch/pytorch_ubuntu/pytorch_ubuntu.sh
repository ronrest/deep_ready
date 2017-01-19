#!/usr/bin/env bash

################################################################################
# Automated script for setting up PyTorch on Ubuntu.
# By: Ronny Restrepo
#
# STEPS TAKEN BY SCRIPT:
#   - Installs system dependencies
#   - Creates a python virtual environment, which installs:
#   - -  Common useful Python packages for Machine Learning and Image processing
#   - -  - Numpy, Scipy, Pandas, Matplotlib and Pillow
#   - - And PyTorch of course.
#
# DEFAULTS:
#    - Python Version: 2.7          (but you can set it to 3.5)
#    - CPU version of PyTorch.
#
#   These values can be set in the VARIABLES section.
#
# VIRTUALENV
#   By default it also creates a Python Virtual Environment
#   called "pytorch" located in the "~/virtualenvs" directory
#   (which is created automatically). All the python packages
#   are installed in this virtualenv.
#   You can specify a different directory where you store
#   your virtualenvs and the name of the new virtualenv in
#   the VARIABLES section.
#
# LIMITATIONS
#
# CREDITS
# Some of the steps are based on code from the following sources:
# - http://pytorch.org/
#
# TODOS
# - Add option for installing with GPU support.
#
################################################################################

# terminate script if any line returns a non-zero exit status
set -e

#-------------------------------------------------------------------------------
#                                                                      VARIABLES
#-------------------------------------------------------------------------------
# Modify these variables to suit your needs.

PYTHON_VERSION="2.7"             # Change this to 3.5 if desired.
VIRTUAL_ENV_NAME="pytorch"       # Name you want to give your virtualenv
VIRTUAL_ENV_ROOT="~/virtualenvs" # Where your virtual envs are stored.
                                 # NOTE: no trailing forward slash at the end


#-------------------------------------------------------------------------------
#                                                                          START
#-------------------------------------------------------------------------------
START_DIR=pwd   # Store Initial Working Directory

echo "==========================================================="
echo "                            INSTALL THE DEVELOPER LIBRARIES"
echo "==========================================================="
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential git  swig
sudo apt-get install -y python-pip python-dev python-wheel python-virtualenv
sudo apt-get install -y unzip


echo "==========================================================="
echo "                                   SETUP PYTORCH VIRTUALENV"
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



if [ ${PYTHON_VERSION} = "2.7" ]
then
    echo "==========================================================="
    echo "                         INSTALL PYTORCH FOR PYTHON 2.7 CPU"
    echo "==========================================================="
    pip install https://s3.amazonaws.com/pytorch/whl/torch-0.1.6.post17-cp27-cp27mu-linux_x86_64.whl
    pip install https://s3.amazonaws.com/pytorch/whl/torchvision-0.1.6-py2-none-any.whl

elif [ ${PYTHON_VERSION} = "3.5" ]
then
    echo "==========================================================="
    echo "                         INSTALL PYTORCH FOR PYTHON 3.5 CPU"
    echo "==========================================================="
    pip install https://s3.amazonaws.com/pytorch/whl/torch-0.1.6.post17-cp35-cp35m-linux_x86_64.whl
    pip install https://s3.amazonaws.com/pytorch/whl/torchvision-0.1.6-py3-none-any.whl

else
    echo "Not a valid version of python!" 1>&2
    exit 64
fi

# TODO: Add GPU support
##Python 2.7 GPU CUDA 8
#pip install https://s3.amazonaws.com/pytorch/whl/torch_cuda80-0.1.6.post17-cp27-cp27mu-linux_x86_64.whl
#pip install https://s3.amazonaws.com/pytorch/whl/torchvision-0.1.6-py2-none-any.whl



echo "==========================================================="
echo "                                               FINISHING UP"
echo "==========================================================="
echo "EXITING VIRTUALENV"
deactivate

# Go back to the directory we started off at.
cd ${START_DIR}

