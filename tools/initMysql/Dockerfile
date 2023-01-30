FROM golang:1.19.0-bullseye
WORKDIR /build
COPY ./ ./
RUN make

FROM busybox:uclibc
WORKDIR /runtime
RUN mkdir -p /config
COPY --from=0 /build/mysqlinit .
CMD /runtime/mysqlinit
