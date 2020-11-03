FROM alpine:3.12 AS filebeat
ARG VERSION=7.9.2
ARG ARCH=arm64
WORKDIR /
ADD https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${VERSION}-linux-${ARCH}.tar.gz .
RUN tar xzvf filebeat-${VERSION}-linux-${ARCH}.tar.gz
RUN mv filebeat-${VERSION}-linux-${ARCH} filebeat
RUN chmod 755 /filebeat/filebeat

FROM debian:buster-slim
RUN apt-get update && apt-get install -y curl
COPY --from=filebeat /filebeat /filebeat
ENTRYPOINT ["/filebeat/filebeat","-e","--path.home=/filebeat"]
CMD ["--environment", "container"]
