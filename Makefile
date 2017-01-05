
MY_IP=$(shell curl -s icanhazip.com)

all: plan

validate:
	terraform validate

plan: *.tf get ssh_keys
	terraform plan -var allowed_ip=$(MY_IP)

apply: terraform.tfstate

destroy: ssh_keys
	terraform destroy -force -var allowed_ip=$(MY_IP)
	rm -f terraform.tfstate terraform.tfstate.backup
	rm -f .tmp/*_HOST

get:
	terraform get

test: apply .tmp/BASTION_HOST quick-test

quick-test: export BASTION_HOST = $(shell cat .tmp/BASTION_HOST)

quick-test: Gemfile.lock
	./run-specs.sh

terraform.tfstate: *.tf ssh_keys get
	terraform apply -var allowed_ip=$(MY_IP)

.tmp/BASTION_HOST: terraform.tfstate
	mkdir -p .tmp
	terraform output | awk -F' *= *' '$$1 == "bastion_host_ip" { print $$2 }' > .tmp/BASTION_HOST

Gemfile.lock: Gemfile
	bundle install

ssh_keys: ~/.ssh/spin-test-instance-key ~/.ssh/spin-bastion-key

~/.ssh/spin-bastion-key:
	ssh-keygen -N '' -C 'spin-bastion-key' -f ~/.ssh/spin-bastion-key

~/.ssh/spin-test-instance-key:
	ssh-keygen -N '' -C 'spin-test-instance-key' -f ~/.ssh/spin-test-instance-key
