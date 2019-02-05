FROM hseeberger/scala-sbt:8u181_2.12.8_1.2.8

LABEL maintainer="fgabler@tue.mpg.de"

# since scala-sbt is based on stretch-scm instead of stretch, install missing packages. see: https://github.com/docker-library/buildpack-deps/blob/d7da72aaf3bb93fecf5fcb7c6ff154cb0c55d1d1/stretch/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		bzip2 \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libevent-dev \
		libffi-dev \
		libgeoip-dev \
		libglib2.0-dev \
		libjpeg-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libncurses-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		xz-utils \
		zlib1g-dev \
	&& rm -rf /var/lib/apt/lists/*

# install node  and yarn
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qqy && apt-get -qqyy install \
    nodejs \
    yarn \
  && rm -rf /var/lib/apt/lists/*

ENV TK_BASE_PATH "/root/Toolkit"
ENV MAXMIND_DB "$TK_BASE_PATH/data/GeoLite2-City.mmdb"

ENV CHOKIDAR_USEPOLLING=true

RUN mkdir -p $TK_BASE_PATH/bioprogs/tools
RUN mkdir -p $TK_BASE_PATH/databases
RUN mkdir -p $TK_BASE_PATH/data
# install some tools
WORKDIR $TK_BASE_PATH/bioprogs/tools
# CLUSTALO
RUN mkdir -p clustalo/bin && \
    wget http://www.clustal.org/omega/clustalo-1.2.4-Ubuntu-x86_64 -O clustalo/bin/clustalo && \
    chmod u+x clustalo/bin/clustalo
# PSIBLAST
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.8.1/ncbi-blast-2.8.1+-x64-linux.tar.gz -O blastplus.tar.gz && \
    mkdir blastplus && \
    tar xvfz blastplus.tar.gz -C blastplus --strip-components 1 && \
    rm blastplus.tar.gz
# KALIGN
RUN wget http://ftp.debian.org/debian/pool/main/k/kalign/kalign_2.03+20110620.orig.tar.gz -O kalign.tar.gz && \
    mkdir kalign && \
    tar xvfz kalign.tar.gz -C kalign && \
    rm kalign.tar.gz && \
    cd kalign && \
    ./configure && \
    make && \
    # make install && \ # this would make it globally available
    cd ..

# install some databases


WORKDIR /root
# Install custom maxmind geoip
RUN git clone https://github.com/felixgabler/maxmind-geoip2-scala.git && \
    cd maxmind-geoip2-scala && \
    sbt publishLocal

# Install custom scalajs mithril
RUN git clone https://github.com/zy4/scalajs-mithril.git && \
    cd scalajs-mithril && \
    sbt publishLocal

# Download maxmind geoip data
RUN curl -fsL http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz | gunzip -c > $MAXMIND_DB

VOLUME /toolkit
WORKDIR /toolkit

# expose frontend port
EXPOSE 8080
# expose backend port
EXPOSE 1234

CMD sbt "run 1234"
