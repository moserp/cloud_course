Useful commands:

ec2-describe-images
ec2-add-keypair
ec2-add-group
ec2-authorize
ec2-revoke
ec2-run-instances
ec2-terminate-instances
ec2-describe-instances
ec2-allocate-address
ec2-associate-address
ec2-describe-addresses
ec2-disassociate-address
ec2-release-address

Exercise 1: Deploying a simple application
------------------------------------------

What you need to do:

Start a new Ubuntu image. To do this you'll need to have created a keypair and
security group. You are going to need SSH (TCP port 22) and HTTP (TCP port 80)
access to your instance.

Add the key to your SSH agent and check SSH access to your instance works

Deploy the test application:
  sprinkle -s step1.rb

Check that the application is deployed, check you access it from a browser?

Allocate and associate an elastic IP address with your instance.

Check you can access the application via the new address.


Exercise 2: Automating your own deployment
------------------------------------------

The intension is to automated the deployment of two load balanaced instances of
the application used in exercise 1. 

You are going to need to deploy 2 instances of the application and a load
balancer in front of them. Don't touch the instance you had running for exercise
1 yet, get the new instances up and working first before cutting across.

TODO: what Apache configuration do you need for the load balancer
