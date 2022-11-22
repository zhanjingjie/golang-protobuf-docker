.PHONY: run proto-check clean

DOCKER_EXEC = docker exec golang-protobuf-docker
GRPC_PORT = 8080

# Create a long running container to optimize for build speed. No need to recreate or attach to the container.
# Some key designs:
# 1. Docker multi-stage build is used. Only the first build stage, builder, is used for local development. 
# 2. Docker volume mount (-v) is used to optimize build speed, thus no need to copy files from local to the container.
# 3. Run the Docker container in the detached mode in the background (-td). 
# 4. Copy the generated proto code from the container to local (docker cp). This is a tricky step. The generated code won't appear 
# automatically locally, given the volume mount setup. It needs to be copied out, and this will help satify the IDE to find the generated pb files.
# 4. This setup works across AMD and ARM architecture. Proper Docker image will be used automatically to optimize local build speed. 
run-base:
	@if [ "$(shell docker ps --filter=name=golang-protobuf-docker -q)" = "" ]; then \
		DOCKER_SCAN_SUGGEST=false docker build --target builder -t golang-protobuf-docker-base . && \
		docker run \
			-p 0.0.0.0:$(GRPC_PORT):$(GRPC_PORT)/tcp \
			-v $(shell pwd):/go/src/app \
			--name golang-protobuf-docker \
			-td golang-protobuf-docker-base; \
		docker cp golang-protobuf-docker:root/protos/gen protos; \
	fi;

# Exec into the docker container to rerun the Go app.
run: run-base
	@docker exec -it golang-protobuf-docker go run /go/src/app/main.go

# Check proto definitions against linting rules and fix some linting issues automatically. Check for backward compatibility.
proto-check: run-base
	@$(DOCKER_EXEC) buf lint
	@$(DOCKER_EXEC) buf breaking --against '.git#branch=main' # This should only be enabled after the protos already exists on the main branch.
	@$(DOCKER_EXEC) buf format -w --exit-code

# Remove the container and generated proto code.
clean:
	@docker stop golang-protobuf-docker && docker rm golang-protobuf-docker || exit 0
	rm -rf protos/gen
