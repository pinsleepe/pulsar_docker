# Copyright (C) 2016 by Maciej Serylak
# Licensed under the Academic Free License version 3.0
# This program comes with ABSOLUTELY NO WARRANTY.
# You are free to modify and redistribute this code as long
# as you do not remove the above attribution and reasonably
# inform receipients that you have modified the original work.


FROM ubuntu:xenial-20160923.1


MAINTAINER Maciej Serylak "mserylak@ska.ac.za"


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
    zlib1g-dev 

# Switch account to psr
USER psr


# Define home, psrhome, OSTYPE and create the directory
ENV HOME /home/psr
ENV PSRHOME /home/psr/software
ENV OSTYPE linux
RUN mkdir -p /home/psr/software


# Downloading all source codes
WORKDIR $PSRHOME
RUN wget http://www.imcce.fr/fr/presentation/equipes/ASD/inpop/calceph/calceph-2.3.2.tar.gz && \
    tar -xvvf calceph-2.3.2.tar.gz -C $PSRHOME && \
    wget http://ds9.si.edu/download/ubuntu14/ds9.ubuntu14.7.5.tar.gz && \
    mkdir $PSRHOME/ds9-7.5 && \
    tar -xvvf ds9.ubuntu14.7.5.tar.gz -C $PSRHOME/ds9-7.5 && \
    wget http://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/fv/fv5.4_pc_linux64.tar.gz && \
    tar -xvvf fv5.4_pc_linux64.tar.gz -C $PSRHOME && \
    wget http://www.atnf.csiro.au/people/pulsar/psrcat/downloads/psrcat_pkg.tar.gz && \
    tar -xvf psrcat_pkg.tar.gz -C $PSRHOME && \
    wget http://www.iausofa.org/2016_0503_C/sofa_c-20160503_c.tar.gz && \
    tar -xvvf sofa_c-20160503_c.tar.gz && \
    wget http://www.iausofa.org/2016_0503_F/sofa_f-20160503_c.tar.gz && \
    tar -xvvf sofa_f-20160503_c.tar.gz && \
    wget http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz && \
    tar -xvvf szip-2.1.tar.gz && \
    wget https://www.hdfgroup.org/ftp/HDF5/tools/h5check/src/h5check-2.0.1.tar.gz && \
    tar -xvvf h5check-2.0.1.tar.gz && \
    wget http://bsdforge.com/projects/source/devel/clig/clig-1.9.11.2.tar.xz && \
    tar -xvvf clig-1.9.11.2.tar.xz && \
    wget http://www.bastoul.net/cloog/pages/download/cloog-0.18.4.tar.gz && \
    tar -xvvf cloog-0.18.4.tar.gz && \
    wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz && \
    tar -xvvf ctags-5.8.tar.gz && \
    wget http://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.46.tar.gz && \
    tar -xvvf GeographicLib-1.46.tar.gz && \
    wget http://www.hdfgroup.org/ftp/HDF5/projects/jpss/h5edit/h5edit-1.3.1.tar.gz && \
    tar -xvvf h5edit-1.3.1.tar.gz && \
    wget http://www.leptonica.com/source/leptonica-1.74.1.tar.gz && \
    tar -xvvf leptonica-1.74.1.tar.gz && \
    wget http://downloads.sourceforge.net/project/tvmet/Tar.Gz_Bz2%20Archive/1.7.2/tvmet-1.7.2.tar.bz2 && \
    tar -xvvf tvmet-1.7.2.tar.bz2 && \
    wget http://www.fftw.org/fftw-2.1.5.tar.gz && \
    tar -xvvf fftw-2.1.5.tar.gz && \
    wget http://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/fitsverify-4.18.tar.gz && \
    tar -xvvf fitsverify-4.18.tar.gz && \
    wget http://bitbucket.org/eigen/eigen/get/3.3.2.tar.bz2 && \
    tar -xvvf 3.3.2.tar.bz2 && \
    wget http://downloads.sourceforge.net/project/healpix/Healpix_3.31/Healpix_3.31_2016Aug26.tar.gz && \
    tar -xvvf Healpix_3.31_2016Aug26.tar.gz && \
    wget ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar && \
    wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh  && \
    git clone https://github.com/SixByNine/psrxml.git && \
    git clone https://bitbucket.org/psrsoft/tempo2.git && \
    git clone https://git.code.sf.net/p/tempo/tempo && \
    git clone https://git.code.sf.net/p/psrchive/code psrchive && \
    git clone https://github.com/SixByNine/sigproc.git && \
    git clone https://github.com/ewanbarr/sigpyproc.git && \
    git clone https://github.com/nextgen-astrodata/DAL.git && \
    git clone https://git.code.sf.net/p/dspsr/code dspsr && \
    git clone https://github.com/weltevrede/psrsalsa.git && \
    git clone https://github.com/demorest/pypsrfits.git && \
    git clone https://github.com/scottransom/presto.git && \
    git clone https://github.com/scottransom/psrfits2psrfits.git && \
    git clone https://github.com/scottransom/psrfits_utils.git && \
    git clone https://github.com/scottransom/pyslalib.git && \
    git clone https://github.com/ArisKarastergiou/Vpsr.git && \
    git clone https://github.com/SheffieldML/GPy.git && \
    git clone https://github.com/mserylak/coast_guard.git


