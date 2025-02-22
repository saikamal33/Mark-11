# Mark-11
Composed project
## Projest -2
### Lauch the EC2 instance using terraform script
in this we will launch an EC2 instance with 80 port exposed.becasue of the ansible webapp lauched.
~~~
terraform init & terraform plan & terraform apply -auto-approve
~~~

~~~
./inv_store.sh
~~~

we can run this inside the terraform directory

### website lauch using Ansible 
Post executing the terraform successfuly, we need to run the inv_store.sh script to store the instance ip inside the ansible inventory.

~~~
ansible-playbook -i <inventory> <playbook.yml>
~~~


## Project -3
### Spring Boot based Java web application
### Execute the application locally and access it using your browser
we need to clone this repo and change into this proj root file
~~~
git clone https://github.com/saikamal33/Mark-11
cd ci_cd_full_pipe-Proj-3
~~~

To execute the maven
~~~
mvn clean package
~~~
To deploy in docker
~~~
docker build -t ultimate-cicd-pipeline:v1 .
~~~
~~~
docker run -d -p 8010:8080 -t ultimate-cicd-pipeline:v1
~~~
we can access this using "http://localhost:8010" apt install unzip


## Sonarqube server locally
We can install sonarqube in the server using below steps
~~~
adduser sonarqube
su - sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip
unzip *
chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424
cd sonarqube-9.4.0.54424/bin/linux-x86-64/
./sonar.sh start
~~~
we can access it using " http://<*ip address*>:9000 "
