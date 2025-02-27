# Docker Internal images

This repository provides additional Docker images for a quick deployment of PrestaShop.

⚠️ They are not designed for running an e-commerce activity in production.

## Description

These Docker files are based on the images [prestashop/prestashop](https://hub.docker.com/r/prestashop/prestashop/).
With the Apache + PHP server already present, a MySQL server is installed and configured for a small environment (only one user per running website) to avoid too much memory consumption.

Each tag of this images has the following content:
* PrestaShop is pre-installed during the build
* All existing languages are being added at the same time.
* One employee per language is created (`demo<iso_code>@prestashop.com`)
* URL rewriting is enabled

For each PrestaShop major version, we chose the best compromise between reliability and speed of PHP.

## Installation

Images are being stored by default on Docker hub. They can be downloaded with:

```bash
docker pull prestashop/docker-internal-images[:tag]
```

Possible values for the tag are: `8`, `1.7`, `1.6`, `1.5`, `nightly`. Not providing this parameter will fallback on the highest stable PrestaShop version.

## Running this image

To run this images flawlessly on your environment, we advice you to find an available port on the host, then bind it
to the container and the domain parameter.

This example runs a pre-installed PrestaShop 8 on the port 8003 of the local machine:

```bash
docker run -ti -p 8003:80 \
  -e PS_DOMAIN=localhost:8003 \
  -e PS_TRUSTED_PROXIES=127.0.0.1,REMOTE_ADDR \
  -e PS_ENABLE_SSL=0 \
  prestashop/docker-internal-images:8

```


## Contributing

Changes can be suggested on https://github.com/PrestaShop/docker-internal-images.

During the development, you may try to build new local images by running the following commands:

```bash
docker build -t prestashop/docker-internal-images:8 8
docker build -t prestashop/docker-internal-images:1.7 1.7
docker build -t prestashop/docker-internal-images:1.6 1.6
docker build -t prestashop/docker-internal-images:1.5 1.5
docker build -t prestashop/docker-internal-images:nightly nightly
```

Then follow the step "Running this image" to create a container from these new tags.

Make sure each subfolder got the same improvement or only one tag will be updated.
