FROM ubuntu:20.04

# ADD https://packages.ubuntu.com/dists/focal/main/binary-amd64/Packages .


# Change default shell to bash
SHELL ["/bin/bash", "-c"]

# Preconfigure the time zone selection (replace "America/New_York" with your desired time zone)
RUN echo "Asia/Kolkata" > /etc/timezone && \
    apt update && \
    apt install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata



# Install Python 3
RUN apt update && apt install -y python

# Check if the symbolic link 'python' already exists, and use it if it does
RUN if [ ! -e /usr/bin/python ]; then ln -s /usr/bin/python3 /usr/bin/python; fi


# Update and install dependencies
RUN apt-get update && apt-get install -y \
    gawk wget git  diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales

# Download and install the 'repo' tool using 'wget'
RUN wget https://storage.googleapis.com/git-repo-downloads/repo -O /usr/bin/repo && \
    chmod a+x /usr/bin/repo

RUN useradd -U -m mechauser && \
    /usr/sbin/locale-gen en_US.UTF-8 && \
    echo "mechauser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER mechauser
WORKDIR /home/mechauser

RUN repo init -u https://github.com/mecha-org/mecha-manifests.git -b kirkstone -m mecha-comet-m-image-core-5.15.xml && repo sync

# Setup the bitbake local.conf
RUN EULA=1 DISTRO=mecha-wayland MACHINE=mecha-mage-gen1 source edge-setup-release.sh -b build


# USER usersetup
CMD ["/bin/bash"]
