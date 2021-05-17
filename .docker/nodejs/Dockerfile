
# syntax=docker/dockerfile:1

# Multi-stage Node image for frontend assets
# - building: docker build --target builder -t c0met-node:latest
# - linting: docker build --target linting -t c0met-node:latest
# - serve: docker build --target serve -t c0met-node:latest
#
# built for running/deployment
# docker build -t c0met-node:latest

# Copies in our code and runs NPM Install
# docker build --target builder -t example-node:latest
FROM node:lts-alpine AS base
# smoke tests
RUN echo "NodeJS Version:" "$(node -v)" && \
    echo "NPM Version:" "$(npm -v)"
WORKDIR /var/www/frontend
COPY ./src/frontend .

# Lints Code
FROM base AS linting
ENV NODE_ENV=development
RUN npm install
ENTRYPOINT ["npm"]
CMD ["run", "lint"]

# Runs Unit Tests
# docker build --target unit-tests -t example-node:latest
# TODO: Define tests
# FROM node:lts-alpine as unit-tests
# WORKDIR /C0MET.frontend
# COPY --from=builder /C0MET.frontend .
# RUN npm test

FROM base as development
#EXPOSE "7090:7090"
ENV NODE_ENV=development
RUN npm config set unsafe-perm true &&      \
    npm install -g nodemon &&               \
    npm install eslint --save-dev
# HEALTHCHECK --interval=5s \
#             --timeout=5s \
#             --retries=6 \
#             CMD curl --fail http://localhost:7090/ || exit 1
ENTRYPOINT ["node"]
CMD ["server.js"]

# Build the frontend
FROM base AS builder
ENV NODE_ENV=production
# npm ci works similarly to npm i, but skips the expensive dependency resolution step
RUN npm ci
# run our quality checks and build
# fail as quickly as possible
# RUN npm run format
RUN npm run lint
RUN npm run test
RUN npm run build
# get rid of any development dependencies
RUN npm prune --production
ENTRYPOINT ["node"]
CMD ["server.js"]
# FROM builder as production
