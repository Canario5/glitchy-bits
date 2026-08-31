# syntax=docker/dockerfile:1@sha256:ecfaec9ed6d810b56388c508f4121597bfbba70d41a6dfeee4d8cad5f295fc32

# Base stage - pnpm installation
FROM node:24-alpine@sha256:e67514e5d0f6c46656005e1b693b2ec9d52e80b641307de684d4a015ba7a4eaf AS base
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./

RUN corepack enable && pnpm --version
RUN --mount=type=cache,id=pnpm,target=/root/.local/share/pnpm/store pnpm install --frozen-lockfile

# Production build stage
FROM base AS build
WORKDIR /app
COPY . .
RUN pnpm run build

# Final production image (copies only built dist folder)
FROM nginxinc/nginx-unprivileged:alpine-slim@sha256:d668aa123a6ec3216ba5ae6b398ae8001d5e81d3142d3659e20354fd0c3c3125 AS prod
USER 101
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
