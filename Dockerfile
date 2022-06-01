FROM alpine

ENV NANOMDM_VERSION="0.2.0"

VOLUME "/db"

RUN apk --no-cache add curl
RUN apk --update add ca-certificates
RUN curl -L https://github.com/micromdm/nanomdm/releases/download/v${NANOMDM_VERSION}/nanomdm-linux-amd64-v${NANOMDM_VERSION}.zip -o /nanomdm.zip
RUN unzip /nanomdm.zip
RUN rm /nanomdm.zip
RUN mv /nanomdm-linux-amd64 /usr/local/bin/nanomdm
RUN chmod a+x /usr/local/bin/nanomdm
RUN apk del curl

EXPOSE 80 443 8080

ENTRYPOINT ["/usr/local/bin/nanomdm"]
