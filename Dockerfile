FROM golang:alpine as builder

RUN apk add --no-cache make git
RUN git clone https://github.com/micromdm/nanomdm.git /go/src/github.com/micromdm/nanomdm

WORKDIR /go/src/github.com/micromdm/nanomdm

ENV CGO_ENABLED=0 \
	GOARCH=amd64 \
	GOOS=linux

RUN make

FROM alpine

VOLUME "/db"

RUN apk --update add ca-certificates
COPY --from=builder /go/src/github.com/micromdm/nanomdm/nanomdm-linux-amd64 /usr/local/bin/nanomdm
COPY --from=builder /go/src/github.com/micromdm/nanomdm/nano2nano-linux-amd64 /usr/local/bin/nano2nano
RUN chmod a+x /usr/local/bin/nanomdm
RUN chmod a+x /usr/local/bin/nano2nano

COPY run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9000

CMD ["/run.sh"]
