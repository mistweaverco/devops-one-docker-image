<div align="center">

![Logo](assets/logo.svg)

# DevOps One

[![Made with love](assets/badge-made-with-love.svg)](https://github.com/mistweaverco/devops-one-docker-image/graphs/contributors)
[![Discord](assets/badge-discord.svg)](https://mistweaverco.com/discord)

[Pull](#pull) • [Build](#build) • [Features](#features)

<p></p>

The one and only docker image, you'll ever need for your DevOps tasks.

<p></p>

</div>

## Pull: GCP Flavour

```bash
docker pull pull.docker.build/devops-one-gcp:latest
```

## Pull: AWS Flavour

```bash
docker pull pull.docker.build/devops-one-aws:latest
```

## Pull: AWS + GCP Flavour

```bash
docker pull pull.docker.build/devops-one-full:latest
```


## Build: GCP Flavour

```dockerfile
FROM pull.docker.build/devops-one-gcp:latest

# YOUR CODE GOES HERE
```

## Build: AWS Flavour

```dockerfile
FROM pull.docker.build/devops-one-aws:latest

# YOUR CODE GOES HERE
```

## Build: AWS + GCP Flavour

```dockerfile
FROM pull.docker.build/devops-one-full:latest

# YOUR CODE GOES HERE
```

## Features

Comes with the following tools pre-installed:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [BaSH](https://www.gnu.org/software/bash/)
- [Curl](https://curl.se/)
- [Git](https://git-scm.com/)
- [Node.js](https://nodejs.org/)
- [NPM](https://www.npmjs.com/)
- [Make](https://www.gnu.org/software/make/)
- [Yarn](https://yarnpkg.com/)
- [Bun](https://bun.sh)
- [Python](https://www.python.org/)
- [Pip](https://pypi.org/project/pip/)
- [Neovim](https://neovim.io/)
- [jq](https://stedolan.github.io/jq/)
- zip and unzip
- [nvm](https://github.com/nvm-sh/nvm)
- [pyenv](https://github.com/pyenv/pyenv)
- [direnv](https://direnv.net/)
- [kimbia](https://kimbia.mwco.app)
- [aws-cli](https://aws.amazon.com/cli/) (AWS Flavour or Full)
- [gcloud](https://cloud.google.com/sdk/gcloud) (GCP Flavour or Full)
- [tfswtich](https://tfswitch.warrensbox.com/)
- [terraform](https://www.terraform.io/)
