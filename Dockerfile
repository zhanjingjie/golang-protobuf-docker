# First Docker build stage: for fast local development.
FROM golang:1.19-alpine AS builder
# Install various tools for Proto code generation.
RUN apk --no-cache add gcc git libc-dev ca-certificates && \
    go install github.com/bufbuild/buf/cmd/buf@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
# Generate code from Protobuf definition. This is done early to help with Docker caching.
WORKDIR /root
COPY /protos buf.gen.yaml ./
RUN buf generate
# Get dependencies, and cache in Docker image layers for faster build.
WORKDIR /go/src/app
COPY go.mod go.sum ./
RUN go mod download -x

# Second Docker build stage: build the Golang binary.
FROM builder AS binary
COPY --from=builder /root/protos /go/src/app/protos
COPY . .
RUN go build -a -installsuffix -o main .

# Third Docker build stage: run the Golang binary in the much smaller Alpine image.
FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=binary /go/src/app/main .
CMD ["./main"]
