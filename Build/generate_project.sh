#!/bin/bash
#
# Setup script to build landxml on OS X and Ubuntu Linux:
#    - Generates make projects, or
#    - Generate Xcode project
#
# Usage:
# Generate_Projects [build type]
#     [build type]: could be one of Debug, Release, or RelWithDebInfo. If empty, default to Debug.
#

function checkExit {
  if [[ $1 != 0 ]]; then
      echo $2
    exit $1
  fi
}

function checkDependency {
  echo "Check Dependency: $1"
  which $1 > /dev/null
  checkExit $? "ERROR: '$1' not found. Please install it!"
}

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


# Paths and Defines
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
if [ "$#" == "0" ]; then
  # No build directory was given, generate build files in '/Build'
  OUTPUT_DIR="$BASE_DIR/Build/$PLATFORM"
else
  # Use build directory passed as first parameter
  OUTPUT_DIR=$1
  mkdir -p $OUTPUT_DIR
fi


pushd "$BASE_DIR"
  ./Build/puppet/install-dependencies.sh

  cmake -H. -B$OUTPUT_DIR/Debug -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=true
  checkExit $? "Makefile generation for 'Debug' build failed."

  cmake -H. -B$OUTPUT_DIR/RelWithDebInfo -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_SHARED_LIBS=true
  checkExit $? "Makefile generation for 'RelWithDebInfo' build failed."

  if [[ "$PLATFORM" == "MacOSX" ]]; then
    cmake -H. -B$OUTPUT_DIR/Xcode -GXcode
    checkExit $? "Xcode project generation failed."
  fi
popd


echo "----------------------------------------------------------------------------------------------"
echo ""
echo "Go to \"$OUTPUT_DIR<<CONFIG>>\"."
echo "Execute \"$BASE_DIR/GitSubModules/UpdateGitSubModules.sh\" to update all GIT submodules."
echo "Execute \"make -k -j $CORES\" to build."
echo "Execute \"make test\" to run all unit tests."
echo "Execute \"ctest -R <<TEST_NAME>> -VV\" to run a specific unit test."
echo ""
echo "Have fun!"
echo ""
