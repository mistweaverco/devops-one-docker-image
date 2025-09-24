# kulala-cli docker image

This repository contains a Dockerfile for
building a Docker image of the `kulala-cli` tool.

The `kulala-cli` is a command-line interface for running .http files,
which are used for testing HTTP, GraphQL, GRPC and Websocket APIs.

## Usage

You can run the `kulala-cli` Docker image using the following command:

```sh
docker run --rm -v ./directory-containing-http-files:/app/http ghcr.io/mistweaverco/kulala-cli -v report http/your-file.http
```

## Building and Pushing the Docker Image

```sh
docker buildx build -t ghcr.io/mistweaverco/kulala-cli .
docker push ghcr.io/mistweaverco/kulala-cli
```
