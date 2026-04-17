# Multi-stage Dockerfile for building a React app and serving with nginx

# Stage 1: build the app
FROM node:20-alpine AS build
WORKDIR /app

# Install dependencies (copy lockfile if present for reproducible builds)
COPY package*.json ./
RUN npm install

# Copy source and build
COPY . .
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html

# Remove default nginx content
RUN rm -rf ./*

# Copy built assets from previous stage
COPY --from=build /app/build .

# Expose default HTTP port
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
