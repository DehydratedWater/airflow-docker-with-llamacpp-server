# Hosting Airflow with local LLMs

## Goal of this project
This project is meant to be threated as a starter project for working with locally hosted LLMs via LLama.Cpp and running Airflow Dags that can use locally hosted LLMs with Langchain.

## Components provided by this project
1. Airflow + Celery
2. PostgreSQL 15 
3. Python 3.11 + pytorch & langchain
4. Dockerized LLama.Cpp server accesable from aiflow
5. Scripts for building and running Dockers
6. Dags example for connectiong with locally hosted LLMs via Langchain from Airflow