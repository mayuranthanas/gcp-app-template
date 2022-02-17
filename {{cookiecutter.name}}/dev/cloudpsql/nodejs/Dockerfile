FROM node:10

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ADD package.json /usr/src/app/package.json
RUN npm install --production
ADD /src/server.js /usr/src/app/server.js

ENTRYPOINT ["node", "server.js"]
