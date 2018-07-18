FROM node:10-alpine AS builder

RUN apk add --no-cache --virtual build-dependencies python make git g++

USER node

COPY --chown=node package.json /app/package.json
WORKDIR /app
COPY . /app
RUN npm install

COPY --chown=node . /app


FROM node:10-alpine
WORKDIR /app
COPY --from=builder /app .
CMD ["npm","start"]