# Install miniconda to /miniconda
USER root
RUN bash Miniconda-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}
RUN conda update -y conda

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
	seaborn  
RUN conda remove -y --force readline
RUN pip install readline -U 

# Switch account to psr
USER psr

# PGPLOT
ENV PGPLOT_DIR /usr/lib/pgplot5
ENV PGPLOT_FONT /usr/lib/pgplot5/grfont.dat
ENV PGPLOT_INCLUDES /usr/include
ENV PGPLOT_BACKGROUND white
ENV PGPLOT_FOREGROUND black
ENV PGPLOT_DEV /xs



# calceph
ENV CALCEPH $PSRHOME/calceph-2.3.2
ENV PATH $PATH:$CALCEPH/install/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CALCEPH/install/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$CALCEPH/install/include
WORKDIR $CALCEPH
RUN ./configure --prefix=$CALCEPH/install --with-pic --enable-shared --enable-static --enable-fortran --enable-thread && \
    make && \
    make check && \
    make install


# ds9
ENV PATH $PATH:$PSRHOME/ds9-7.5


# fv
ENV PATH $PATH:$PSRHOME/fv5.4


# psrcat
ENV PSRCAT_FILE $PSRHOME/psrcat_tar/psrcat.db
ENV PATH $PATH:$PSRHOME/psrcat_tar
WORKDIR $PSRHOME/psrcat_tar
RUN /bin/bash makeit


# PSRXML
ENV PSRXML $PSRHOME/psrxml
ENV PATH $PATH:$PSRXML/install/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PSRXML/install/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$PSRXML/install/include
WORKDIR $PSRXML
RUN autoreconf --install --warnings=none
RUN ./configure --prefix=$PSRXML/install && \
    make && \
    make install


# tempo
ENV TEMPO $PSRHOME/tempo
ENV PATH $PATH:$PSRHOME/tempo/bin
WORKDIR $PSRHOME/tempo
RUN ./prepare && \
    ./configure --prefix=$PSRHOME/tempo && \
    make && \
    make install && \
    echo " 5109943.1050  2003650.7359     -3239908.3195  1  KAT-7               k  K7" >> obsys.dat && \
    echo " 5109318.8410  2006836.3673    -3238921.7749   1  MEERKAT             m  MK" >> obsys.dat && \
    awk '{print $(NF-1), $0}' obsys.dat | sort -V | cut -d\  -f2-


