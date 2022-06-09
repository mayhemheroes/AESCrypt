FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y automake libtool clang make cmake

ADD . /repo
WORKDIR /repo/Linux
RUN autoreconf -ivf
WORKDIR /repo/Linux/build
RUN cmake ..
RUN make -j8

RUN mkdir -p /deps
RUN ldd /repo/Linux/build/src/aescrypt | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /repo/Linux/build/src/aescrypt /repo/Linux/build/src/aescrypt
ENV LD_LIBRARY_PATH=/deps
