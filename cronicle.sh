#!/bin/bash

podman build -t cronicle ./
podman stop cronicle
podman rm cronicle
podman volume create cronicle
podman run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v cronicle:/opt/cronicle/:rw \
        -v ./keys:/opt/ssh/keys:ro \
        -p 3012:3012 \
        --hostname cronicle \
        --name cronicle \
        cronicle
