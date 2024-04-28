DOMAIN_NAME=bena.42.fr

.PHONY: up
up:
# 도커 컴포즈를 사용하여 서비스를 백그라운드 모드로 실행
	docker-compose -f srcs/docker-compose.yml up -d

.PHONY: down
down:
# 실행 중인 서비스를 중지하고 컨테이너를 제거
	docker-compose -f srcs/docker-compose.yml down

.PHONY: vdown
vdown:
# 서비스를 중지하고, 볼륨을 포함하여 컨테이너를 완전히 제거
	docker-compose -f srcs/docker-compose.yml down -v
	rm -rf /Users/bjin/data/wordpress/* /Users/bjin/data/mariadb/*

.PHONY: build
build:
# 도커 컴포즈를 사용하여 서비스에 대한 이미지를 빌드
	docker-compose -f srcs/docker-compose.yml build

.PHONY: certs
certs:
# SSL 인증서를 생성
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout srcs/certs/localhost.key -out srcs/certs/localhost.crt \
	-subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=$(DOMAIN_NAME)"

.PHONY: iclean
iclean:
# 도커 이미지 제거
	docker rmi `docker images -aq` -f

.PHONY: cclean
cclean:
# 생성된 인증서 파일 삭제
	rm -f srcs/certs/*

.PHONY: fclean
fclean:
# 모든 이미지, 컨테이너, 인증서를 포함하여 전체 청소
	$(MAKE) vdown
	$(MAKE) iclean
	$(MAKE) cclean

.PHONY: re
re:
# 서비스 재시작: 전체 청소 후 다시 빌드 및 실행
	$(MAKE) vdown
	$(MAKE) iclean
	$(MAKE) build
	$(MAKE) up
