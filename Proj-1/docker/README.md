# This is a mern application with fronend, backend and mongobd 

Create a network for the docker containers
## docker network create demo

Build the client
## cd mern/frontend
## docker build -t mern-frontend .
## Run the client
## docker run --name=frontend --network=demo -d -p 5173:5173 mern-frontend

Verify the client is running
Open your browser and type http://localhost:5173 (in case of EC2 provide the public ip in local host)

Run the mongodb container
## docker run --network=demo --name mongodb -d -p 27017:27017 -v ~/opt/data:/data/db mongodb:latest

Build the server
## cd mern/backend
## docker build -t mern-backend .
## Run the server
## docker run --name=backend --network=demo -d -p 5050:5050 mern-backend

we have automated the above steps using docker compose, this will create custome network, build images in front and backend, lauch a db instance along with fron and backend container and connect them in the custome network.
## docker-compose up -d


Problems to be careful
## we need to have db container running first before the backend

## if we are launching it in ec2 instance, change the localhost to the public ip of the ec2 inside this files
## mern_app/mern/frontend/src/components/Record.yml
## mern_app/mern/frontend/src/components/RecordList.yml

## in case of lauching the composed file multiple times, make sure to remove the networks along with the containers and images created by the composed file 
