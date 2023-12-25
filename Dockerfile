FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

WORKDIR /app

RUN apt update && \
    apt install -y python3-pip gcc-11 g++-11 && \
    rm -rf /var/lib/apt/lists/*

ENV CXX=g++-11 \
    CC=gcc-11 \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" \
    FORCE_CMAKE=1

RUN pip3 install llama-cpp-python[server]

# ENTRYPOINT [ "" ]

ENTRYPOINT ["python3", "-m", "llama_cpp.server", "--model", "models/llama-2-7b.Q5_K_M.gguf", "--n_gpu_layers", "35", "--port", "8080", "--host", "0.0.0.0"]