FROM node:20 as builder

WORKDIR /usr/src/app

COPY package.json yarn.lock ./

RUN yarn install

COPY . .

# Build stage completed, moving to runtime image
FROM node:20-slim

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app .

EXPOSE 80

CMD ["node", "index.js"]