# tempo2
ENV TEMPO2 $PSRHOME/tempo2/T2runtime
ENV PATH $PATH:$PSRHOME/tempo2/T2runtime/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$PSRHOME/tempo2/T2runtime/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PSRHOME/tempo2/T2runtime/lib
WORKDIR $PSRHOME/tempo2
# A fix to get rid of: returned a non-zero code: 126.
RUN sync && perl -pi -e 's/chmod \+x/#chmod +x/' bootstrap
RUN ./bootstrap && \
    ./configure --x-libraries=/usr/lib/x86_64-linux-gnu --with-calceph=$CALCEPH/install/lib --enable-shared --enable-static --with-pic F77=gfortran CPPFLAGS="-I"$CALCEPH"/install/include" && \
    make -j $(nproc) && \
    make install && \
    make plugins-install


# Eigen 3
ENV EIGEN3 $PSRHOME/eigen-eigen-da9b4e14c255
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$EIGEN3/install/include/eigen3
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:$EIGEN3/install
WORKDIR $EIGEN3
RUN mkdir $EIGEN3/install
WORKDIR $EIGEN3/install
RUN cmake -DCMAKE_INSTALL_PREFIX=$EIGEN3/install .. &&\
    make install


# HEALPix
ENV HEALPIX $PSRHOME/Healpix_3.31
ENV PATH $PATH:$HEALPIX/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$HEALPIX/lib
ENV PKG_CONFIG_PATH $PKG_CONFIG_PATH:$HEALPIX/lib
ENV HEALPIX_TARGET optimized_gcc
WORKDIR $HEALPIX
# A fix to avoid using highly interactive HEALPix configure script (seriously, why make such script?).
RUN mkdir bin lib include && \
    cp Makefile.in Makefile && \
    awk '!x{x=sub("ALL.*=.*c-void cpp-void f90-void healpy-void.*","ALL = c-all cpp-all f90-all healpy-void")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("TESTS.*=.*c-void cpp-void f90-void healpy-void.*","TESTS = c-test cpp-test f90-test healpy-void")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("CLEAN.*=.*c-void cpp-void f90-void healpy-void.*","CLEAN = c-clean cpp-clean f90-clean healpy-void")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("TIDY.*=.*c-void cpp-void f90-void healpy-void.*","TIDY = c-tidy cpp-tidy f90-tidy healpy-void")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("DISTCLEAN.*=.*c-void cpp-void f90-void healpy-void.*","DISTCLEAN = c-distclean cpp-distclean f90-distclean healpy-void")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("HEALPIX=","HEALPIX = '"$HEALPIX"'")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_BINDIR.*=.*","F90_BINDIR = '"$HEALPIX"'/bin")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_INCDIR.*=.*","F90_INCDIR = '"$HEALPIX"'/include")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_LIBDIR.*=.*","F90_LIBDIR = '"$HEALPIX"'/lib")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("FITSDIR.*=.*","FITSDIR = /usr/lib/x86_64-linux-gnu")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("LIBFITS.*=.*","LIBFITS = cfitsio")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_BUILDDIR.*=.*","F90_BUILDDIR = '"$HEALPIX"'/build")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_FFTSRC.*=.*","F90_FFTSRC = healpix_fft")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_FC.*=.*","F90_FC = gfortran")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_FFLAGS.*=.*","F90_FFLAGS = -O3 -I$(F90_INCDIR) -DGFORTRAN -fno-second-underscore -fPIC")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_CC.*=.*","F90_CC = gcc")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_CFLAGS.*=.*","F90_CFLAGS = -O3 -std=c99 -DgFortran -fPIC")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_LDFLAGS.*=.*","F90_LDFLAGS = -L$(F90_LIBDIR) -L$(FITSDIR) -lhealpix -lhpxgif -l$(LIBFITS) -Wl,-R$(FITSDIR)")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_AR.*=.*","F90_AR = ar -rsv")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_I8FLAG.*=.*","F90_I8FLAG = -fdefault-integer-8")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_LIBSUFFIX.*=.*","F90_LIBSUFFIX = .a")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_PGFLAG.*=.*","F90_PGFLAG = -DPGPLOT")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_PGLIBS.*=.*","F90_PGLIBS = -L/usr/local/pgplot -lpgplot -L/usr/X11R6/lib -lX11")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_MOD.*=.*","F90_MOD = mod")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_MODDIR.*=.*","F90_MODDIR = \"-J\"")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("F90_OS.*=.*","F90_OS = Linux")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_CC.*=.*","C_CC = gcc")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_PIC.*=.*","C_PIC = -fPIC")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_OPT.*=.*","C_OPT = -O2 -Wall")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_LIBDIR.*=.*","C_LIBDIR = '"$HEALPIX"'/lib")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_INCDIR.*=.*","C_INCDIR = '"$HEALPIX"'/include")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_AR.*=.*","C_AR = ar -rsv")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_WITHOUT_CFITSIO.*=.*","C_WITHOUT_CFITSIO = 0")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_CFITSIO_INCDIR.*=.*","C_CFITSIO_INCDIR = /usr/include")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_CFITSIO_LIBDIR.*=.*","C_CFITSIO_LIBDIR = /usr/lib/x86_64-linux-gnu")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_WLRPATH.*=.*","C_WLRPATH = -Wl,-R/usr/lib/x86_64-linux-gnu")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("C_ALL.*=.*","C_ALL = c-static c-shared")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("HEALPIX_TARGET.*=.*","HEALPIX_TARGET = optimized_gcc")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("CFITSIO_EXT_LIB.*=.*","CFITSIO_EXT_LIB = -L/usr/lib/x86_64-linux-gnu -lcfitsio")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    awk '!x{x=sub("CFITSIO_EXT_INC.*=.*","CFITSIO_EXT_INC = -I/usr/include")}1' Makefile > temp.tmp && mv temp.tmp Makefile && \
    make -j $(nproc)


