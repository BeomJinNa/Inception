#!/bin/bash

# 필요한 디렉토리 생성 및 권한 설정
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# 워드프레스 설치 여부 확인
if [ ! -f "/var/www/html/wp-config.php" ]; then
    # 워드프레스 다운로드 및 압축 해제
    # wp-config.php가 없다면, 워드프레스가 설치되지 않은 것으로 간주하고 설치 진행
    cd /tmp
    wget https://wordpress.org/wordpress-6.4.3.tar.gz
    tar -xzf wordpress-6.4.3.tar.gz
    cp -a /tmp/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# PHP-FPM 실행
exec php-fpm7.4 -F
