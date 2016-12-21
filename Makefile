
MY_IP=$(shell curl -s icanhazip.com)

specs := $(wildcard *.k)

all: plan

plan: *.tf get
	terraform plan -var allowed_ip=$(MY_IP)

apply: terraform.tfstate get

destroy:
	terraform destroy -force -var allowed_ip=$(MY_IP)
	rm -f terraform.tfstate terraform.tfstate.backup
	rm -f .tmp/*_HOST

get:
	terraform get

test: export BASTION_HOST = $(shell cat .tmp/BASTION_HOST)

test: apply .tmp/BASTION_HOST Gemfile.lock
	./run-specs.sh

terraform.tfstate: *.tf modules/*/*.tf
	terraform apply -var allowed_ip=$(MY_IP)

.tmp/BASTION_HOST: terraform.tfstate
	mkdir -p .tmp
	terraform output | awk -F' *= *' '$$1 == "bastion_host_ip" { print $$2 }' > .tmp/BASTION_HOST

Gemfile.lock: Gemfile
	bundle install

