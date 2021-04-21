THIS_FILE								:= $(lastword $(MAKEFILE_LIST))
export THIS_FILE
TIME									:= $(shell date +%s)
export TIME

# PROJECT_NAME defaults to name of the current directory.
PROJECT_NAME							:= $(notdir $(PWD))
export PROJECT_NAME

#GIT CONFIG
GIT_USER_NAME							:= $(shell git config user.name)
export GIT_USER_NAME
GIT_USER_EMAIL							:= $(shell git config user.email)
export GIT_USER_EMAIL
GIT_SERVER								:= https://github.com
export GIT_SERVER
GIT_PROFILE								:= bitcoincore-dev
export GIT_PROFILE
GIT_BRANCH								:= $(shell git rev-parse --abbrev-ref HEAD)
export GIT_BRANCH
GIT_HASH								:= $(shell git rev-parse HEAD)
export GIT_HASH
GIT_REPO_ORIGIN							:= $(shell git remote get-url origin)
export GIT_REPO_ORIGIN
GIT_REPO_NAME							:= $(PROJECT_NAME)
export GIT_REPO_NAME
GIT_REPO_PATH							:= ~/$(GIT_REPO_NAME)
export GIT_REPO_PATH

ifeq ($(no-cache),true)
NO_CACHE								:= --no-cache
else
NO_CACHE								:=
endif
export NO_CACHE

ifeq ($(verbose),true)
VERBOSE									:= --verbose
else
VERBOSE									:=
endif
export VERBOSE

pwd ?= pwd_unknown

################################################################################
ifeq ($(name),)
IMG_NAME:=$(PROJECT_NAME)
else
IMG_NAME:=$(name)
endif
export IMG_NAME
################################################################################
ifeq ($(qcow2),)
USE_QCOW2:=1
else
ifeq ($(qcow2),0)
USE_QCOW2:=0
else
USE_QCOW2:=$(qcow2)
endif
endif
export USE_QCOW2
################################################################################
ifeq ($(qcow2size),)
BASE_QCOW2_SIZE:=12G
else
BASE_QCOW2_SIZE:=$(qcow2size)
endif
export BASE_QCOW2_SIZE
################################################################################
ifeq ($(release),)
RELEASE:=buster
else
RELEASE:=$(release)
endif
export RELEASE
ifneq ($(apt-proxy),true)
APT_PROXY:=unset
else
APT_PROXY:=http://172.17.0.1:3142
endif
export APT_PROXY
################################################################################
.PHONY: report
report:
	@echo ''
	@echo '	[ARGUMENTS]	'
	@echo '      args:'
	@echo '        - PWD=${PWD}'
	@echo '        - THIS_FILE=${THIS_FILE}'
	@echo '        - TIME=${TIME}'
	@echo '        - PROJECT_NAME=${PROJECT_NAME}'
	@echo '        - IMG_NAME=${IMG_NAME}                                      make name=pi-gen'
	@echo '        - USE_QCOW2=${USE_QCOW2}                                          make qcow2=1 or 0'
	@echo '        - BASE_QCOW2_SIZE=${BASE_QCOW2_SIZE}                                  make qcow2size=12G or <int>G'
	@echo '        - RELEASE=${RELEASE}                                       make release=buster or <string>'
	@echo '        - APT_PROXY=${APT_PROXY}'
	@echo '        - GIT_USER_NAME=${GIT_USER_NAME}'
	@echo '        - GIT_USER_EMAIL=${GIT_USER_EMAIL}'
	@echo '        - GIT_SERVER=${GIT_SERVER}'
	@echo '        - GIT_PROFILE=${GIT_PROFILE}'
	@echo '        - GIT_BRANCH=${GIT_BRANCH}'
	@echo '        - GIT_HASH=${GIT_HASH}'
	@echo '        - GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}'
	@echo '        - GIT_REPO_NAME=${GIT_REPO_NAME}'
	@echo '        - GIT_REPO_PATH=${GIT_REPO_PATH}'
################################################################################
.PHONY: init
init: report
	@echo 'init'
#	bash -c 'install -v $(PWD)/<somefile> /usr/local/include/'
	@echo ''
	bash -c 'echo  IMG_NAME=${IMG_NAME}           > $(PWD)/config'
	#bash -c 'echo  ${SOMEOTHER_VARIABLE}         >> $(PWD)/config'
ifneq (${APT_PROXY},unset)
	bash -c 'echo  APT_PROXY=${apt-proxy}        >> $(PWD)/config'
endif
	@echo ''
################################################################################
.PHONY: docker
docker: apt-cacher
	./build-docker.sh
################################################################################
.PHONY: apt-cacher
apt-cacher:
ifneq ($(apt-proxy),unset)
	docker-compose $(VERBOSE) build $(NO_CACHE) apt-cacher-ng
	docker-compose up -d
endif
################################################################################
.PHONY: clean
clean:
	# remove created images
	@docker-compose -p $(PROJECT_NAME)* down --remove-orphans --rmi all 2>/dev/null \
	&& echo 'Image(s) for "$(PROJECT_NAME)*" removed.' \
	|| echo 'Image(s) for "$(PROJECT_NAME)*" already removed.'
	@rm -f config
################################################################################
.PHONY: prune
prune:
	@echo 'prune'
	docker-compose -p $(PROJECT_NAME)* down
	docker system prune -af
################################################################################
.PHONY: prune-network
prune-network:
	@echo 'prune-network'
	docker-compose -p $(PROJECT_NAME)* down
	docker network prune -f
################################################################################

