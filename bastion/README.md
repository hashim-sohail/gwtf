- copy pem key file ~/.ssh/

- ssh -i ~/.ssh/<key_file.pem> ubuntu@<public_ip>


Configure AWS Cli
```
aws configure
```

```
git clone https://github.com/khawarhere/gwtf.git

cd gwtf

terraform init

terraform plan

terraform apply -auto-approve

terraform output icap_ec2_public_ip
```


- After completion of everything

```
terraform destroy
```