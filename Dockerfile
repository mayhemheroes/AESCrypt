FROM --platform=linux/amd64 ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y automake libtool clang make cmake

ADD . /repo
WORKDIR /repo/Linux
RUN autoreconf -ivf
WORKDIR /repo/Linux/build
RUN cmake ..
RUN make -j8
