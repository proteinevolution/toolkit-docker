# Toolkit Backend Docker Image
Dockerfile for the toolkit's backend docker image. It should be built automatically by DockerCloud.

To build it manually, run:
``docker image build -t "proteinevolution/toolkit-docker:1.2.0" -t "proteinevolution/toolkit-docker:latest" .``

To push the image, run:
``docker push proteinevolution/toolkit-docker:latest``

## Using image with docker file

The most minimal `docker-compose.yml` file is:

```
version: '3.7'
services:
  sbt:
    image: proteinevolution/toolkit-docker:latest
    volumes:
      - .:/toolkit
```

But it's not optimal if you have anything cached in `~/ivy2` which most probably you do if you develop Scala. To benefit from caching; thus reducing startup time, use the following:

```
version: '3.7'
services:
  sbt:
    image: proteinevolution/toolkit-docker:latest
    volumes:
      - .:/toolkit
      - ~/.ivy2:/root/.ivy2
      - ~/.sbt:/root/.sbt
      - ~/.coursier:/root/.coursier
```

It's still the minimal version; in real project you will probably need to expose ports etc.

## Overriding CMD

By default (i.e. if you don't provide CMD in your `docker run` or `docker-compose.yml`) it will run sbt's `shell`. It's a reasonable default because from there you can invoke any SBT task you want.

If default does not fit your needs then override CMD in either `docker run` or `docker-compose.yml`. Example:

```
docker run -v :.:/toolkit proteinevolution/toolkit-docker:latest projects test:compile
```

Here we also used ability to "chain" sbt commands.
