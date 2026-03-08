# ── AB-Lab Dashboard ─────────────────────────────────────────────────────────
# Multi-platform image: linux/amd64 · linux/arm64 · linux/arm/v7
# Built on nginx:alpine (tiny footprint, ARM-native)
# ─────────────────────────────────────────────────────────────────────────────
FROM nginx:alpine

LABEL maintainer="Andrea Buono"
LABEL org.opencontainers.image.title="AB-Lab Dashboard"
LABEL org.opencontainers.image.description="Homelab start-page dashboard"
LABEL org.opencontainers.image.source="https://github.com/AndreaB-1/AB-Dashboard"

# Remove the default nginx welcome page and copy ours
RUN rm -rf /usr/share/nginx/html/*

COPY index.html /usr/share/nginx/html/index.html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# nginx listens on 80 inside the container;
# map it to any host port you like in docker-compose / Portainer
EXPOSE 80

# Use non-root nginx worker (nginx:alpine already runs master as root
# but workers drop to the `nginx` user defined in nginx.conf)
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]
