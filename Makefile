NAME = iruby
SUFFIX =
IMAGE = dergachev/$(NAME)$(SUFFIX)
CONTAINER = $(NAME)$(SUFFIX)
DOCKER_HOSTNAME = $(shell hostname)

PORT_PREFIX = 82
HTTP_PORT = $(PORT_PREFIX)80
PORTS = -p $(HTTP_PORT):9999 
LINKS =
RUN_OPTS = -d
BUILD_OPTS =
RUN = docker run $(PORTS) $(LINKS) $(RUN_OPTS) --name=$(CONTAINER)
RUN_CMD =

assets/jupyter-access-config.txt: assets/password
	python2 scripts/notebook-hash.py $$(cat assets/password) > $@

assets/password:
	mkdir -p assets/
	pwgen -1 16 > $@

build: assets/jupyter-access-config.txt
	docker build -t dergachev/iruby .

# launch debug shell in latest (intermediate) image; useful if 'docker build' fails
debug_latest:
	docker run -t -i --rm `docker images -q | head -n 1` /bin/bash

run:
	$(RUN) $(IMAGE) $(RUN_CMD)

rm: stop
	-docker rm $(CONTAINER)

start:
	docker start $(CONTAINER)

stop:
	-docker stop $(CONTAINER)

bash:
	docker exec -ti $(CONTAINER) bash
