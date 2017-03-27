FROM ubuntu:xenial-20160923.1

# Suppress debconf warnings
ENV DEBIAN_FRONTEND noninteractive


# Switch account to root and adding user accounts and password
USER root
RUN echo "root:Docker!" | chpasswd


# Create psr user which will be used to run commands with reduced privileges.
RUN adduser --disabled-password --gecos 'unprivileged user' psr && \
    echo "psr:psr" | chpasswd && \
    mkdir -p /home/psr/.ssh && \
    chown -R psr:psr /home/psr/.ssh


# Create space for ssh deamon and update the system
RUN echo 'deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse' >> /etc/apt/sources.list && \
    mkdir /var/run/sshd && \
    apt-get -y check && \
    apt-get -y update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common python-software-properties && \
    apt-get -y update --fix-missing && \
    apt-get -y upgrade

RUN apt-get -y install \
    apt-utils \
    autoconf \
    automake \
    autotools-dev \
    binutils-dev \
    bison \
    build-essential \
    cmake \
    cmake-curses-gui \
    cmake-data \
    cpp \
    csh \
    curl \
    cvs \
    cython \
    dkms \
    exuberant-ctags \
    f2c \
    fftw-dev \
    fftw2 \
    flex \
    fort77 \
    g++ \
    gawk \
    gcc \
    gfortran \
    ghostscript \
    ghostscript-x \
    git \
    git-core \
    gnuplot \
    gnuplot-x11 \
    gsl-bin \
    gv \
    h5utils \
    hdf5-helpers \
    hdf5-tools \
    hdfview \
    htop \
    hwloc \
    ipython \
    ipython-notebook \
    libatlas-dev \
    libbison-dev \
    libblas-common \
    libblas-dev \
    libblas3 \
    libboost-program-options1.58-dev \
    libboost-python1.58-dev \
    libboost-regex1.58-dev \
    libboost-system1.58-dev \
    libboost1.58-all-dev \
    libboost1.58-dev \
    libboost1.58-tools-dev \
    libc-dev-bin \
    libc6-dev \
    libcfitsio-bin \
    libcfitsio-dev \
    libcfitsio-doc \
    libcfitsio2 \
    libcfitsio3-dev \
    libcloog-isl4 \
    libcppunit-dev \
    libcppunit-subunit-dev \
    libcppunit-subunit0 \
    libfftw3-3 \
    libfftw3-bin \
    libfftw3-dbg \
    libfftw3-dev \
    libfftw3-double3 \
    libfftw3-long3 \
    libfftw3-quad3 \
    libfftw3-single3 \
    libfreetype6 \
    libfreetype6-dev \
    libgd-dev \
    libgd2-xpm-dev \
    libgd3 \
    libglib2.0-0 \
    libglib2.0-dev \
    libgmp3-dev \
    libgsl-dev \
    libgsl2 \
    libgtksourceview-3.0-dev \
    libgtksourceview2.0-dev \
    libhdf5-10 \
    libhdf5-cpp-11 \
    libhdf5-dev \
    libhdf5-serial-dev \
    libhwloc-dev \
    liblapack-dev \
    liblapack-pic \
    liblapack-test \
    liblapack3 \
    liblapacke \
    liblapacke-dev \
    libltdl-dev \
    libltdl7 \
    liblua5.1-0 \
    liblua5.1-0-dev \
    liblua5.2-0 \
    liblua5.2-dev \
    liblua5.3-0 \
    liblua5.3-dev \
    libncurses5-dev \
    libntrack-qt4-1 \
    libopenblas-base \
    libopenblas-dev \
    libpng++-dev \
    libpng-sixlegs-java \
    libpng-sixlegs-java-doc \
    libpng12-0 \
    libpng12-dev \
    libpng3 \
    libpnglite-dev \
    libpth-dev \
    libqt4-dbus \
    libqt4-declarative \
    libqt4-designer \
    libqt4-dev \
    libqt4-dev-bin \
    libqt4-help \
    libqt4-network \
    libqt4-opengl \
    libqt4-opengl-dev \
    libqt4-qt3support \
    libqt4-script \
    libqt4-scripttools \
    libqt4-sql \
    libqt4-sql-mysql \
    libqt4-svg \
    libqt4-test \
    libqt4-xml \
    libqt4-xmlpatterns \
    libqt4pas-dev \
    libqt4pas5 \
    libreadline6 \
    libreadline6-dev \
    libsocket++-dev \
    libsocket++1 \
    libsource-highlight-qt4-3 \
    libssl-dev \
    libtool \
    libx11-dev \
    llvm-3.8 \
    llvm-3.8-dev \
    llvm-3.8-doc \
    llvm-3.8-examples \
    llvm-3.8-runtime \
    locate \
    lsof \
    m4 \
    make \
    man \
    mc \
    nano \
    nfs-common \
    numactl \
    openssh-server \
    pbzip2 \
    pgplot5 \
    pkg-config \
    pkgconf \
    pyqt4-dev-tools \
    python \
    python-dev \
    python-pip \
    python-qt4-dev \
    python-tk \
    qt4-default \
    qt4-linguist-tools \
    qt4-qmake \
    qt4-qtconfig \
    screen \
    source-highlight \
    source-highlight-ide \
    subversion \
    swig2.0 \
    tcsh \
    tk \
    tk-dev \
    tmux \
    vim \
    wcslib-dev \
    wcslib-tools \
    wget \
    zlib1g-dev \
    firefox

