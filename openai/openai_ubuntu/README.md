# Automated script for setting up OpenAI Universe on Ubuntu (14.04 abd 16.04)
By: Ronny Restrepo


## STEPS:
This script will go through the following steps
- Installs system dependencies
- Installs Docker (which is needed by Open AI) This can be disabled 
  if you already have docker installed. 
- Creates a python virtual environment, which installs 
    - Common useful Python packages for Machine Learning and Image processing
    - Tensorflow, Numpy, Scipy, Pandas, Matplotlib and Pillow
    - And the OpenAI Universe of course.

## DEFAULTS:
- **OS Version    :** Ubuntu 14.04 (but you can set it to 16.04)
- **Python Version:** 2.7          (but you can set it to 3.5)
- **Docker Version:** 1.12.6-0     (But you can set it to any other version 
  that your package manager has access to)

These values can be set in the VARIABLES section of the script. 
Aditional settings you can change in the variables section are: 

- `VIRTUAL_ENV_NAME`="openai" 
    - The name you want to give your Python virtual environment
- `VIRTUAL_ENV_ROOT`="~/virtualenvs" 
    - Where your virtual envs are stored.
    - **NOTE:** There should be no trailing forward slash at the end
- `INSTALL_DOCKER`=true
    - Set to false if you already have docker installed. 
- `DOCKER_VERSION`="1.12.6-0"
     - Change to desired version. 
     - **NOTE:** Must be a precise version number that will appear in 
       the package manager of your operating system. 


## VIRTUALENV
By default it also creates a Python Virtual Environment
called "openai" located in the "~/virtualenvs" directory
(which is created automatically). All the python packages
are installed in this virtualenv.
You can specify a different directory where you store
your virtualenvs and the name of the new virtualenv in
the VARIABLES section.

## LIMITATIONS
Currently it is not set up to support other versions of
ubuntu other than 14.04 and 16.04, but it should be easy
to get it work by modifying some bits of code. Each step
is clearly explained.

Even though this script allows you to set whatever
version of Python you have installed in your system,
the openai system may not work on versions other than
python 2.7 and 3.5

## TODOS
- Allow option to only install some of these things
- Add GPU Tensorflow option
- Support for other

## DEBUGGING:
### UNMET DEPENDENCIES ERROR
When installing `linux-image-extra-virtual`, if you get an error message
such as the following:

    linux-image-extra-virtual : Depends: linux-image-generic (= 3.13.0.107.115)
    but it is not going to be installed
    E: Unable to correct problems, you have held broken packages.

Here are some potential fixes: 

1. Run the following command:

        sudo apt-get -y install -f

    Then pick up where you left off before. If this gives the same error
    message, then try the next fix.

2. The error message gives you a version of `linux-image-generic` that it is
    looking for, but not finding, and not wanting to install.
    You can explicitly install this version on the command line. Lets say
    the version it was looking for was 3.13.0.107.115, then we can force
    it to install that version using:

        sudo apt-get install linux-image-generic=3.13.0.107.115

    NOTE: Make sure you change the number to the version that the error
    message was telling you to use.



## CREDITS
Many of the steps are based on code from the following sources:
- https://github.com/openai/universe
- https://docs.docker.com/engine/installation/linux/ubuntulinux/
- https://www.tensorflow.org/get_started/os_setup

