# Data Plane Query API

## Description

Kong's Data Plane caches the configuration that it gets back from the Control Plane. This information needs to be used by the Metrics Proxy to enrich the metrics with the Namespace.

This API is a small side-car that reads the cached configuration and returns different data from it.

## Getting Started

### Dependencies

- Docker
- Kubernetes

### Installation

#### Poetry

```bash
brew update
brew install pyenv
pyenv install 3.7
pyenv global 3.7
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
```

#### Requirements

```bash
cd /api-serv-infra/dockerfiles/dp-query-api
poetry env use 3.7
poetry install
```

### Running

```
docker build --tag dp-query-api.local -f dockerfiles/Dockerfile.dp-query-api .
docker run -ti --rm -p 8087:80 \
  -e MAX_WORKERS=1 \
  -e CACHE_FILE=/kong_prefix/config.cache.json.gz \
  -v `pwd`/config.cache.json.gz:/kong_prefix/config.cache.json.gz dp-query-api.local

curl -v http://localhost:8087/services
```

### Example

Example to retrieve a copy of the config cache:

```
kubectl cp -n 264e6f-dev \
  konghd-silver-kong-8bbdff7dd-vffdr:/kong_prefix/config.cache.json.gz \
  config.cache.json.gz \
  -c proxy
```
