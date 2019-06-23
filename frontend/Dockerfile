FROM node:10.16

LABEL maintainer="fgabler@tue.mpg.de"

RUN yarn global add yarn@1.16.0
RUN yarn global add @vue/cli npm-check-updates

ENV CHOKIDAR_USEPOLLING=true

VOLUME /toolkit/frontend
WORKDIR /toolkit/frontend

# expose frontend port
ENV PORT=8080
EXPOSE 8080

CMD ["bash"]
