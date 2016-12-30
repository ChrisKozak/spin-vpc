# WARNING!

This code is intended as an example that you can copy and use, rather than a supported module that you should import. I reserve the right to completely change it in dangerous and destructive ways, with complete disregard for backwards compatibility.

Also, I make no guarantees that this code works as you find it. There's a pretty good chance that it's broken, because I'm in the middle of a change, because I'm using it in some way specific to myself, because I've neglected it, or for some other reason.


## What this is

This is a Terraform module that can be used to create the skeleton infrastructure for an environment, based around a VPC. It includes:

- One VPC
- A public Subnet (intention to make one per AZ)
- A private Subnet (intention to make one per AZ)
- Basic routes and gateways
- An ssh bastion host, and security groups that enable:
-- ssh access to the bastion from the machine you run Terraform from
-- ssh access from the bastion to the private subnet
-- all access to the public Internet from both private and public subnets

The idea is that you can import your own copy of this module into a Terraform project, and only define the things specific to whatever you're working on.


## What else is in here

- I've written tests using serverspec and awspec. These may be useful as examples for writing tests for your own infrastructure.
- I use a Makefile to run Terraform and tests. I like using Makefiles for this. You might, too.


## How to use this code

TODO: explain how to use this.

I run up a Vagrant box and run this stuff in there. I haven't made it available yet.

## Variables to set

- __aws_region__: Self-explanatory. Default is eu-west-1.
- __service_name__: This plus the environment variable is used in *Name* tags for things. Each instance of the VPC should have a unique combination of *service_name* + *environment*. If you run up multiple instances with the same *service_name* + *environment* things may get messy, as there are things (e.g. the tests) which assume this won't happen.
- __environment__: This is assigned to an *Environment* tag. You can set this to the same value across multiple services, each with their own VPC, and then use this tag to integrate them.
- __allowed_ip__: This is the IP address allowed to connect to the VPC.
- __bastion_ssh_key_public_file__



## What I don't like about this code

- I don't like how the tests run. Because serverspec is only intended to work on a single server, and I need to run it against multiple servers, rspec needs to be run once per server. Currently I do that by running it once per spec file, using a shell script. If one spec fails, it doesn't run the rest of them. I'm sure there's a better way.
- I'm also not entirely happy with how the tests are written. Partly this is because I don't have deep experience with rspec. Partly this because I'm still figuring out how I think the tests should be organized. And I suspect it's partly because the testing libraries I'm using aren't written to work in the way that I'd like them to.


## What else I'd like to do at some point

- Automatically set the stuff up across all of the availability zones available in the region. Have tests that check this against in a few different regions.
- CI to automatically test this stuff when I commit.
- Cleaner integration points. Maybe support Consul? Maybe integrate with statefiles? Shared tfvars files? Other options?
- Store state in S3
- Lock the bastion host down much tighter
- Be more clever about ssh keys. One-off keys for testing, potentially disable the default keypair after provisioning, set up authorized_keys in a configurable way.
- More sophisticated allowed_ip handling. Currently this assumes all access is from a single IP, which is fine for messing around on your own. Needs to support teams working from different locations, environments spun up from a hosted CI/CD service, not to mention public access for public services. In the latter case, I'd like to default to a controlled set of IP addresses, with an option for production environments which open up things that need to be open (e.g. http/s), but still keep some things (e.g. ssh) limited.
- Assign DNS names to things
- Automatically support the right number of AZ's for the given region. Reliant on resolution to https://github.com/hashicorp/terraform/issues/1497


