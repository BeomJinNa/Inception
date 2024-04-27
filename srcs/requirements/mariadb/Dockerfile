# Debian 11을 베이스 이미지로 사용
FROM debian:bullseye-slim

# MariaDB 설치
RUN apt-get update && \
	apt-get install -y mariadb-server && \
	rm -rf /var/lib/apt/lists/*

# MariaDB 설정 변경
RUN sed -i 's/bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB 데이터 디렉토리 소유권 변경
RUN chown -R mysql:mysql /var/lib/mysql

# 포트 3306 열기
EXPOSE 3306

# 사용자 정의 entrypoint 스크립트 추가
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 사용자 정의 entrypoint 실행
ENTRYPOINT ["/entrypoint.sh"]
