iaas-azure-kubernetes
=====================

This project is a good starting point to learn how to install and configure a
[Kubernetes](https://kubernetes.io) cluster on Azure using IaaS concepts.

- Cloud provider is [Azure](https://azure.microsoft.com/)
- VM provisioning is fueled by [Terraform](https://www.terraform.io/).
- Kubernetes Cluster configuration by [Ansible](https://www.ansible.com/)
- Kubernetes networking by [Calico](https://www.projectcalico.org/calico-networking-for-kubernetes/)

It acts as a proof of concept and this configuration is not ready for production use.

Each time master or node is mentioned, it refers to kubernetes server definition. In this example we set up only
one master and one node but more is possible if you want to.

## Quickstart

### Provision

First you have to provision virtual machines and other related objects on Azure.
Terraform files are located in `terraform` folder.

It will set up :
* 2 virtual machines, with network, disk and public ip. One master and one node. Azure size `Standard_DS2_v2`
* a resource group
* a virtual network
* a network security group
* the same ssh key for all vm
* a storage account for boot diagnostics

Shortcut:

    cd terraform
    terraform init
    az login
    # edit varaibles.tf with your subscription_id and tenant_id 
    terraform validate
    terraform plan
    terraform apply


When all this is applied, add the private ssh key to your local ssh agent and try to log in using `azureuser` user account.

### Configure kubernetes

First, edit the `hosts` file by adding the master and node public ips.

Then we use ansible to configure master node first.

    cd ansible
    ansible-playbook --user azureuser -i hosts -l master master.yml

After master ok, launch ansible for nodes :

    ansible-playbook --user azureuser -i hosts -l node node.yml

This project is much more a reminder for me on how to create iaas on azure, but to say it's done and functioning, I 
wanted to run a kubernetes cluster on it, sharing this on github.com.

[AKS](https://azure.microsoft.com/services/kubernetes-service/) might be a simplier solution in some cases \o/

## TODO
* [] use terragrunt to not repeat vm terraform configuration if adding more vm
* [] maybe fine tune kubernetes, but not purpose of this pooc project
