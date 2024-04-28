# Debian 11 베이스 이미지 사용
FROM debian:bullseye-slim

# 필수 패키지 설치 및 리스트 클리어
RUN apt-get update && apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# 로그 스트림 설정 (표준 출력 및 오류)
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# 포트 443, 9000 열기
EXPOSE 443 9000

# NGINX 포그라운드 실행 명령
CMD ["nginx", "-g", "daemon off;"]
