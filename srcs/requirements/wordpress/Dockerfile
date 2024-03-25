# WordPress Dockerfile
FROM debian:bullseye-slim

# Install PHP and dependencies
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wordpress && \
    rm -rf /var/lib/apt/lists/* && \
	mkdir -p /run/php && chown www-data:www-data /run/php

# Configure PHP-FPM to listen on TCP instead of a socket
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm7.4", "-F"]
