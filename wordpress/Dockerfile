# Pin both WordPress and PHP version for reproducible builds
FROM wordpress:6.7.2-php8.3-fpm

# --- System packages (changes least often → best cache layer) ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# --- PHP extensions ---
RUN pecl install redis && \
    docker-php-ext-enable redis

# --- Use production php.ini as base ---
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# --- PHP / OPcache tuning ---
COPY conf.d/ "$PHP_INI_DIR/conf.d/"

# --- WP-CLI (verified checksum) ---
# Update hash when upgrading: https://github.com/wp-cli/wp-cli/releases
ENV WP_CLI_VERSION=2.12.0
ENV WP_CLI_SHA512=be928f6b8ca1e8dfb9d2f4b75a13aa4aee0896f8a9a0a1c45cd5d2c98605e6172e6d014dda2e27f88c98befc16c040cbb2bd1bfa121510ea5cdf5f6a30fe8832
RUN curl -fsSL "https://github.com/wp-cli/wp-cli/releases/download/v$WP_CLI_VERSION/wp-cli-$WP_CLI_VERSION.phar" -o /usr/local/bin/wp && \
    echo "$WP_CLI_SHA512 /usr/local/bin/wp" | sha512sum -c - && \
    chmod +x /usr/local/bin/wp

# --- Health check (php-fpm process alive) ---
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD pgrep php-fpm || exit 1

# the base image already runs as www-data via FPM