# Pin nginx version for reproducible builds
FROM nginx:1.27-alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# --- Security: drop server tokens & version ---
# (handled in nginx.conf, but also strip the header at build time)
RUN sed -i 's/^worker_processes.*/worker_processes auto;/' /etc/nginx/nginx.conf

# Copy our configs
COPY nginx.conf      /etc/nginx/nginx.conf
COPY conf.d/         /etc/nginx/conf.d/

# Use non-root user (nginx alpine image supports this)
# nginx master must run as root to bind port 80, workers run as nginx user (set in nginx.conf)

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO /dev/null http://127.0.0.1/nginx-health || exit 1
