FIG=docker-compose
HAS_DOCKER:=$(shell command -v $(FIG) 2> /dev/null)

ifdef HAS_DOCKER
	EXEC=$(FIG) exec app
	EXEC_DB=$(FIG) exec db
else
	EXEC=
	EXEC_DB=
endif

# Symfony command
CONSOLE=php bin/console

check:
	$(EXEC) composer check

csfix:
	$(EXEC) composer fix

start:
	docker-compose up

start.daemon:
	docker-compose up -d

stop:
	docker-compose down

restart: stop start.daemon

update:
	$(EXEC) composer install
