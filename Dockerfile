
FROM golang:alpine as builder

RUN apk add --no-cache make git
RUN git clone https://github.com/micromdm/nanomdm.git /go/src/github.com/micromdm/nanomdm

WORKDIR /go/src/github.com/micromdm/nanomdm

ENV CGO_ENABLED=0 \
	GOARCH=amd64 \
	GOOS=linux

RUN make deps
RUN make

FROM alpine

VOLUME "/db"

RUN apk --update add ca-certificates
COPY --from=builder /go/src/github.com/micromdm/nanomdm/build/linux/nanomdm-linux-amd64 /usr/local/bin/nanomdm
COPY --from=builder /go/src/github.com/micromdm/nanomdmm/build/linux/nano2nano-linux-amd64 /usr/local/bin/nano2nano
RUN chmod a+x /usr/local/bin/nanomdm
RUN chmod a+x /usr/local/bin/nano2nano

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/nanomdm"]