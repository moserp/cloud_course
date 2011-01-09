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
a security group. You are going to need SSH (TCP port 22) and HTTP (TCP port
80) access to your instance.

Add the key to your SSH agent and check SSH access to your instance works

Modify the deployment script (exercise_1.rb) to specifiy the IP address of the
instance you want to deploy to.

Deploy the test application:
  sprinkle -s exercise_1.rb

Check that the application is deployed, check you can access it from a browser?

Allocate and associate an elastic IP address with your instance.

Check you can access the application via the new address.


Exercise 2: Automating your own deployment
------------------------------------------

The intension is to automated the deployment of two load balanaced instances of
the application used in exercise 1.

You are going to need to deploy 2 instances of the application and a load
balancer in front of them. Don't touch the instance you had running for exercise
1 yet, get the new instances up and working first before cutting across.

You can use Apache as a load balancer, but the generically installed version
takes some configuring to get it to work as a load balancer:

You need to symlink
  /etc/apache2/mods-available/proxy.conf to /etc/apache2/mods-enabled/proxy.conf'
  /etc/apache2/mods-available/proxy.load to /etc/apache2/mods-enabled/proxy.load'
  /etc/apache2/mods-available/proxy_http.load to /etc/apache2/mods-enabled/proxy_http.load'
  /etc/apache2/mods-available/proxy_balancer.load to /etc/apache2/mods-enabled/proxy_balancer.load'

And replace the default virtual host configuration in /etc/apache2/sites-enabled with:

<VirtualHost *:80>

  <Proxy balancer://mycluster>
    Order allow,deny
    Allow from all
    BalancerMember http://109.144.14.183:80
    BalancerMember http://109.144.14.184:80
  </Proxy>
  ProxyPass / balancer://mycluster

  ErrorLog /var/log/apache2/error.log
  LogLevel warn

  CustomLog /var/log/apache2/access.log combined
</VirtualHost>

(using the IP addresses of you two application instances)

You should be able to just use the installers (runner, push_text, transfer) but
more information is avalable about other installers at
https://github.com/crafterm/sprinkle and specifically - just read the code! -
https://github.com/crafterm/sprinkle/tree/master/lib/sprinkle/installers


If you access the page served from the load balancer s few times you should see
it display the IP addresses of both application instances.

Disassociate the elastic address from your original (exercise 1) instance and
allocate it to your load balancer. Try accessing the load balancer from this
new address, you should still see it server pages from both instances.
