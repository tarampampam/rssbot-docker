<p align="center">
  <img src="https://socialify.git.ci/tarampampam/rssbot-docker/image?forks=1&issues=1&owner=1&stargazers=1&theme=Dark" alt="" width="100%" />
</p>

<p align="center">
  <img src="https://img.shields.io/github/actions/workflow/status/tarampampam/rssbot-docker/tests.yml?branch=master&maxAge=30&label=tests&logo=github&style=flat-square" alt="" />
  <img src="https://img.shields.io/github/actions/workflow/status/tarampampam/rssbot-docker/release.yml?maxAge=30&label=release&logo=github&style=flat-square" alt="" />
  <img src="https://img.shields.io/github/license/tarampampam/rssbot-docker.svg?maxAge=30&style=flat-square" alt="" />
</p>

## What includes this image?

Docker image with [rssbot][rssbot]. Documentation can be found [here][rssbot]. Quick usage help:

```shell
USAGE:
    rssbot [FLAGS] [OPTIONS] <token>

FLAGS:
    -h, --help          Prints help information
        --insecure      DANGER: Insecure mode, accept invalid TLS certificates
        --restricted    Make bot commands only accessible for group admins
    -V, --version       Prints version information

OPTIONS:
        --admin <user id>...        Private mode, only specified user can use this bot. This argument can be passed
                                    multiple times to allow multiple admins
    -d, --database <path>           Path to database [default: ./rssbot.json]
        --max-feed-size <bytes>     Maximum feed size, 0 is unlimited [default: 2097152]
        --max-interval <seconds>    Maximum fetch interval [default: 43200]
        --min-interval <seconds>    Minimum fetch interval [default: 300]

ARGS:
    <token>    Telegram bot token
```

> Note: You can get `<user id>` using bots like @userinfobot @getidsbot

## Docker image

| Registry                          | Image                        |
|-----------------------------------|------------------------------|
| [GitHub Container Registry][ghcr] | `ghcr.io/tarampampam/rssbot` |

All supported image tags (app versions) [can be found here](https://github.com/tarampampam/rssbot-docker/pkgs/container/rssbot/versions).

Following platforms for this image are available:

```shell
$ docker run --rm mplatform/mquery ghcr.io/tarampampam/rssbot:latest
Image: ghcr.io/tarampampam/rssbot:latest
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm64
```

### Usage examples

```shell
$ docker run --rm -v "$(pwd):/rootfs:rw" \
    ghcr.io/tarampampam/rssbot:latest \
      --database /rootfs/rssbot.json \
      <telegram-bot-token>
```

Or you can use a `docker-compose`:

```yaml
version: '3.2'

volumes:
  rssbot-data: {}

services:
  rssbot:
    image: ghcr.io/tarampampam/rssbot:latest
    volumes: [tmp-data:/data:rw]
    command: ['--database', '/data/rssbot.json', '<telegram-bot-token>']
```

## Releasing

New versions publishing is very simple - just "publish" new release using repo releases page. Release version should be same as the rssbot version.

## License

WTFPL. Use anywhere for your pleasure.

[rssbot]:https://github.com/iovxw/rssbot
[ghcr]:https://github.com/tarampampam/rssbot-docker/pkgs/container/rssbot
