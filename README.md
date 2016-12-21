
**WARNING!** This code is intended as an example that you can copy and use, rather than a supported module that you should import. I reserve the right to completely change it in dangerous and destructive ways, with complete disregard for backwards compatibility. Also, I make no guarantees that this code works as is. There's a pretty good chance that it's broken, due to neglect or different usage.


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


## What I don't like about this code

- I don't like how the tests run. Because serverspec is only intended to work on a single server, and I need to run it against multiple servers, rspec needs to be run once per server. Currently I do that by running it once per spec file, using a shell script. If one spec fails, it doesn't run the rest of them. I'm sure there's a better way.
- I'm also not entirely happy with how the tests are written. Partly this is because I don't have deep experience with rspec. Partly this because I'm still figuring out how I think the tests should be organized. And I suspect it's partly because the testing libraries I'm using aren't written to work in the way that I'd like them to.


## What else I'd like to do at some point

- Automatically set the stuff up across all of the availability zones available in the region. Have tests that check this against in a few different regions.
- CI to automatically test this stuff when I commit.
- Cleaner integration points. Maybe support Consul? Maybe integrate with statefiles? Shared tfvars files? Other options?
- Store state in S3



