.PHONY: up
up:
	docker-compose -f srcs/docker-compose.yml up -d

.PHONY: down
down:
	docker-compose -f srcs/docker-compose.yml down

.PHONY: build
build:
	docker-compose -f srcs/docker-compose.yml build

.PHONY: certs
certs:
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout srcs/certs/localhost.key -out srcs/certs/localhost.crt \
	-subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=${DOMAIN_NAME}"
