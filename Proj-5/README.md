# Python program to generate the Docker image with the help of genAI

## Prerequisites

Download and install Ollama

    curl -fsSL https://ollama.com/install.sh | sh

Stating the Server

    ollama server

pulling Ollama model

    ollama pull llama3.2:1b


## Setup

we need to have python and python-venv installed in the system

1) Create a virtual env

       python3 -m venv venv
       source venv/bin/activate
2) Install dependencies
   
       pip3 install -r requirements.txt
3)Now we can run the application

    python3 generate_dockerfile.py

in this Repo there are two python codes that can generate the docker images based on the language. one imports subprocess while the other uses ollama import to process the request