# Switch account to psr
USER psr

# Define home, psrhome, OSTYPE and create the directory
ENV HOME /home/psr
ENV PSRHOME /home/psr/software
ENV OSTYPE linux
RUN mkdir -p /home/psr/software

# Downloading all source codes
WORKDIR $PSRHOME
RUN wget http://www.fftw.org/fftw-2.1.5.tar.gz && \
    tar -xvvf fftw-2.1.5.tar.gz  && \
    wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh  && \
    git clone https://github.com/ewanbarr/sigpyproc.git

# Install miniconda to /home/psr/miniconda
USER root
RUN bash Miniconda-latest-Linux-x86_64.sh -p /home/psr/miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/home/psr/miniconda/bin:${PATH}
RUN conda update -y conda
RUN chmod -R 755 /home/psr/miniconda

# Python packages from conda
RUN conda config --add channels https://conda.anaconda.org/openastronomy
RUN conda install -y \
	ipython  \
	jupyter  \
	numpy  \
	scipy  \
	pandas  \
	h5py  \
	astropy  \
	matplotlib  \
	seaborn \
        mpld3 
RUN conda remove -y --force readline
RUN pip install readline -U 
RUN pip install rfipip

# Switch account to psr
USER psr

# sigpyproc
ENV SIGPYPROC $PSRHOME/sigpyproc
ENV PYTHONPATH $PYTHONPATH:$SIGPYPROC/lib/python
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SIGPYPROC/lib/c
WORKDIR $PSRHOME/sigpyproc
RUN python setup.py install --record list.txt

# FFTW2
ENV FFTW2 $PSRHOME/fftw-2.1.5
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$FFTW2/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$FFTW2/install/lib
WORKDIR $FFTW2
RUN ./configure --prefix=$FFTW2/install --enable-threads --enable-float && \
    make -j $(nproc) && \
    make && \
    make install

# Clean downloaded source codes
WORKDIR $PSRHOME
RUN rm -rf ./*.bz2 ./*.gz ./*.xz ./*.ztar ./*.zip

# Put in file with all environmental variables
WORKDIR $HOME
RUN echo "" >> .bashrc && \
    echo "if [ -e \$HOME/.mysetenv.bash ]; then" >> .bashrc && \
    echo "   source \$HOME/.mysetenv.bash" >> .bashrc && \
    echo "fi" >> .bashrc && \
    echo "" >> .bashrc && \
    echo "alias rm='rm -i'" >> .bashrc && \
    echo "alias mv='mv -i'" >> .bashrc && \
    echo "# Set up PS1" >> .mysetenv.bash && \
    echo "export PS1=\"\u@\h [\$(date +%d\ %b\ %Y\ %H:%M)] \w> \"" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Define home, psrhome, software, OSTYPE" >> .mysetenv.bash && \
    echo "export HOME=/home/psr" >> .mysetenv.bash && \
    echo "export PSRHOME=/home/psr/software" >> .mysetenv.bash && \
    echo "export OSTYPE=linux" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Up arrow search" >> .mysetenv.bash && \
    echo "export HISTFILE=\$HOME/.bash_eternal_history" >> .mysetenv.bash && \
    echo "export HISTFILESIZE=" >> .mysetenv.bash && \
    echo "export HISTSIZE=" >> .mysetenv.bash && \
    echo "export HISTCONTROL=ignoreboth" >> .mysetenv.bash && \
    echo "export HISTIGNORE=\"l:ll:lt:ls:bg:fg:mc:history::ls -lah:..:ls -l;ls -lh;lt;la\"" >> .mysetenv.bash && \
    echo "export HISTTIMEFORMAT=\"%F %T \"" >> .mysetenv.bash && \
    echo "export PROMPT_COMMAND=\"history -a\"" >> .mysetenv.bash && \
    echo "bind '\"\e[A\":history-search-backward'" >> .mysetenv.bash && \
    echo "bind '\"\e[B\":history-search-forward'" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    
    echo "# SIGPROC" >> .mysetenv.bash && \
    echo "export FC=gfortran" >> .mysetenv.bash && \
    echo "export F77=gfortran" >> .mysetenv.bash && \
    echo "export CC=gcc" >> .mysetenv.bash && \
    echo "export CXX=g++" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \

    echo "# sigpyproc" >> .mysetenv.bash && \
    echo "export SIGPYPROC=\$PSRHOME/sigpyproc" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$SIGPYPROC/lib/c" >> .mysetenv.bash && \
    echo "export PYTHONPATH=\$PYTHONPATH:$SIGPYPROC/lib/python" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    
    echo "# FFTW2" >> .mysetenv.bash && \
    echo "export FFTW2=\$PSRHOME/fftw-2.1.5" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$FFTW2/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$FFTW2/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \

    echo "# Miniconda" >> .mysetenv.bash && \
    echo "export PATH=/home/psr/miniconda/bin:${PATH}" >> .mysetenv.bash && \
    echo "export PYTHONPATH=\$PYTHONPATH:/home/psr/miniconda/bin/python" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    /bin/bash -c "source $HOME/.bashrc"



# Update database for locate and run sshd server and expose port 22
USER root
RUN updatedb
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]



