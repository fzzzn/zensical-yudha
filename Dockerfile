FROM python:3.14-alpine AS builder

WORKDIR /app

# Install uv and use it to run zensical during build.
RUN pip install --no-cache-dir uv

COPY zensical.toml ./
COPY docs/ ./docs/

RUN uvx zensical build

FROM nginx:alpine

# Remove default nginx static assets.
RUN rm -rf /usr/share/nginx/html/*

# Copy generated static site from builder stage.
COPY --from=builder /app/site/ /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
