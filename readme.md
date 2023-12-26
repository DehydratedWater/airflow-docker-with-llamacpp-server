# Hosting Airflow with local LLMs

## Goal of this project
This project is meant to be threated as a starter project for working with locally hosted LLMs via LLama.Cpp and running Airflow Dags that can use locally hosted LLMs with Langchain.

## Components provided by this project
1. Airflow with Celery and Redis
2. PostgreSQL 15 
3. Python 3.11 + pytorch, langchain, openai, pandas, ect
4. Dockerized LLama.Cpp server with support for Nvidia GPU accesable from aiflow
5. Scripts for building and running Dockers
6. Dag example for connectiong with locally hosted LLM from Airflow with use of Langchain

## Prerequisites
1. Nvidia GPU/GPUs with enough VRAM to run desired models
2. Nvidia drivers with cuda support for your system
3. Try `nvidia-smi` to check if drivers work correctly

```shell
(base) ➜  ~ nvidia-smi
Tue Dec 26 14:02:31 2023       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.129.03             Driver Version: 535.129.03   CUDA Version: 12.2     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA GeForce RTX 3090        On  | 00000000:01:00.0  On |                  N/A |
|  0%   29C    P8              38W / 350W |    513MiB / 24576MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
|   1  NVIDIA GeForce RTX 3090        On  | 00000000:02:00.0 Off |                  N/A |
|  0%   25C    P8              17W / 370W |     12MiB / 24576MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
                                                                                         
+---------------------------------------------------------------------------------------+
| Processes:                                                                            |
|  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
|        ID   ID                                                             Usage      |
|=======================================================================================|
|    0   N/A  N/A      3494      G   /usr/lib/xorg/Xorg                          152MiB |
|    0   N/A  N/A      3634      G   /usr/bin/gnome-shell                        144MiB |
|    0   N/A  N/A      5000      G   ...irefox/3600/usr/lib/firefox/firefox      141MiB |
|    0   N/A  N/A      6614      G   ...sion,SpareRendererForSitePerProcess       57MiB |
|    1   N/A  N/A      3494      G   /usr/lib/xorg/Xorg                            4MiB |
+---------------------------------------------------------------------------------------+

```

4. `Python 3.11` installed
5. Instaled `docker` with configured sudo-less docker user (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04)[Docker installation on Ubuntu 22.04], 
6. Installed `docker compose` (https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04)[Docker compose installation tutorial on Ubuntu 22.04]
6. Instaled `poetry`, used for local type checking and dag development
7. Model in `GUFF` format (https://huggingface.co/TheBloke)[Good place to find models]

__Warning__: _You may need to adapt Nvidia image version used in `LocalLLamaCPPServerDockerfile` to use CUDA version compatible with your driver, in my example it is `CUDA Version: 12.2`_


## How to start
### Run Airflow with LLama.cpp
1. Download this repository or create new with this template
2. Download choosen LLM model in `GUFF` format (or any other supported by LLama.Cpp) and put LLM model into `models` folder
3. Modify `LocalLLamaCPPServerDockerfile` to contain correct model name and number of layers that should be passed to GPU in `ENTRYPOINT` section
4. To add extra python packages use `poetry add [name of package]` or modify `pyproject.toml` and run `poetry install`, `poetry update`, select created poetry enviroment in your IDE to use typechecking
5. Run `./build_all.sh` after making it executable (if needed use `chmod +x name_of_script` for all scripts, example `sudo chmod +x build_all.sh`)
6. After whole build is finished, there should be docker image `llm-server` containing dockerized `llama.cpp` server with support for gpu, and `extending_airflow` image, containing airflow extended with choosen python libraries
7. To run it all, run `./start_all.sh` and to stop it `./stop_all.sh`
8. Use username: `airflow` and password: `airflow` to log in 
9. See `dags/test_dag.py` and `dags/test_connection_to_local_llm.py` as starting point


### How to use just dockerized model without Airflow
1. Download choosen LLM model in `GUFF` format (or any other supported by LLama.Cpp) and put LLM model into `models` folder
2. Modify `LocalLLamaCPPServerDockerfile` to contain correct model name and number of layers that should be passed to GPU in `ENTRYPOINT` section
3. To add extra python packages use `poetry add [name of package]` or modify `pyproject.toml` and run `poetry install`, `poetry update`,  select created poetry enviroment in your IDE to use typechecking
4. Run `./build_llm_server.sh` to build dockerized version of LLama.cpp server with support for GPU
5. Run `./run_llm_server.sh` and `docker kill llm-server`
6. See `run_completion_on_local_llama.py` as a starting point for development without Airflow, you can run it with Poetry enviroment


### Create `.env` for Airflow
Example of `.env`file
```
AIRFLOW_UID=1000
AIRFLOW_GID=0
```

## Workflow
1. After installation connect poetry enviroment to your IDE to have typechecking
2. You may use `DBeaver` or similar tool, to create extra database in provided `PostgreSQL` and use `airflow postgres hooks` to communicate with it from inside `Airflow dags`
3. Every `Dag` created inside `dags` folder will be visible and usable inside `Airflow`
4. You can use package `nvtop` to monitor gpu usage (https://github.com/Syllo/nvtop)[nvtop github]


## Known limitations
1. Currently these template has no support for kubernetes, but it may be added relatively easy
2. This template uses default passwords


## Credits
Parts of that template was created based on this tutorial (https://www.youtube.com/watch?v=K9AnJ9_ZAXE)[coder2j YouTube tutorial] and some insights from this (https://www.reddit.com/r/LocalLLaMA/comments/17ffbg9/using_langchain_with_llamacpp/)[Reddit thread] 