
MY_IP=$(shell curl -s icanhazip.com)
ENVIRONMENT?=sandbox
BASE_DOMAIN=$(shell cat CONFIG_DOMAIN)

all: plan

validate:
	terraform validate

plan: *.tf ssh_keys init-terraform
	terraform plan -var allowed_ip=$(MY_IP) -var environment=$(ENVIRONMENT)

apply: terraform.tfstate

terraform.tfstate: *.tf ssh_keys init-terraform
	terraform apply -var allowed_ip=$(MY_IP) -var environment=$(ENVIRONMENT)

destroy: ssh_keys init-terraform
	@echo "Destroying the remote environment"
	terraform destroy -force -var allowed_ip=$(MY_IP) -var environment=$(ENVIRONMENT)
	rm -rf .terraform
	rm -f terraform.tfstate terraform.tfstate.backup
	rm -rf .tmp

clean:
	@echo "Cleaning local state, not touching the remote environment"
	rm -rf .terraform
	rm -f terraform.tfstate terraform.tfstate.backup
	rm -rf .tmp

init-terraform: get-module get-state

get-module:
	terraform get

get-state: check-env
	terraform remote config \
    -backend=s3 \
    -backend-config="bucket=$(BASE_DOMAIN).tfstate" \
    -backend-config="key=$(ENVIRONMENT)/vpc-module-test/terraform.tfstate" \
    -backend-config="region=eu-west-1"

test: apply .tmp/BASTION_HOST quick-test

quick-test: export BASTION_HOST = $(shell cat .tmp/BASTION_HOST)

quick-test: Gemfile.lock
	./run-specs.sh

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

check-env:
ifeq ($(BASE_DOMAIN),)
	$(error BASE_DOMAIN is undefined, should be in file CONFIG_DOMAIN)
endif
