LIGO_VERSION=0.72.0
LIGO=docker run --rm -v "$(PWD)":"$(PWD)" -w "$(PWD)" ligolang/ligo:$(LIGO_VERSION)

#######################################################################################

help:
	@echo "hello"

#######################################################################################

ligo-compile: contracts/main.mligo
	@echo "Compiling tezos contract..."
	@$(LIGO) compile contract $^ --output-file compiled/main.tz
	@$(LIGO) compile contract $^ --michelson-format json --output-file compiled/main.json


#######################################################################################

ligo-test: ./tests/ligo/main.test.mligo
	@echo "Running tests on tezos contract..."
	@$(LIGO) run test $^

#######################################################################################

run-deploy:
	@npm --prefix run deploy


#######################################################################################

all: install ligo-compile ligo-test run-deploy
	@echo "Compiling, testing and deploying..."


#######################################################################################

install:
	# @npm --cwd ./scripts/ install
	@$(LIGO) install

#######################################################################################

sandbox-start:
	@sh ./scripts/sandbox_start


sandbox-stop:
	@docker stop flextesa-sandbox

sandbox-exec:
	@docker exec flextesa-sandbox octez-client list known addresses
	@docker exec flextesa-sandbox octez-client gen keys mike
	@docker exec flextesa-sandbox octez-client get balance for alice
	@docker exec flextesa-sandbox octez-client get balance for bob
	@docker exec flextesa-sandbox cat /root/.tezos-client/public_keys
	@docker exec flextesa-sandbox cat /root/.tezos-client/secret_keys
# ./root/.tezos-client