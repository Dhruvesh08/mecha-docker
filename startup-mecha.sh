#!/bin/bash

WDIR=/workdir

# Check if machine is set otherwise exit
if [ -z "$MACHINE" ]
then
    echo "Please set MACHINE variable"
    exit 1
fi

# Check if default build directory is setup
if [ -z "$1" ]
then
    BDDIR=build*
else
    BDDIR="$1"
fi

# Check if branch is passed as argument
if [ -z "$BRANCH" ]
then
    BRANCH=kirkstone
fi

if [ -z "$MANIFEST" ]
then
    MANIFEST=mecha-comet-m-image-core-5.15.xml
fi

# Configure Git if not configured
if [ ! $(git config --global --get user.email) ]; then
    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"
    git config --global color.ui false
fi

# Create a directory for yocto setup
mkdir -p $WDIR/mecha
cd $WDIR/mecha

# Initialize if repo not yet initialized
repo status 2> /dev/null
if [ "$?" = "1" ]
then
    repo init -u https://github.com/mecha-org/mecha-manifests.git -b $BRANCH -m $MANIFEST
    repo sync
fi # Do not sync automatically if repo is setup already

# Initialize build environment
if [ -z "$DISTRO"  ]
then
    MACHINE=$MACHINE source setup-environment
else
    DISTRO=$DISTRO MACHINE=$MACHINE source setup-environment
fi




# Only start build if requested
if [ -z "$IMAGE" ]
then
    echo "Build environment configured"
else
    echo "Build environment configured. Building target image $IMAGE"
    echo "> DISTRO=$DISTRO MACHINE=$MACHINE bitbake $IMAGE"
    bitbake $IMAGE
fi

# Spawn a shell
exec bash -i