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
docker:
	docker buildx build --tag userunknowned/pingasius:0.1.1 --tag userunknowned/pingasius:latest .
test: shards-devel
	./bin/ameba
