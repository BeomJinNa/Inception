#!/bin/bash

# MySQL 데이터베이스 서버를 안전 모드로 초기화하며 네트워킹을 비활성화
mysqld_safe --skip-networking &

# MySQL 서버가 응답할 때까지 최대 60초 동안 대기
timeout 60 bash -c 'while ! mysqladmin ping --silent; do sleep 1; done'

# 동적으로 SQL 스크립트 생성하여 환경변수에서 정보를 가져와 설정
cat > /setup.sql <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# 생성된 SQL 스크립트를 실행하여 사용자와 데이터베이스 권한 설정
mysql < /setup.sql

# 초기 설정 후 MySQL 서버 정상 종료
mysqladmin shutdown

# MySQL 데이터베이스 서버를 포그라운드 모드로 재실행
exec mysqld_safe
