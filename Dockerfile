# syntax=docker/dockerfile:1

FROM docker.io/library/alpine:latest as builder

# renovate: source=github-tags name=iovxw/rssbot
ARG RSS_BOT_VERSION="2.0.0-alpha.13"

# can be `en` or `zh`
ARG LOCALE="en"

# https://github.com/Yelp/dumb-init/releases
ARG DUMB_INIT_VERSION="1.2.5"

RUN set -x \
    && export apkArch="$(apk --print-arch)" \
    && case "$apkArch" in \
        aarch64) \
          DIST_FILE_NAME="rssbot-${LOCALE}-aarch64-unknown-linux-musl-openssl"; \
          DUMB_FILE_NAME="dumb-init_${DUMB_INIT_VERSION}_aarch64" \
        ;; \
        x86_64) \
          DIST_FILE_NAME="rssbot-${LOCALE}-x86_64-unknown-linux-musl-openssl"; \
          DUMB_FILE_NAME="dumb-init_${DUMB_INIT_VERSION}_x86_64" \
        ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac \
    && wget -O /tmp/rssbot "https://github.com/iovxw/rssbot/releases/download/v${RSS_BOT_VERSION}/${DIST_FILE_NAME}" \
    && chmod +x /tmp/rssbot \
    && /tmp/rssbot --version \
    && wget -O /tmp/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/${DUMB_FILE_NAME}" \
    && chmod +x /tmp/dumb-init \
    && /tmp/dumb-init --version

WORKDIR /tmp/rootfs

# prepare the rootfs for scratch
RUN set -x \
    && mkdir -p ./bin ./etc/ssl ./tmp ./data \
    && mv /tmp/rssbot ./bin/rssbot \
    && mv /tmp/dumb-init ./bin/dumb-init \
    && echo 'rssbot:x:10001:10001::/tmp:/sbin/nologin' > ./etc/passwd \
    && echo 'rssbot:x:10001:' > ./etc/group \
    && chown -R 10001:10001 ./tmp ./data \
    && chmod 0777 ./tmp \
    && cp -R /etc/ssl/certs ./etc/ssl/certs

# use empty filesystem
FROM scratch as runtime

LABEL \
    # Docs: <https://github.com/opencontainers/image-spec/blob/master/annotations.md>
    org.opencontainers.image.title="rssbot" \
    org.opencontainers.image.description="Lightweight Telegram RSS notification bot" \
    org.opencontainers.image.url="https://github.com/tarampampam/rssbot-docker" \
    org.opencontainers.image.source="https://github.com/iovxw/rssbot" \
    org.opencontainers.image.vendor="tarampampam"

# use an unprivileged user
USER 10001:10001

# import from builder
COPY --from=builder /tmp/rootfs /

WORKDIR /data

ENTRYPOINT ["/bin/dumb-init", "--", "/bin/rssbot"]
