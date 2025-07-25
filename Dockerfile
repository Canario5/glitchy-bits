# syntax=docker/dockerfile:1@sha256:9857836c9ee4268391bb5b09f9f157f3c91bb15821bb77969642813b0d00518d

# -----------------------------------------------------------------------------
# I created npm scripts in package.json.
#
# Local Development:
#   "docker-compose up" run as "npm run docker:dev"
#
# Build Production Image:
#   "docker build --target=prod -t glitchy-bits ." run as "npm run docker:build"
#
# Run Production Image Locally (localhost:8080):
#   "docker run -p 8080:80 glitchy-bits" run as "npm run docker:preview"
#
# -----------------------------------------------------------------------------

# Base stage - npm installation
FROM node:24-alpine@sha256:820e86612c21d0636580206d802a726f2595366e1b867e564cbc652024151e8a AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Development stage
FROM base AS dev
WORKDIR /app
COPY . .
EXPOSE 5173
CMD ["npm", "run", "dev"]

# Production stage
FROM base AS build
WORKDIR /app
COPY . .
RUN npm run build

# Final production image
FROM nginx:mainline-alpine-slim@sha256:64daa9307345a975d3952f4252827ed4be7f03ea675ad7bb5821f75ad3d43095 AS prod
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
