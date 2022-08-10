# syntax=docker/dockerfile:1.2

FROM alpine:latest as builder

# renovate: source=github-tags name=iovxw/rssbot
ARG RSS_BOT_VERSION="2.0.0-alpha.11"

# can be `en` or `zh`
ARG LOCALE="en"

RUN set -x \
    && export apkArch="$(apk --print-arch)" \
    && case "$apkArch" in \
        aarch64) DIST_FILE_NAME="rssbot-${LOCALE}-aarch64-unknown-linux-musl-openssl" ;; \
        x86_64) DIST_FILE_NAME="rssbot-${LOCALE}-x86_64-unknown-linux-musl-openssl" ;; \
        *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
    esac \
    && wget -O /tmp/rssbot "https://github.com/iovxw/rssbot/releases/download/v${RSS_BOT_VERSION}/${DIST_FILE_NAME}" \
    && chmod +x /tmp/rssbot \
    && /tmp/rssbot --version

WORKDIR /tmp/rootfs

# prepare the rootfs for scratch
RUN set -x \
    && mkdir -p ./bin ./etc/ssl \
    && mv /tmp/rssbot ./bin/rssbot \
    && echo 'rssbot:x:10001:10001::/tmp:/sbin/nologin' > ./etc/passwd \
    && echo 'rssbot:x:10001:' > ./etc/group \
    && cp -R /etc/ssl/certs ./etc/ssl/certs

# use empty filesystem
FROM scratch as runtime

LABEL \
    # Docs: <https://github.com/opencontainers/image-spec/blob/master/annotations.md>
    org.opencontainers.image.title="rssbot" \
    org.opencontainers.image.description="Lightweight Telegram RSS notification bot" \
    org.opencontainers.image.url="https://github.com/iddqd-uk/telegram-rss-bot" \
    org.opencontainers.image.source="https://github.com/iovxw/rssbot" \
    org.opencontainers.image.vendor="iddqd-uk"

# use an unprivileged user
USER 10001:10001

# import from builder
COPY --from=builder /tmp/rootfs /

ENTRYPOINT ["/bin/rssbot"]
