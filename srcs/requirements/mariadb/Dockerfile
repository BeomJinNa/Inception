# Debian 11 (bullseye-slim)을 기반 이미지로 사용
FROM debian:bullseye-slim

# MariaDB 서버 설치
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    # 패키지 설치 후 불필요한 파일 제거로 이미지 크기 감소
    rm -rf /var/lib/apt/lists/*

# MariaDB 외부 접속 허용 설정 (기본값은 localhost만 허용)
RUN sed -i 's/bind-address\s*=\s*127\.0\.0\.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# MariaDB 데이터 디렉토리 소유권 mysql 사용자로 변경
RUN chown -R mysql:mysql /var/lib/mysql

# 포트 3306 열기 (MariaDB 기본 포트)
EXPOSE 3306

# 사용자 정의 entrypoint 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# entrypoint 스크립트를 통해 MariaDB 서버 실행
ENTRYPOINT ["/entrypoint.sh"]
