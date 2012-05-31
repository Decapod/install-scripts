# Copyright 2010 University of Toronto
# Copyright 2012 OCAD University
#
# Licensed under the Educational Community License (ECL), Version 2.0 or the New BSD license. 
# You may not use this file except in compliance with one these Licenses.
#
# You may obtain a copy of the ECL 2.0 License and BSD License at
# https://source.fluidproject.org/svn/LICENSE.txt

. ./_shared-utils.sh

# Third-party packages to get via apt
SCM='mercurial'
BUILDS="scons"
SYSTEM="checkinstall"
C_LIBS="libjpeg62-dev fontforge fontforge-extras autotrace potrace"
PYTHON_LIBS="python-numpy python-imaging python-scipy python-scipy-dbg python-matplotlib python-reportlab python-simplejson python-fontforge python-nose"

if [ "$1" = "remove" ]; then
	OPERATION=$1
else
	OPERATION="install"
fi


# Install all third-party packages via apt-get
install_packages $SCM $BUILDS $SYSTEM $C_LIBS $PYTHON_LIBS
