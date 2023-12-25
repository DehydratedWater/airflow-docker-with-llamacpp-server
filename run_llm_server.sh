#!/usr/bin/bash

docker remove llm-server

docker run --gpus all -d -v "$(pwd)/models:/app/models" -p 5555:8080 --name llm-server llm-server