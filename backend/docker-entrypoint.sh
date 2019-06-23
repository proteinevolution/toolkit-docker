#!/bin/bash

# The only point of that entrypoint file is to merge `ivy2_image/local` (where sbt libraries built in Dockerfile.backend reside)
# into `/root/.ivy2/local`. `.ivy2/local` is where image user could mount his host ivy cache
# IMPORTANT: always use LF line endings for this file

set -e
RED='\033[0;31m'
NC='\033[0m' # No Color

mkdir -p ~/.ivy2/local

if [[ ! -d  /root/.ivy2/local/com.tgf.pizza ]]; then
	mv /root/.ivy_image/local/com.tgf.pizza /root/.ivy2/local
else
	printf "${RED}WARN: ${NC}On your host directory ~/.ivy2/local/com.tgf.pizza exists. Your host versions of libraries will be used instead of ones from image.\n"
fi

sbt $@
