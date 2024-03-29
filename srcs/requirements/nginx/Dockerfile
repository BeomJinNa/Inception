# Debian 11을 베이스 이미지로 사용
FROM debian:bullseye-slim

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y nginx openssl

# SSL 인증서 생성 (자체 서명)
RUN mkdir -p /etc/nginx/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/localhost.key \
    -out /etc/nginx/certs/localhost.crt \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=bena.42.fr"

# 로그 스트림 설정
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# 포트 80, 443 열기
EXPOSE 80 443

# NGINX 포그라운드 실행
CMD ["nginx", "-g", "daemon off;"]
