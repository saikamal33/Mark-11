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

## Project-3
### Lauch an ArgoCD inside the minikube cluster
I have deployed the argocd namespace inside the running minikube cluster and opened the 8080 port for access it through the web UI
