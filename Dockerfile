# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Increase Node.js memory limit
ENV NODE_OPTIONS="--max-old-space-size=8192"

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the app with increased memory
RUN npm run build

# Serve stage
FROM nginx:alpine

# Copy built assets
COPY --from=build /app/dist /usr/share/nginx/html

# Copy nginx config
COPY ./containers/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 