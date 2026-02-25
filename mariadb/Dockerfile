# Pin MariaDB LTS version for reproducible builds
FROM mariadb:11.4

# Install cron for log rotation
RUN apt-get update && apt-get install -y --no-install-recommends cron \
    && rm -rf /var/lib/apt/lists/*

# Copy WordPress-tuned config
COPY conf.d/ /etc/mysql/conf.d/

# Copy logrotate config
COPY logrotate.d/mariadb-slow /etc/logrotate.d/mariadb-slow

# Add daily cron job for logrotate
RUN echo "0 3 * * * root logrotate /etc/logrotate.d/mariadb-slow" \
    > /etc/cron.d/mariadb-slow-logrotate \
    && chmod 0644 /etc/cron.d/mariadb-slow-logrotate

# Wrapper entrypoint: starts cron then hands off to MariaDB
COPY entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

EXPOSE 3306

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=5 \
    CMD healthcheck.sh --connect --innodb_initialized || exit 1

ENTRYPOINT ["custom-entrypoint.sh"]
CMD ["mariadbd"]
