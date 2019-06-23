# Toolkit Frontend Docker Image
Dockerfile for the toolkit's frontend docker image. It should be built automatically by DockerCloud.

To build it manually, run:\
``docker image build -t "proteinevolution/toolkit-docker-frontend:1.2.0" -t "proteinevolution/toolkit-docker-frontend:latest" .``

To push the image, run:\
``docker push proteinevolution/toolkit-docker-frontend:latest``

## Various commands
To access the shell, run:\
(Unix) ``docker run --name tk-frontend -p 8080:8080/tcp -v "$PWD/frontend:/toolkit/frontend" --rm -it proteinevolution/toolkit-docker-frontend bash``\
(Windows) ``docker run --name tk-frontend -p 8080:8080/tcp -v "%cd%/frontend:/toolkit/frontend" --rm -it proteinevolution/toolkit-docker-frontend bash``
