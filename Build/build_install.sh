#!/bin/bash
#
# Setup script to build landxml on Ubuntu Linux:
#
# Usage:
# build_install [build type]
#     [build type]: could be one of Debug, Release, or RelWithDebInfo. If empty, default to Debug.
#

dir=`dirname $0`
ROOT_DIR=`cd $dir;pwd`/..

BUILD_TYPE=$1
if [ -z "$BUILD_TYPE" ] ; then
  BUILD_TYPE="Debug"
fi


# build xerces-c
XERCES_VERSION=3.1.2
XERCES_ROOT=$ROOT_DIR/3rdParty/xerces-c-${XERCES_VERSION}

if [ -f "$XERCES_ROOT/src/.libs/libxerces-c-3.1.so" ] ; then
  echo "xerces-c lib file exists, skip building it."
else
  cd $XERCES_ROOT
  ./configure
  make
fi

# install xerces-c
mkdir -p $ROOT_DIR/installed/lib
cp $XERCES_ROOT/src/.libs/libxerces-c-3.1.so $ROOT_DIR/installed/lib

cd $ROOT_DIR/installed/lib
if [ ! -L "libxerces-c.so" ] ; then
  ln -s ./libxerces-c-3.1.so libxerces-c.so
fi

# add soft link for header reference from landxml
cd $XERCES_ROOT/../
if [ ! -L "xerces-c" ] ; then
  ln -s $XERCES_ROOT xerces-c
fi


# build landxml
$ROOT_DIR/Build/generate_project.sh $BUILD_TYPE

PLATFORM="unknown"
UNAMESTR=`uname`
if [[ "$UNAMESTR" == "Linux" ]]; then
  PLATFORM="Linux"
  CORES=$(nproc)
elif [[ "$UNAMESTR" == "Darwin" ]]; then
  PLATFORM="MacOSX"
  CORES=$(sysctl -n hw.ncpu)
else
  echo "Unknown platform!"
  exit 1
fi

OUTPUT_DIR="$ROOT_DIR/Generated/$PLATFORM/$BUILD_TYPE"
cd $OUTPUT_DIR
make -j $CORES

make install


# create uninstall script file
UNINSTALL_FILE=${ROOT_DIR}/Build/uninstall.sh
touch ${UNINSTALL_FILE}
chmod +x ${UNINSTALL_FILE}
echo "#!/bin/sh"                                       >  ${UNINSTALL_FILE}
echo "#"                                               >> ${UNINSTALL_FILE}
echo ""                                                >> ${UNINSTALL_FILE}
echo "# remove xerces-c lib"                           >> ${UNINSTALL_FILE}
echo "rm ${ROOT_DIR}/installed/lib/libxerces-c.so"     >> ${UNINSTALL_FILE}
echo "rm ${ROOT_DIR}/installed/lib/libxerces-c-3.1.so" >> ${UNINSTALL_FILE}
echo ""                                                >> ${UNINSTALL_FILE}
echo "# remove landxml files"                          >> ${UNINSTALL_FILE}
echo "xargs rm < ${ROOT_DIR}/Generated/${PLATFORM}/${BUILD_TYPE}/install_manifest.txt" >> ${UNINSTALL_FILE}

