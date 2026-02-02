ARG BUILD_FROM
FROM $BUILD_FROM as builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG C.UTF-8

RUN apk update && apk add --no-cache \
	g++ \
	gcc \
	git \
	libpcap-dev

WORKDIR /tmp
RUN git clone -b StMond-patch-1 --single-branch https://github.com/StMond/phev2mqtt.git
COPY --from=golang:alpine /usr/local/go/ /usr/local/go/
RUN cd /tmp/phev2mqtt && \
    /usr/local/go/bin/go build

FROM $BUILD_FROM
RUN apk update && apk add --no-cache \
	libpcap-dev

COPY --from=builder /tmp/phev2mqtt/phev2mqtt /opt/phev2mqtt

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
