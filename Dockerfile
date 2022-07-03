FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get install -y automake libtool clang make cmake

ADD . /repo
WORKDIR /repo/Linux
RUN autoreconf -ivf
RUN mkdir ./dist
RUN ./configure --prefix=$PWD/dist
RUN make install 

FROM ubuntu:20.04 as package

RUN mkdir /aescrypt
COPY --from=builder /repo/Linux/dist /aescrypt
