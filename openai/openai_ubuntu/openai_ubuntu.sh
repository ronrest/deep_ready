#!/bin/bash
################################################################################
# Automated script for setting up OpenAI Universe on Ubuntu.
# By: Ronny Restrepo
#
# STEPS:
#   - Installs system dependencies
#   - Installs Docker (which is needed by Open AI)
#   - Creates a python virtual environment, which installs:
#   - -  Common useful Python packages for Machine Learning and Image processing
#   - -  - Tensorflow, Numpy, Scipy, Pandas, Matplotlib and Pillow
#   - - And OpenAI Universe of course.
#
# DEFAULTS:
#    - OS Version    : Ubuntu 14.04 (but you can set it to 16.04)
#    - Python Version: 2.7          (but you can set it to 3.5)
#    - Docker Version: 1.12.6-0     (But you can set it to any other version
#                                    that your package manager has access to)
#
#   These values can be set in the VARIABLES section.
#
# VIRTUALENV
#   By default it also creates a Python Virtual Environment
#   called "openai" located in the "~/virtualenvs" directory
#   (which is created automatically). All the python packages
#   are installed in this virtualenv.
#   You can specify a different directory where you store
#   your virtualenvs and the name of the new virtualenv in
#   the VARIABLES section.
#
# LIMITATIONS
#   Currently it is not set up to support other versions of
#   ubuntu other than 14.04 and 16.04, but it should be easy
#   to get it work by modifying some bits of code. Each step
#   is clearly explained.
#
#   Even though this script allows you to set whatever
#   version of Python you have installed in your system,
#   the openai system may not work on versions other than
#   python 2.7 and 3.5
#
# KNOWN ISSUES:
#   - Scroll right down to the very bottom to the DEBUG
#     section to see error messages that might pop up
#     and how to fix them.
#
# CREDITS
# Many of the steps are based on code from the following sources:
#   - https://github.com/openai/universe
#   - https://docs.docker.com/engine/installation/linux/ubuntulinux/
#   - https://www.tensorflow.org/get_started/os_setup
#
# TODOS
#   - Allow option to only install some of these things
#   - Add GPU Tensorflow option
#   - Support for other
################################################################################

# terminate script if any line returns a non-zero exit status
set -e

#-------------------------------------------------------------------------------
#                                                                      VARIABLES
#-------------------------------------------------------------------------------
# Modify these variables to suit your needs.

OS_VERSION="14.04"               # Set up to work with 14.04 and 16.04
PYTHON_VERSION="2.7"             # Change this to 3.5 if desired.
VIRTUAL_ENV_NAME="openai"        # Name you want to give your virtualenv
VIRTUAL_ENV_ROOT="~/virtualenvs" # Where your virtual envs are stored.
                                 # NOTE: no trailing forward slash at the end
INSTALL_DOCKER=true              # Set to false if you already have docker
DOCKER_VERSION="1.12.6-0"        # Change to desired version.
                                 # NOTE: Must be a precise version number that
                                 #       will appear in the package manager.


# Link to the tensorflow package. Change to desired version
# depending on operating system, and if you want GPU support
# List of available links here: https://www.tensorflow.org/get_started/os_setup
TF_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.1-cp27-none-linux_x86_64.whl


#-------------------------------------------------------------------------------
#                                                        OS DEPENDENT OPERATIONS
#-------------------------------------------------------------------------------
if [ ${OS_VERSION} == "16.04" ]
then
    DOCKER_VERSION="${DOCKER_VERSION}~ubuntu-xenial"
    DK_REPO="deb https://apt.dockerproject.org/repo ubuntu-xenial main"
else
    # This next line needed for ubuntu 14.04, but not needed for 16.04
    sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable  # for newer golang
    DOCKER_VERSION="${DOCKER_VERSION}~ubuntu-trusty"
    DK_REPO="deb https://apt.dockerproject.org/repo ubuntu-trusty main"
fi


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


if [ ${INSTALL_DOCKER} == true ]
then
    echo "==========================================================="
    echo "                                             INSTALL DOCKER"
    echo "==========================================================="
    # Instructions from here:
    #   https://docs.docker.com/engine/installation/linux/ubuntulinux/
    sudo apt-get install -y apt-transport-https ca-certificates

    echo "ADDING GPG KEY"
    sudo apt-key adv \
                   --keyserver hkp://ha.pool.sks-keyservers.net:80 \
                   --recv-keys 58118E89F3A912897C070ADBF76221572C52609D


    echo "ADDING DOCKER REPO TO THE PACKAGES LIST"
    echo ${DK_REPO} | sudo tee /etc/apt/sources.list.d/docker.list

    echo "UPDATING PACKAGES LIST"
    sudo apt-get update

    echo "DEFENDING AGAINST UNMET DEPENDENCIES"
    # First level of defence against potential unmet dependencies errors for
    # "linux-image-extra-virtual"
    sudo apt-get -y install -f

    echo "INSTALL LINUX-IMAGE-EXTRA-* PACKAGES"
    #linux-image-extra-* kernel packages, allows you use the aufs storage driver.
    sudo apt-get install -y linux-image-extra-$(uname -r)

    echo "INSTALL LINUX-IMAGE-EXTRA-VIRTUAL PACKAGE"
    # This one could be problematic, see DEBUG section for known issues.
    sudo apt-get install -y linux-image-extra-virtual

    echo "INSTALL DOCKER"
    sudo apt-get -y install docker-engine=${DOCKER_VERSION}

    ## Install the latest version of Docker
    #sudo apt-get install docker-engine

    ## Get list of available versions on apt-get
    #apt-cache madison docker-engine

    echo "START THE DOCKER DAEMON"
    sudo service docker start

    echo "VERIFYING DOCKER INSTALLATION IS CORRECT"
    sudo docker run hello-world

    # https://github.com/openai/universe#install-docker
    #docker ps

else
    echo "==========================================================="
    echo "                               SKIPPING DOCKER INSTALLATION"
    echo "==========================================================="
fi



echo "==========================================================="
echo "                                INSTALLING OPEN AI UNIVERSE"
echo "==========================================================="
#git clone https://github.com/openai/universe.git
#cd universe
#pip install -e .
pip install -e git+https://github.com/openai/universe.git#egg=universe



echo "==========================================================="
echo "                                               FINISHING UP"
echo "==========================================================="
echo "EXITING VIRTUALENV"
deactivate

# Go back to the directory we started off at.
cd ${START_DIR}



################################################################################
# DEBUG
################################################################################

# ------------------------------------------------------------------------------
#                                                       UNMET DEPENDENCIES ERROR
# ------------------------------------------------------------------------------
# When installing `linux-image-extra-virtual`, if you get an error message
# such as the following:
#
#   linux-image-extra-virtual : Depends: linux-image-generic (= 3.13.0.107.115)
#   but it is not going to be installed
#   E: Unable to correct problems, you have held broken packages.
#
# FIXES:
# 1. Run the following command:
#
#       sudo apt-get -y install -f
#
#    Then pick up where you left off before. If this gives the same error
#    message, then try the next fix.
#
# 2. The error message gives you a version of `linux-image-generic` that it is
#    looking for, but not finding, and not wanting to install.
#    You can explicitly install this version on the command line. Lets say
#    the version it was looking for was 3.13.0.107.115, then we can force
#    it to install that version using:
#
#       sudo apt-get install linux-image-generic=3.13.0.107.115
#
#    NOTE: Make sure you change the number to the version that the error
#    message was telling you to use.
#

