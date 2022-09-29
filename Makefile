FIG=docker-compose

# Dans la ligne de commande de notre machine, on vérifie si docker-compose est disponible
HAS_DOCKER:=$(shell command -v $(FIG) 2> /dev/null)
# Si c'est le cas, EXEC et EXEC_DB vont permettre d'exécuter des commandes dans les conteneurs
ifdef HAS_DOCKER
	EXEC=$(FIG) exec app
	EXEC_DB=$(FIG) exec db
# Sinon, on exécute les commandes sur la machine locale
else
	EXEC=
	EXEC_DB=
endif

# Ligne de commande du projet Symfony
CONSOLE=php bin/console

# =========================== #
# Manipulation des conteneurs #
# =========================== #
start: ## Démarrage des conteneurs et affiche les logs en temps réel
	docker-compose up

start.daemon: ## Démarrage des conteneurs et rend la ligne de commande
	docker-compose up -d

stop: ## Arrête les conteneurs
	docker-compose down

restart: stop start.daemon ## Arrête et redémarre les conteneurs

# ===================== #
# Mise à jour du projet #
# ===================== #
update: ## Met à jour le projet avec les informations de composer.lock (ne les met pas à jour)
	$(EXEC) composer install

upgrade: ## Met à jour le projet avec les informations de composer.json (met à jour le composer.lock)
	$(EXEC) composer update


# ============= #
# Vérifications #
# ============= #
check: ## Vérification de la qualité et de la cohérence du code
	$(EXEC) composer check
	$(EXEC) $(CONSOLE) lint:container
	$(EXEC) $(CONSOLE) lint:yaml config
	$(EXEC) $(CONSOLE) lint:twig templates
	# $(EXEC) $(CONSOLE) lint:yaml translations

csfix: ## Correction (automatique) de la qualité du code
	$(EXEC) composer fix