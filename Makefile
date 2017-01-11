
MY_IP=$(shell curl -s icanhazip.com)
ENVIRONMENT?=sandbox
BASE_DOMAIN=$(shell cat CONFIG_DOMAIN)

all: plan

validate:
	terraform validate

plan: *.tf get ssh_keys remote_state
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

terraform.tfstate: *.tf ssh_keys remote_state get
	terraform apply -var allowed_ip=$(MY_IP)

remote_state: check-env
	terraform remote config \
    -backend=s3 \
    -backend-config="bucket=$(BASE_DOMAIN).tfstate" \
    -backend-config="key=$(ENVIRONMENT)/vpc-module-test/terraform.tfstate" \
    -backend-config="region=eu-west-1"

.tmp/BASTION_HOST: terraform.tfstate remote_state
	mkdir -p .tmp
	terraform output | awk -F' *= *' '$$1 == "bastion_host_ip" { print $$2 }' > .tmp/BASTION_HOST

Gemfile.lock: Gemfile
	bundle install

ssh_keys: ~/.ssh/spin-test-instance-key ~/.ssh/spin-bastion-key

~/.ssh/spin-bastion-key:
	ssh-keygen -N '' -C 'spin-bastion-key' -f ~/.ssh/spin-bastion-key

~/.ssh/spin-test-instance-key:
	ssh-keygen -N '' -C 'spin-test-instance-key' -f ~/.ssh/spin-test-instance-key

check-env:
ifeq ($(BASE_DOMAIN),)
	$(error BASE_DOMAIN is undefined, should be in file CONFIG_DOMAIN)
endif
