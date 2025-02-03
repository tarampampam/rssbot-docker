# Telegram RSS Bot

Important note: Since the chart is released together with the app under the same version (i.e., the chart version
matches the app version), its versioning is not compatible with semantic versioning (SemVer). I will do my best to
avoid non-backward-compatible changes in the chart, but due to Murphy's Law, I cannot guarantee that they will
never occur.

## Usage

```shell
helm repo add rssbot https://tarampampam.github.io/rssbot-docker/helm-charts
helm repo update

helm install my-rssbot rssbot/rssbot --version <version_here>
```

Alternatively, add the following lines to your `Chart.yaml`:

```yaml
dependencies:
  - name: rssbot
    version: <version_here>
    repository: https://tarampampam.github.io/rssbot-docker/helm-charts
```

And override the default values in your `values.yaml`:

```yaml
rssbot:
  botToken:
    plain: "<telegram-bot-token>"
```