# PSRCHIVE
ENV PSRCHIVE $PSRHOME/psrchive/install
ENV PATH $PATH:$PSRCHIVE/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$PSRCHIVE/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PSRCHIVE/lib
ENV PYTHONPATH $PYTHONPATH:$PSRCHIVE/lib/python2.7/site-packages
WORKDIR $PSRHOME/psrchive
RUN ./bootstrap && \
    ./configure --prefix=$PSRCHIVE --x-libraries=/usr/lib/x86_64-linux-gnu --with-psrxml-dir=$PSRXML/install --enable-shared --enable-static F77=gfortran LDFLAGS="-L"$PSRXML"/install/lib" LIBS="-lpsrxml -lxml2" && \
    make -j $(nproc) && \
    make && \
    make install
WORKDIR $HOME
RUN echo "Predictor::default = tempo2" >> .psrchive.cfg && \
    echo "Predictor::policy = default" >> .psrchive.cfg


# SOFA C-library
ENV SOFA $PSRHOME/sofa
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$SOFA/20160503_c/c/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SOFA/20160503_a/c/install/lib
WORKDIR $SOFA/20160503_c/c/src
RUN sed -i 's|INSTALL_DIR = $(HOME)|INSTALL_DIR = $(SOFA)/20160503_c/c/install|g' makefile && \
    make && \
    make test


# SOFA FORTRAN-library
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SOFA/20160503_c/f77/install/lib
WORKDIR $SOFA/20160503_c/f77/src
RUN sed -i 's|INSTALL_DIR = $(HOME)|INSTALL_DIR = $(SOFA)/20160503_c/f77/install|g' makefile && \
    make && \
    make test


# SIGPROC
ENV SIGPROC $PSRHOME/sigproc
ENV PATH $PATH:$SIGPROC/install/bin
ENV FC gfortran
ENV F77 gfortran
ENV CC gcc
ENV CXX g++
WORKDIR $SIGPROC
RUN ./bootstrap && \
    ./configure --prefix=$SIGPROC/install --x-libraries=/usr/lib/x86_64-linux-gnu --enable-shared LDFLAGS="-L"$TEMPO2"/lib" LIBS="-ltempo2" && \
    make && \
    make install


# sigpyproc
ENV SIGPYPROC $PSRHOME/sigpyproc
ENV PYTHONPATH $PYTHONPATH:$SIGPYPROC/lib/python
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SIGPYPROC/lib/c
WORKDIR $PSRHOME/sigpyproc
RUN python setup.py install --record list.txt


