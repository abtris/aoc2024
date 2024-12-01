CURRENTDAY=$(shell date +'%d')

directory = "day${CURRENTDAY}"

all: | $(directory)
	@touch "${directory}/main.zig"
	@touch "${directory}/test_main.zig"
	@touch "${directory}/input"
	@touch "${directory}/input_test"

$(directory):
	@echo "Folder $(directory) does not exist"
	mkdir -p $@

test:
	zig test test_*

bench:
	go test -v -bench=. ./...

.PHONY: all
