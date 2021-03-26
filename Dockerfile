FROM debian:10 AS build

RUN apt update
RUN apt install -y curl git
RUN if [ "`uname -m`" == "aarch64" ]; then curl -L https://golang.org/dl/go1.16.2.linux-arm64.tar.gz -o go.tar.gz; fi
RUN if [ "`uname -m`" != "aarch64" ]; then curl -L https://golang.org/dl/go1.16.2.linux-amd64.tar.gz -o go.tar.gz; fi

RUN go/bin/go get curl github.com/Azure/azure-storage-azcopy

FROM alpine:latest
COPY --from=build /azure-storage-azcopy/azure-storage-azcopy azcopy

ENTRYPOINT ["./azcopy"]