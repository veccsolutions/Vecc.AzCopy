FROM debian:10 AS build

RUN apt update
RUN apt install -y curl git
RUN if [ "`uname -m`" = "aarch64" ]; then curl -L https://golang.org/dl/go1.16.2.linux-arm64.tar.gz -o go.tar.gz; fi
RUN if [ "`uname -m`" != "aarch64" ]; then curl -L https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -o go.tar.gz; fi
RUN tar -xf go.tar.gz
RUN git clone https://github.com/Azure/azure-storage-azcopy.git

WORKDIR azure-storage-azcopy

RUN git checkout v10.9.0
RUN /go/bin/go build

FROM debian:10-slim
COPY --from=build /azure-storage-azcopy/azure-storage-azcopy azcopy

RUN apt update \
   && apt install -y ca-certificates \
   && apt clean

ENTRYPOINT ["./azcopy"]
