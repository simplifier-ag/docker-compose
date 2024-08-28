FROM golang:1.23.0-bookworm AS build
RUN go install github.com/cbroglie/mustache/cmd/mustache@latest
FROM debian:bookworm-slim
RUN mkdir -p /work/dest /work/templates
WORKDIR /work
RUN apt update && apt install jq yq -y
COPY --from=build /go/bin/mustache /usr/local/bin
COPY run.sh /work
CMD ["/bin/bash"]
