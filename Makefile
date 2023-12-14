all: shards prebuild build-static strip

shards:
	shards install --production
shards-devel:
	shards install
prebuild:
	mkdir -p bin
build: prebuild
	crystal build --release --no-debug -s -p -t src/pingasius.cr -o bin/pingasius
build-static:
	crystal build --release --static --no-debug -s -p -t src/pingasius.cr -o bin/pingasius
strip:
	strip bin/pingasius
run:
	crystal run src/pingasius.cr
test: shards-devel
	./bin/ameba