# szlib
ENV SZIP $PSRHOME/szip-2.1
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$SZIP/install/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$SZIP/install/include
WORKDIR $SZIP
RUN ./configure --prefix=$SZIP/install && \
    make && \
    make install


# h5check
ENV H5CHECK $PSRHOME/h5check-2.0.1
ENV PATH $PATH:$H5CHECK/install/bin
WORKDIR $H5CHECK
RUN ./configure --prefix=$H5CHECK/install && \
    make && \
    make install


# DAL
ENV DAL $PSRHOME/DAL
ENV PATH $PATH:$DAL/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$DAL/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$DAL/install/lib
WORKDIR $DAL
RUN mkdir build
WORKDIR $DAL/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=$DAL/install && \
    make -j $(nproc) && \
    make && \
    make install


# DSPSR
ENV DSPSR $PSRHOME/dspsr
ENV PATH $PATH:$DSPSR/install/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$DSPSR/install/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$DSPSR/install/include
WORKDIR $DSPSR
RUN ./bootstrap && \
    echo "apsr asp bcpm bpsr caspsr cpsr cpsr2 dummy fits kat lbadr lbadr64 lofar_dal lump lwa puma2 sigproc ska1" > backends.list && \
    ./configure --prefix=$DSPSR/install --x-libraries=/usr/lib/x86_64-linux-gnu CPPFLAGS="-I"$DAL"/install/include -I/usr/include/hdf5/serial" LDFLAGS="-L"$DAL"/install/lib -L/usr/lib/x86_64-linux-gnu/hdf5/serial -L"$PSRXML"/install/lib" LIBS="-lpgplot -lcpgplot -lpsrxml -lxml2 -lstdc++" && \
    make -j $(nproc) && \
    make && \
    make install


# clig
ENV CLIG $PSRHOME/clig
ENV PATH $PATH:$CLIG/instal/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CLIG/instal/lib
WORKDIR $CLIG
RUN sed -i 's|prefix =/usr|prefix=$(CLIG)/instal|g' makefile && \
    make && \
    make install


# CLooG
ENV CLOOG $PSRHOME/cloog-0.18.4
ENV PATH $PATH:$CLOOG/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$CLOOG/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$CLOOG/install/lib
WORKDIR $CLOOG
RUN ./configure --prefix=$CLOOG/install && \
    make && \
    make install


# Ctags
ENV CTAGS $PSRHOME/ctags-5.8
ENV PATH $PATH:$CTAGS/install/bin
WORKDIR $CTAGS
RUN ./configure --prefix=$CTAGS/install && \
    make && \
    make install


# GeographicLib
ENV GEOLIB $PSRHOME/GeographicLib-1.46
ENV PATH $PATH:$GEOLIB/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$GEOLIB/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$GEOLIB/install/lib
ENV PYTHONPATH $PYTHONPATH:$GEOLIB/install/lib/python/site-packages
WORKDIR $GEOLIB
RUN ./configure --prefix=$GEOLIB/install && \
    make && \
    make install


# h5edit
ENV H5EDIT $PSRHOME/h5edit-1.3.1
ENV PATH $PATH:$H5EDIT/install/bin
WORKDIR $H5EDIT
RUN ./configure --prefix=$H5EDIT/install CFLAGS="-Doff64_t=__off64_t" LDFLAGS="-L/usr/lib/x86_64-linux-gnu/hdf5/serial" LIBS="-lhdf5 -lhdf5_hl" CPPFLAGS=-I/usr/include/hdf5/serial && \
    make && \
    make install


# Leptonica
ENV LEPTONICA $PSRHOME/leptonica-1.74.1
ENV PATH $PATH:$LEPTONICA/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$LEPTONICA/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$LEPTONICA/install/lib
WORKDIR $LEPTONICA
RUN ./configure --prefix=$LEPTONICA/install && \
    make && \
    make install


# tvmet
ENV TVMET $PSRHOME/tvmet-1.7.2
ENV PATH $PATH:$TVMET/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$TVMET/install/include
WORKDIR $TVMET
RUN ./configure --prefix=$TVMET/install && \
    make && \
    make install


