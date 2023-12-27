FROM node:16.14.2

WORKDIR /app

RUN  chown node:node /app

USER node

COPY --chown=node:node package*.json ./

RUN npm install && npm cache clean --force

COPY --chown=node:node . .

EXPOSE 3000

CMD [ "npm", "run", "start" ]
