# Docker image STM32CubeIDE

Docker with STM32CubeIDE software.

https://www.st.com/en/development-tools/stm32cubeide.html

## Docker command

### Docker build image

`docker build --rm -t stm32cubeide <DOCKERFILE_FOLDER>`

### Docker run container

`docker run --rm -v $PWD:/home/firmware -w /home/firmware -it stm32cubeide:latest`

with `$PWD` path of the project to build.

### Gitlab container registry

```shell
docker login <registry URL>
docker build -t <registry URL>/<namespace>/<project>/stm32cubeide <DOCKERFILE_FOLDER>
docker push <registry URL>/<namespace>/<project>/stm32cubeide
```

## Dockerfile description

Install *Eclipse IDE*, then install *STM32CubeIDE*, *C/C++ Arm Cross Compiler* and *C/C++ Core* by using Eclipse update provisioning platform [p2](https://rtist.hcldoc.com/help/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_api_overview.htm&cp%3D1_0_20_0).

## Links

- [Help - Eclipse IDE](https://rtist.hcldoc.com/help/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_api_overview.htm&cp%3D1_0_20_0): https://rtist.hcldoc.com/help/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Fguide%2Fp2_api_overview.htm&cp%3D1_0_20_0
