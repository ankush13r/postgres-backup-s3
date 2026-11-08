#! /bin/sh

set -eux
set -o pipefail

apk update

# install pg_dump
apk add postgresql-client

# install gpg
apk add gnupg

apk add aws-cli

# install go-cron
apk add curl
curl -fL https://github.com/ivoronin/go-cron/releases/download/v0.0.5/go-cron_0.0.5_linux_${TARGETARCH}.tar.gz -O
# sha256 from the release's go-cron_0.0.5_checksums.txt
case "$TARGETARCH" in
  amd64) sha=564c8291ef18879b300614e179cca3116506191cbc6b8e50448d274b256f2e67 ;;
  *) echo "no pinned go-cron checksum for $TARGETARCH"; exit 1 ;;
esac
echo "$sha  go-cron_0.0.5_linux_${TARGETARCH}.tar.gz" | sha256sum -c -
tar xvf go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
rm go-cron_0.0.5_linux_${TARGETARCH}.tar.gz
mv go-cron /usr/local/bin/go-cron
chmod u+x /usr/local/bin/go-cron
apk del curl


# cleanup
rm -rf /var/cache/apk/*
