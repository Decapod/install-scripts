# Copyright 2010 University of Toronto
# Copyright 2012 OCAD University
#
# Licensed under the Educational Community License (ECL), Version 2.0 or the New BSD license. 
# You may not use this file except in compliance with one these Licenses.
#
# You may obtain a copy of the ECL 2.0 License and BSD License at
# https://source.fluidproject.org/svn/LICENSE.txt

## Install Decapod Dewarping

# Start of dewarping installation
. ./_shared-utils.sh

DEWARP_MODULES="libtiff-tools imagemagick cmake git python-wxgtk2.8"

OPENCV_VERSION=2.4.1
OPENCV_BRANCH=OpenCV-$OPENCV_VERSION
OPENCV_PKG_NAME=OpenCV

FLANN_VERSION=1.7.1
FLANN_BRANCH=flann-$FLANN_VERSION
FLANN_PKG_NAME=flann

VLFEAT_VERSION=0.9.16

if [ "$1" = "remove" ]; then
    OPERATION=$1
else
    OPERATION="install"
fi

# Get some Dewarping-specific dependencies
install_packages $DEWARP_MODULES

# Install OpenCV
if [ "$1" = "remove" ]; then
    uninstall_dpkg $OPENCV_PKG_NAME
else
    wget http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/$OPENCV_VERSION/$OPENCV_BRANCH.tar.bz2
    tar -xvf $OPENCV_BRANCH.tar.bz2
    rm $OPENCV_BRANCH.tar.bz2
    cd $OPENCV_BRANCH
    mkdir build
    cd build
    cmake -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
    make

    checkinstall -D -y --nodoc --pkgname $OPENCV_PKG_NAME --pkgversion $OPENCV_VERSION make install
    cd ../..
    rm -rf $OPENCV_BRANCH
fi

# Install pyflann
if [ "$1" = "remove" ]; then
    uninstall_dpkg $FLANN_PKG_NAME
    rm -r ../../decapod-dewarping/pyflann
else
    git clone git://github.com/mariusmuja/flann.git flann
    cd flann
    git checkout -b $FLANN_BRANCH c4dce0ee7c705ddd6965ef43a066c3a8b02c47bc
    mkdir build
    cd build
    cmake ..
    make
    checkinstall -D -y --nodoc --pkgname $FLANN_PKG_NAME --pkgversion $FLANN_VERSION make install; cp -r /usr/local/lib/python2.7/dist-packages/pyflann ../../../../decapod-dewarping/.
    cd ../../
    rm -rf flann
fi

# Install vlfeat
if [ "$1" = "remove" ]; then
    rm /usr/local/bin/libvl.so
    rm /usr/local/bin/sift
    ldconfig
else
    git clone https://github.com/vlfeat/vlfeat.git
    cd vlfeat
    git checkout -b v$VLFEAT_VERSION
    make
    find bin -name "libvl.so" -exec cp {} /usr/local/lib/. \;
    find bin -name "sift" -exec cp {} /usr/local/bin/. \;
    ldconfig
    cd ..
    rm -rf vlfeat
fi

