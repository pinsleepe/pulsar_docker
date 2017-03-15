# pulsar_docker
Builds a docker image for a pulsar analysis packages with sigpyproc and few extras on Ubuntu 16.04 LTS. Base forked from @mserylak. 

# Includes
- sigpyproc
- miniconda with:
	- numpy
	- scipy
	- pandas
	- h5py
	- astropy
	- matplotlib
	- seaborn
- and all their dependencies (fftw, etc)

You'll find all pulsar software in /home/psr/software, environment variables are set according to ~/.mysetenv.bash file.

# Using
To build:

    docker build -t pulsar_docker .

To run image:

    docker run -it pulsar_docker /bin/bash

To mount data directory into the docker container with the -v flag:

    docker run -it -v <data_location>:/data pulsar_docker /bin/bash

This will drop you in to an ubuntu os with bash shell with all data in /data.

To run the image with X11 and mounted data directory, run the container first:

    docker run -d -p 2222:22 -v <data_location>:/data pulsar_docker

Check if container is running with docker ps -a. You can log in using **psr** as password:

    ssh -XY psr@localhost -p 2222

# Issues
Change permissions on /miniconda folder: TODO.
Report problems to mobrocka@ska.ac.za
