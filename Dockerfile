FROM alpine

ENV NANOMDM_VERSION="0.3.0"

RUN apk --no-cache add curl
RUN apk --update add ca-certificates
RUN curl -L https://github.com/micromdm/nanomdm/releases/download/v${NANOMDM_VERSION}/nanomdm-linux-amd64-v${NANOMDM_VERSION}.zip -o /nanomdm.zip
RUN unzip /nanomdm.zip
RUN rm /nanomdm.zip
RUN mv /nanomdm-linux-amd64-v${NANOMDM_VERSION}/nanomdm-linux-amd64 /usr/local/bin/nanomdm
RUN mv /nanomdm-linux-amd64-v${NANOMDM_VERSION}/nano2nano-linux-amd64 /usr/local/bin/nano2nano
RUN chmod a+x /usr/local/bin/nanomdm
RUN chmod a+x /usr/local/bin/nano2nano
RUN rm -rf /nanomdm-linux-amd64-v${NANOMDM_VERSION}
RUN apk del curl

VOLUME "/db"

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/nanomdm"]
