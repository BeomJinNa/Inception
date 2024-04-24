# WordPress Dockerfile
FROM debian:bullseye-slim

# Install PHP and dependencies
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wordpress wget curl && \
    rm -rf /var/lib/apt/lists/* && \
	mkdir -p /run/php && chown www-data:www-data /run/php && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on TCP instead of a socket
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# entrypoint.sh를 추가
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start PHP-FPM
ENTRYPOINT ["/entrypoint.sh"]
