#!/bin/bash
# 
# Since: May, 2017
# Author: andy.little@oracle.com

# Description: script to build a Docker image for Documaker
# 
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
# 
# Copyright (c) 2017 Oracle and/or its affiliates. All rights reserved.
# 

usage() {
cat << EOF

Usage: buildDockerImage.sh -v [version] [-e | -s] [-c]
Builds a Docker Image for Oracle Documaker.
  
Parameters:
   -v: version to build. Required.
       Choose one of: $(for i in $(ls -d */ | grep -v util); do echo -n "${i%%/}  "; done)
   -e: creates image based on 'Enterprise Edition'
   -s: creates image based on 'Standard Edition'
   -c: enables Docker image layer cache during build
   -x: skips the MD5 check of packages

LICENSE CDDL 1.0 + GPL 2.0

Copyright (c) 2017 Oracle and/or its affiliates. All rights reserved.

EOF
exit 0
}

# Validate packages
checksumPackages() {
  echo "Checking if required packages are present and valid..."
  md5sum -c Checksum.$EDITION
  if [ "$?" -ne 0 ]; then
    echo "MD5 for required packages to build this image did not match!"
    echo "Make sure to download missing files in folder $VERSION. See *.download files for more information"
    exit $?
  fi
}

if [ "$#" -eq 0 ]; then usage; fi

# Parameters
EE=0
SE=0
VERSION="12.5.0"
SKIPMD5=0
NOCACHE=true
while getopts "hexcsv:" optname; do
  case "$optname" in
    "h") usage ;;
    "e") EE=1 ;;
    "s") SE=1 ;;
    "x") SKIPMD5=1 ;;
    "v") VERSION="$OPTARG";;
    "c") NOCACHE=false;;
    *) echo "Unknown error while processing options inside buildDockerImage.sh" ;;
  esac
done

# Which Edition should be used?
if [ $((EE + SE)) -gt 1 ]; then
  usage
elif [ $EE -eq 1 ]; then
  EDITION="ee"
elif [ $SE -eq 1 ]; then
  EDITION="se"
else
  usage
fi


# Image Name
IMAGE_NAME="oracle/documaker:$VERSION-$EDITION"

# Go into version folder
cd $VERSION

if [ ! "$SKIPMD5" -eq 1 ]; then
  checksumPackages
else
  echo "Skipped MD5 checksum."
fi

echo "====================="

# Proxy settings
PROXY_SETTINGS=""
if [ "${http_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg http_proxy=${http_proxy}"
fi

if [ "${https_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg https_proxy=${https_proxy}"
fi

if [ "${ftp_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg ftp_proxy=${ftp_proxy}"
fi

if [ "${no_proxy}" != "" ]; then
  PROXY_SETTINGS="$PROXY_SETTINGS --build-arg no_proxy=${no_proxy}"
fi

if [ "$PROXY_SETTINGS" != "" ]; then
  echo "Proxy settings were found and will be used during build."
fi

echo "Building image '$IMAGE_NAME' ..."

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build --force-rm=$NOCACHE --no-cache=$NOCACHE $PROXY_SETTINGS -t $IMAGE_NAME -f Dockerfile.$EDITION . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  Documaker Docker Image for '$EDITION' version $VERSION is ready to be extended: 
    
    --> $IMAGE_NAME

  Build completed in $BUILD_ELAPSED seconds.

EOF
else
  echo "Documaker Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi

