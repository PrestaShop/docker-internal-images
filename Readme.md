# Docker Internal images

This repository provides additional Docker images for a quick deployment of PrestaShop.

:warning: They are not designed for a production use.

## Description

These Docker files are based on the images [prestashop/prestashop](https://hub.docker.com/r/prestashop/prestashop/).
With the Apache + PHP server already present, a MySQL server is installed and configured for a small environment (only one user per running website) to avoid too much memory consumption.
PrestaShop is pre-installed during the build, and all existing languages are being added at the same time.

For each PrestaShop major version, we chose the best compromise between reliability and speed of PHP.
* PrestaShop 1.5 with PHP 5.6
* PrestaShop 1.6 with PHP 7.1
* PrestaShop 1.7 with PHP 7.2

## Installation

Images are being stored by default on Docker hub. They can be downloaded with:

```bash
docker pull prestashop/docker-internal-images[:tag]
```

Possible values for the tag are: `1.5`, `1.6`, `1.7`. Not providing this parameter will fallback on PrestaShop 1.7.

## Runnig this image

To run this images flawlessly on your environment, we advice you to find an available port on the host, then bind it
to the container and the domain parameter.

This example runs a pre-installed PrestaShop 1.7 on the port 8003 of the local machine:

```bash
docker run -ti -p 8003:80 -e PS_DOMAIN=localhost:8003 prestashop/docker-internal-images:1.7
```
