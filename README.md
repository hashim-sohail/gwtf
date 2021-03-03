## Pre reqs
- Login to aws console
- Select your required region
- Create a Key pair `icap-bastion-key` and download in `~/.ssh/gw/<location>/icap-bastion-key.pem`

## Provision Bastion Host
- Copy provided pem key file `~/.ssh/gw/<location>` in your local pc

- Clone project in your local pc to provision Bastion host

```
git clone https://github.com/khawarhere/gwtf.git

cd gwtf/bastion

terraform init

terraform plan

terraform apply -auto-approve
```
- ssh -i ~/.ssh/gw/<key_file.pem> ubuntu@<public_ip>

Configure AWS Cli
```
aws configure
```
- Copy provided credentials

## Provision Cluster

```
git clone https://github.com/khawarhere/gwtf.git

cd gwtf

terraform init

terraform plan

terraform apply -auto-approve

```
- Copy ELB DNS from output, open in browser, and reload again and again to view balancing

- After completion of everything

```
terraform destroy
```

- disconnect ssh from bastion  <Ctr + d>

- In your local pc cd into project `gwtf/bastion`

- destroy bastion as well

```
terraform destroy
```