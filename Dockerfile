FROM ubuntu:20.04

ADD https://packages.ubuntu.com/dists/focal/main/binary-amd64/Packages .

RUN apt update && apt install -y gawk wget git repo diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales
RUN git clone https://github.com/mecha-org/mecha-manifests.git && cd mecha-manifests && git checkout kirkstone && repo sync

RUN mkdir -p yocto-build && cd yocto-build && source edge-setup-release.sh -b build

WORKDIR /yocto-build

CMD ["bitbake", "mecha-image-core"]