# FFTW2
ENV FFTW2 $PSRHOME/fftw-2.1.5
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$FFTW2/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$FFTW2/install/lib
WORKDIR $FFTW2
RUN ./configure --prefix=$FFTW2/install --enable-threads --enable-float && \
    make -j $(nproc) && \
    make && \
    make install


# fitsverify
ENV FITSVERIFY $PSRHOME/fitsverify
ENV PATH $PATH:$FITSVERIFY
WORKDIR $FITSVERIFY
RUN gcc -o fitsverify ftverify.c fvrf_data.c fvrf_file.c fvrf_head.c fvrf_key.c fvrf_misc.c -DSTANDALONE -I/usr/include -L/usr/lib/x86_64-linux-gnu -lcfitsio -lm -lnsl


# PSRSALSA
ENV PSRSALSA $PSRHOME/psrsalsa
ENV PATH $PATH:$PSRSALSA/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PSRSALSA/src/lib
WORKDIR $PSRSALSA
RUN make


# pypsrfits
ENV PYPSRFITS $PSRHOME/pypsrfits
ENV PYTHONPATH $PYTHONPATH:PYPSRFITS/install
WORKDIR $PYPSRFITS
RUN python setup.py install --record list.txt --prefix=$PYPSRFITS/install


# PRESTO
ENV PRESTO $PSRHOME/presto
ENV PATH $PATH:$PRESTO/bin
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PRESTO/lib
ENV PYTHONPATH $PYTHONPATH:$PRESTO/lib/python
WORKDIR $PRESTO/src
# RUN make makewisdom
RUN make prep && \
    make
WORKDIR $PRESTO/python/ppgplot_src
RUN mv _ppgplot.c _ppgplot.c_ORIGINAL && \
    wget https://raw.githubusercontent.com/mserylak/pulsar_docker/master/ppgplot/_ppgplot.c
WORKDIR $PRESTO/python
RUN make


# psrfits2psrfits
ENV PSRFITS2PSRFITS $PSRHOME/psrfits2psrfits
ENV PATH $PATH:$PSRFITS2PSRFITS
WORKDIR $PSRFITS2PSRFITS
RUN make


# psrfits_utils
ENV PSRFITS_UTILS $PSRHOME/psrfits_utils
ENV PATH $PATH:$PSRFITS_UTILS/install/bin
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$PSRFITS_UTILS/install/include
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$PSRFITS_UTILS/install/lib
WORKDIR $PSRFITS_UTILS
RUN sed -i 's|-Werror foreign|-Werror foreign -Wno-extra-portability|g' configure.ac && \
    ./prepare && \
    ./configure --prefix=$PSRFITS_UTILS/install && \
    make && \
    make install


# pyslalib
ENV PYSLALIB $PSRHOME/pyslalib
ENV PYTHONPATH $PYTHONPATH:PYSLALIB/install
WORKDIR $PYSLALIB
RUN python setup.py install --record list.txt --prefix=$PYSLALIB/install


# Vpsr
ENV VPSR $PSRHOME/Vpsr
ENV PATH $PATH:$VPSR


# GPy
ENV GPY $PSRHOME/GPy
ENV PATH $PATH:$GPY
WORKDIR $GPY
# This is a (bad) workaround for complains about installing in non-specific directory.
USER root
RUN python setup.py install --record list.txt && \
    chown -R psr:psr $HOME/.config
USER psr


