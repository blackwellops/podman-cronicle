FROM node:18-bullseye AS builder
ENV CRONICLE_VERSION=0.9.46
WORKDIR /opt/cronicle
RUN curl -L -o /tmp/Cronicle-${CRONICLE_VERSION}.tar.gz https://github.com/jhuckaby/Cronicle/archive/refs/tags/v0.9.46.tar.gz
# COPY Cronicle-${CRONICLE_VERSION}.tar.gz /tmp/
RUN tar zxvf /tmp/Cronicle-${CRONICLE_VERSION}.tar.gz -C /tmp/ && \
    mv /tmp/Cronicle-${CRONICLE_VERSION}/* . && \
    rm -rf /tmp/* && \
    yarn
COPY docker-entrypoint.js ./bin/


FROM node:current-bookworm
RUN apt install -y procps curl
RUN apt install -y openssh-client
COPY --from=builder /opt/cronicle/ /opt/cronicle/
WORKDIR /opt/cronicle
ENV CRONICLE_foreground=1
ENV CRONICLE_echo=1
ENV CRONICLE_color=1
ENV debug_level=1
ENV HOSTNAME=main
RUN node bin/build.js dist && bin/control.sh setup
CMD ["node", "bin/docker-entrypoint.js"]
