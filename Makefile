CURRENTDAY=$(shell date +'%d')

directory = "day${CURRENTDAY}"

all: | $(directory)
	@touch "src/${directory}/main.zig"
	@touch "src/${directory}/test_main.zig"
	@touch "src/${directory}/input"
	@touch "src/${directory}/input_test"

$(directory):
	@echo "Folder $(directory) does not exist"
	mkdir -p $@

test:
	zig build test

bench:
	go test -v -bench=. ./...

.PHONY: all
