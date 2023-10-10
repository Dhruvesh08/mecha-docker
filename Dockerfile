FROM ubuntu:20.04

# ADD https://packages.ubuntu.com/dists/focal/main/binary-amd64/Packages .

# Preconfigure the time zone selection (replace "America/New_York" with your desired time zone)
RUN echo "Asia/Kolkata" > /etc/timezone && \
    apt update && \
    apt install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Install Python 3
RUN apt update && apt install -y python

# Create a symbolic link from python to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    gawk wget git  diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales

# add repo tool
# Download and install the 'repo' tool
RUN mkdir -p /usr/local/bin && \
    wget https://storage.googleapis.com/git-repo-downloads/repo -O /usr/local/bin/repo && \
    chmod +x /usr/local/bin/repo

RUN git clone https://github.com/mecha-org/mecha-manifests.git && cd mecha-manifests && git checkout kirkstone && repo sync

RUN mkdir -p yocto-build && cd yocto-build && source edge-setup-release.sh -b build

WORKDIR /yocto-build

CMD ["bitbake", "mecha-image-core"]