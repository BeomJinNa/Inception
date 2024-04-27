#!/bin/bash
# 데이터베이스 서버를 초기화합니다.
mysqld_safe --skip-networking &

# MySQL 서버가 준비될 때까지 기다립니다.
timeout 60 bash -c 'while ! mysqladmin ping --silent; do sleep 1; done'

# 동적으로 SQL 스크립트 생성
cat > /setup.sql <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# setup.sql 스크립트를 실행합니다.
mysql < /setup.sql

# MySQL 서버를 종료합니다.
mysqladmin shutdown

# 데이터베이스 서버를 포그라운드로 실행합니다.
exec mysqld_safe
