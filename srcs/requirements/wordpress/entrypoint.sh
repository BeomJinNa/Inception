#!/bin/bash

# 필요한 웹서버 디렉토리 생성 및 권한 설정
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# wp-config.php 존재 여부 확인 및 조건부 실행
if [ ! -f "/var/www/html/wp-config.php" ]; then
    # 워드프레스 최신 버전 다운로드 및 압축 해제
    cd /tmp
    wget https://wordpress.org/wordpress-6.5.2.tar.gz
    tar -xzf wordpress-6.5.2.tar.gz
    cp -a /tmp/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html

    # 환경변수를 사용하여 wp-config.php 파일 생성
    cat > /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', getenv('WP_DB_NAME') );
define( 'DB_USER', getenv('WP_DB_USER') );
define( 'DB_PASSWORD', getenv('WP_DB_PASSWORD') );
define( 'DB_HOST', getenv('WP_DB_HOST') );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

define( 'AUTH_KEY',         getenv('AUTH_KEY') );
define( 'SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY') );
define( 'LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY') );
define( 'NONCE_KEY',        getenv('NONCE_KEY') );
define( 'AUTH_SALT',        getenv('AUTH_SALT') );
define( 'SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT') );
define( 'LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT') );
define( 'NONCE_SALT',       getenv('NONCE_SALT') );

\$table_prefix = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF
    chown www-data:www-data /var/www/html/wp-config.php

    # WP-CLI를 이용한 워드프레스 핵심 설치 및 설정
    wp core install --url="${DOMAIN_NAME}" --title="${WP_TITLE}" \
    --admin_user="${ADMIN_USER}" --admin_password="${ADMIN_PASSWORD}" \
    --admin_email="${ADMIN_EMAIL}" --path="/var/www/html" --allow-root

    # 테마 활성화 및 플러그인 설치
    wp theme activate ${WP_THEME} --path="/var/www/html" --allow-root
    wp plugin install ${WP_PLUGINS} --activate --path="/var/www/html" --allow-root

    # 추가 사용자 계정 생성
    wp user create ${EXTRA_USER} ${EXTRA_USER_EMAIL} \
    --role=${EXTRA_USER_ROLE} --user_pass=${EXTRA_USER_PASSWORD} \
    --path="/var/www/html" --allow-root
fi

# PHP-FPM 환경 변수 클리어 설정 확인 및 조정
if grep -q ';clear_env = no' /etc/php/7.4/fpm/pool.d/www.conf; then
    sed -i 's/;clear_env = no/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
elif grep -q ';clear_env = yes' /etc/php/7.4/fpm/pool.d/www.conf; then
    sed -i 's/;clear_env = yes/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
else
    echo "clear_env = no" >> /etc/php/7.4/fpm/pool.d/www.conf
fi

# PHP-FPM 서비스 실행
exec php-fpm7.4 -F
