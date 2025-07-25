# syntax=docker/dockerfile:1

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
FROM node:24.4-alpine AS base
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
FROM nginx:1.29-alpine-slim AS prod
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
