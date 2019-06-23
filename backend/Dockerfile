FROM hseeberger/scala-sbt:8u212_2.13.0_1.2.8

LABEL maintainer="fgabler@tue.mpg.de"

ENV TK_BASE_PATH "/root/Toolkit"
ENV MAXMIND_DB "$TK_BASE_PATH/data/GeoLite2-City.mmdb"

RUN mkdir -p $TK_BASE_PATH/bioprogs/tools
RUN mkdir -p $TK_BASE_PATH/databases
RUN mkdir -p $TK_BASE_PATH/data

# install build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc6-dev \
    gcc \
    make \
	&& rm -rf /var/lib/apt/lists/*

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

VOLUME /toolkit/backend
WORKDIR /toolkit/backend

RUN sbt update

# expose backend port
EXPOSE 9000

RUN mv ~/.ivy2 ~/.ivy_image
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["shell"]
