OK_COLOR=\033[32;01m
NO_COLOR=\033[0m
ERROR_COLOR=\033[31;01m
OK=\033[97;01m

## usage: show available actions
usage: Makefile
	@echo "$(OK_COLOR)to use make call:$(NO_COLOR)"
	@echo "$(OK)make <action>:$(NO_COLOR)"
	@echo ""
	@echo "$(OK_COLOR)list of available actions:$(NO_COLOR)"
	@sed -n 's/^##//p' $< | column -t -s ':' | sed -e 's/^/ /'

## build-e2e: build e2e image
build-e2e:
	@echo "$(OK_COLOR)==> Building e2e image $(NO_COLOR)"
	cd e2e && docker-compose build

## all-e2e-tests: run all tests e2e
all-e2e-tests:
	@echo "$(OK_COLOR)==> Running all e2e tests $(NO_COLOR)"
	cd e2e && docker-compose run --rm pyresttest 1

## choose-e2e-test: run a specific e2e test by choosing the test file number
choose-e2e-test:
	@echo "$(OK_COLOR)==> Running a specific by choosing test $(NO_COLOR)"
	cd e2e && docker-compose run --rm pyresttest 2

## specific-e2e-test: run a specific e2e test by file name, pass TEST_NAME=<file_name> to make command
specific-e2e-test:
	@echo "$(OK_COLOR)==> Running a specific e2e test by file name $(NO_COLOR)"
	cd e2e && docker-compose run --rm -e TEST_NAME=$(TEST_NAME) pyresttest 3
