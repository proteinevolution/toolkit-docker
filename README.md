# Toolkit-Docker
Dockerfiles for the toolkit's docker image. It should be built automatically by DockerCloud.

To build it manually, run:
``docker image build -t "proteinevolution/toolkit-docker:1.1.2" -t "proteinevolution/toolkit-docker:latest" .``

To push the image, run:
``docker push proteinevolution/toolkit-docker:latest``
