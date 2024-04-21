#!/bin/bash

# 필요한 디렉토리 생성 및 권한 설정
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# 워드프레스 설치 여부 확인
if [ ! -f "/var/www/html/wp-config.php" ]; then
    # 워드프레스 다운로드 및 압축 해제
    cd /tmp
    wget https://wordpress.org/wordpress-6.4.3.tar.gz
    tar -xzf wordpress-6.4.3.tar.gz
    cp -a /tmp/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html

    # wp-config.php 생성
    cat > /var/www/html/wp-config.php <<EOF
<?php
define( 'DB_NAME', getenv('WORDPRESS_DB_NAME') );
define( 'DB_USER', getenv('WORDPRESS_DB_USER') );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') );
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

define('WP_DEBUG', true);

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF
    chown www-data:www-data /var/www/html/wp-config.php
fi

if grep -q ';clear_env = no' /etc/php/7.4/fpm/pool.d/www.conf; then
    sed -i 's/;clear_env = no/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
elif grep -q ';clear_env = yes' /etc/php/7.4/fpm/pool.d/www.conf; then
    sed -i 's/;clear_env = yes/clear_env = no/' /etc/php/7.4/fpm/pool.d/www.conf
else
    echo "clear_env = no" >> /etc/php/7.4/fpm/pool.d/www.conf
fi

# PHP-FPM 실행
exec php-fpm7.4 -F
