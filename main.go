package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"os"
	"strconv"

	helloworldv1 "github.com/zhanjingjie/golang-protobuf-docker/protos/gen/go/helloworld/v1"

	"google.golang.org/grpc"
)

type server struct {
	helloworldv1.UnimplementedGreeterServiceServer
}

// This implements the GreeterServiceServer interface.
func SayHello(c context.Context, r *helloworldv1.SayHelloRequest) (*helloworldv1.SayHelloResponse, error) {
	log.Printf("Received: %v", r.Name)
	return &helloworldv1.SayHelloResponse{Message: "hello world"}, nil
}

// Start the gRPC server.
func main() {
	p, err := strconv.Atoi(os.Getenv("GRPC_PORT"))
	if err != nil {
		log.Fatalf("cannot load grpc port: %v", err)
	}
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", p))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	helloworldv1.RegisterGreeterServiceServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
