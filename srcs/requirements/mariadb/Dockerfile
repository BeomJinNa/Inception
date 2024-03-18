# Debian 11을 베이스 이미지로 사용
FROM debian:bullseye-slim

# MariaDB 설치
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# 스크립트를 /docker-entrypoint-initdb.d/ 디렉토리에 복사
COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh

# 실행 권한 부여
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

# 포트 3306 열기
EXPOSE 3306

# MariaDB 포그라운드 실행
CMD ["mysqld_safe"]