# coast_guard
ENV COAST_GUARD $PSRHOME/coast_guard
ENV PATH $PATH:$COAST_GUARD:$COAST_GUARD/coast_guard
ENV COASTGUARD_CFG $COAST_GUARD/configurations
ENV PYTHONPATH $PYTHONPATH:$COAST_GUARD:$COAST_GUARD/coast_guard


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
    echo "# PGPLOT" >> .mysetenv.bash && \
    echo "export PGPLOT_DIR=/usr/lib/pgplot5" >> .mysetenv.bash && \
    echo "export PGPLOT_FONT=/usr/lib/pgplot5/grfont.dat" >> .mysetenv.bash && \
    echo "export PGPLOT_INCLUDES=/usr/include" >> .mysetenv.bash && \
    echo "export PGPLOT_BACKGROUND=white" >> .mysetenv.bash && \
    echo "export PGPLOT_FOREGROUND=black" >> .mysetenv.bash && \
    echo "export PGPLOT_DEV=/xs" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# calceph" >> .mysetenv.bash && \
    echo "export CALCEPH=\$PSRHOME/calceph-2.3.2" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$CALCEPH/install/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CALCEPH/install/lib" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$CALCEPH/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# ds9" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRHOME/ds9-7.5" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# fv" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRHOME/fv5.4" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# psrcat" >> .mysetenv.bash && \
    echo "export PSRCAT_FILE=\$PSRHOME/psrcat_tar/psrcat.db" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRHOME/psrcat_tar" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# psrXML" >> .mysetenv.bash && \
    echo "export PSRXML=\$PSRHOME/psrxml" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRXML/install/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PSRXML/install/lib" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$PSRXML/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# tempo" >> .mysetenv.bash && \
    echo "export TEMPO=\$PSRHOME/tempo" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$TEMPO/bin" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# tempo2" >> .mysetenv.bash && \
    echo "export TEMPO2=\$PSRHOME/tempo2/T2runtime" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$TEMPO2/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$TEMPO2/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$TEMPO2/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Eigen 3" >> .mysetenv.bash && \
    echo "export EIGEN3=\$PSRHOME/eigen-eigen-da9b4e14c255" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$EIGEN3/install/include/eigen3" >> .mysetenv.bash && \
    echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:\$EIGEN3/install" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# HEALPix" >> .mysetenv.bash && \
    echo "export HEALPIX=\$PSRHOME/Healpix_3.31" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$HEALPIX/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HEALPIX/lib" >> .mysetenv.bash && \
    echo "export PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:\$HEALPIX/lib" >> .mysetenv.bash && \
    echo "export HEALPIX_TARGET=optimized_gcc" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# PSRCHIVE" >> .mysetenv.bash && \
    echo "export PSRCHIVE=\$PSRHOME/psrchive/install" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRCHIVE/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$PSRCHIVE/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PSRCHIVE/lib" >> .mysetenv.bash && \
    echo "export PYTHONPATH=\$PYTHONPATH:\$PSRCHIVE/lib/python2.7/site-packages" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# SOFA C-library" >> .mysetenv.bash && \
    echo "export SOFA=\$PSRHOME/sofa" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$SOFA/20160503_c/c/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$SOFA/20160503_c/c/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# SOFA FORTRAN-library" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$SOFA/20160503_c/f77/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# SIGPROC" >> .mysetenv.bash && \
    echo "export SIGPROC=\$PSRHOME/sigproc" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$SIGPROC/install/bin" >> .mysetenv.bash && \
    echo "export FC=gfortran" >> .mysetenv.bash && \
    echo "export F77=gfortran" >> .mysetenv.bash && \
    echo "export CC=gcc" >> .mysetenv.bash && \
    echo "export CXX=g++" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# sigpyproc" >> .mysetenv.bash && \
    echo "export SIGPYPROC=\$PSRHOME/sigpyproc" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$SIGPYPROC/lib/c" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# szlib" >> .mysetenv.bash && \
    echo "export SZIP=\$PSRHOME/szip-2.1" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$SZIP/install/lib" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$SZIP/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# h5check" >> .mysetenv.bash && \
    echo "export H5CHECK=\$PSRHOME/h5check-2.0.1" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$H5CHECK/install/bin" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# DAL" >> .mysetenv.bash && \
    echo "export DAL=\$PSRHOME/DAL" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$DAL/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$DAL/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$DAL/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# PSRDADA" >> .mysetenv.bash && \
    echo "export PSRDADA=\$PSRHOME/psrdada" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRDADA/install" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PSRDADA/install/lib" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$PSRDADA/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# DSPSR" >> .mysetenv.bash && \
    echo "export DSPSR=\$PSRHOME/dspsr" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$DSPSR/install/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$DSPSR/install/lib" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$DSPSR/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# clig" >> .mysetenv.bash && \
    echo "export CLIG=\$PSRHOME/clig" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$CLIG/instal/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CLIG/instal/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# CLooG" >> .mysetenv.bash && \
    echo "export CLOOG=\$PSRHOME/cloog-0.18.4" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$CLOOG/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$CLOOG/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$CLOOG/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Ctags" >> .mysetenv.bash && \
    echo "export CTAGS=\$PSRHOME/ctags-5.8" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$CTAGS/install/bin" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# GeographicLib" >> .mysetenv.bash && \
    echo "export GEOLIB=\$PSRHOME/GeographicLib-1.46" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$GEOLIB/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$GEOLIB/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$GEOLIB/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# h5edit" >> .mysetenv.bash && \
    echo "export H5EDIT=\$PSRHOME/h5edit-1.3.1" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$H5EDIT/install/bin" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Leptonica" >> .mysetenv.bash && \
    echo "export LEPTONICA=\$PSRHOME/leptonica-1.74.1" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$LEPTONICA/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$LEPTONICA/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$LEPTONICA/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# tvmet" >> .mysetenv.bash && \
    echo "export TVMET=\$PSRHOME/tvmet-1.7.2" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$TVMET/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$TVMET/install/include" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# FFTW2" >> .mysetenv.bash && \
    echo "export FFTW2=\$PSRHOME/fftw-2.1.5" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$FFTW2/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$FFTW2/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# fitsverify" >> .mysetenv.bash && \
    echo "export FITSVERIFY=\$PSRHOME/fitsverify" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$FITSVERIFY" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# PSRSALSA" >> .mysetenv.bash && \
    echo "export PSRSALSA=\$PSRHOME/psrsalsa" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRSALSA/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PSRSALSA/src/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# pypsrfits" >> .mysetenv.bash && \
    echo "export PYPSRFITS=\$PSRHOME/pypsrfits" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# PRESTO" >> .mysetenv.bash && \
    echo "export PRESTO=\$PSRHOME/presto" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PRESTO/bin" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PRESTO/lib" >> .mysetenv.bash && \
    echo "export PYTHONPATH=\$PYTHONPATH:\$PRESTO/lib/python" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# psrfits2psrfits" >> .mysetenv.bash && \
    echo "export PSRFITS2PSRFITS=\$PSRHOME/psrfits2psrfits" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRFITS2PSRFITS" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# psrfits_utils" >> .mysetenv.bash && \
    echo "export PSRFITS_UTILS=\$PSRHOME/psrfits_utils" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$PSRFITS_UTILS/install/bin" >> .mysetenv.bash && \
    echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$PSRFITS_UTILS/install/include" >> .mysetenv.bash && \
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$PSRFITS_UTILS/install/lib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# pyslalib" >> .mysetenv.bash && \
    echo "export PYSLALIB=\$PSRHOME/pyslalib" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# Vpsr" >> .mysetenv.bash && \
    echo "export VPSR=\$PSRHOME/Vpsr" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$VPSR" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# GPy" >> .mysetenv.bash && \
    echo "export GPY=\$PSRHOME/GPy" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$GPY" >> .mysetenv.bash && \
    echo "" >> .mysetenv.bash && \
    echo "# coast_guard" >> .mysetenv.bash && \
    echo "export COAST_GUARD=\$PSRHOME/coast_guard" >> .mysetenv.bash && \
    echo "export PATH=\$PATH:\$COAST_GUARD:\$COAST_GUARD/coast_guard" >> .mysetenv.bash && \
    echo "export COASTGUARD_CFG=\$COAST_GUARD/configurations" >> .mysetenv.bash && \
    echo "export PYTHONPATH=\$PYTHONPATH:\$COAST_GUARD:\$COAST_GUARD/coast_guard" >> .mysetenv.bash && \
    /bin/bash -c "source $HOME/.bashrc"


# Update database for locate and run sshd server and expose port 22
USER root
RUN updatedb
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
