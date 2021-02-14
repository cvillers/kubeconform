FROM alpine:latest as certs
RUN apk add ca-certificates

FROM golang:1.14 as build
WORKDIR /go/src/github.com/yannh/kubeconform
COPY . .
RUN make build-static
RUN find

FROM scratch AS kubeconform
MAINTAINER Yann HAMON <yann@mandragor.org>
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build bin/kubeconform /kubeconform
ENTRYPOINT ["/kubeconform"]