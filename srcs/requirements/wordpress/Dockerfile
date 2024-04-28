# WordPress용 Debian 베이스 이미지 설정
FROM debian:bullseye-slim

# 필수 PHP 패키지 및 의존성 설치
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wordpress wget curl && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /run/php && chown www-data:www-data /run/php && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM을 TCP 포트 9000으로 리스닝하도록 설정 변경
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf

# PHP-FPM 사용을 위해 포트 9000 공개
EXPOSE 9000

# entrypoint 스크립트 복사 및 실행 권한 설정
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# entrypoint.sh를 통해 PHP-FPM 실행
ENTRYPOINT ["/entrypoint.sh"]
