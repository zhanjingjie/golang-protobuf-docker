package main

import (
	"context"
	"fmt"
	"log"
	"net"

	golangprotobufdockerv1 "github.com/zhanjingjie/golang-protobuf-docker/protos/gen/go/golangprotobufdocker/v1"

	"google.golang.org/grpc"
)

const GRPC_PORT int = 8080

// server is used to implement golangprotobufdockerv1.GettingStartedServiceServer.
type server struct {
	golangprotobufdockerv1.UnimplementedGettingStartedServiceServer
}

// GettingStarted implements golangprotobufdockerv1.GettingStartedServiceServer.
func (s *server) GettingStarted(ctx context.Context, in *golangprotobufdockerv1.GettingStartedRequest) (*golangprotobufdockerv1.GettingStartedResponse, error) {
	log.Printf("Received: %v", in.GetName())
	return &golangprotobufdockerv1.GettingStartedResponse{Echoed: &golangprotobufdockerv1.Echo{Hello: "hello world"}}, nil
}

// Start the gRPC server.
func main() {
	fmt.Println("hello world")

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", GRPC_PORT))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	golangprotobufdockerv1.RegisterGettingStartedServiceServer(s, &server{})
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
