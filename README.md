<div align="center">
    <h1>Golang Protobuf Docker</h1>
    <img src="https://github.com/zhanjingjie/golang-protobuf-docker/actions/workflows/protos.yml/badge.svg" />
</div>

## 👀 Overview

Protobuf is a fantastic tool with a fantastic promise. But on the tooling side, there's a lot left to be desired. And a lot has to be figured out by the adopting team. This repo is a fully working solution to address the gap in the Protobuf tooling. 

It leverages Docker, Buf, GitHub Action, Artifactory to work with Protobuf and Golang. And this solution can be easily extended to support other languages' Protobuf needs.

<sub><code>Golang Protobuf Docker</code> is built with ❤︎ by <a href="zhanjingjie@outlook.com">Jingjie Zhan (Tech Lead at Roblox)</a>

## 🎁 Features

+ Fully automate the code generation from proto definitions.
  + Everything is done inside a Docker container. So it works across languages and platforms. 
  + No need to install tools locally.
  + No need to check in generated code.
  + It works on both local and CI.
  + Very fast code generation with proper caching.
+ Protobuf linting and backward compatibility check on both local and CI.
+ Publish gRPC golang clients automatically to Artifactory via GitHub Action.


## 👩‍💻 How to get started

Clone down the repo: 
```
git clone https://github.com/zhanjingjie/golang-protobuf-docker.git
```

This command will work right out of the gate. It will generate code from protos, and create a gRPC server and example API. And all of these happen inside a Docker container.
```
make run
```

This command will do protobuf linting and backward compatibility check.
```
make proto-check
```

This command will stop the docker container and remove the generated code.
```
make clean
```
