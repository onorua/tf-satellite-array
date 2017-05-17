# tf-satellite
Main satellite module for terraform per colo

It stores states and lock in `tf_remote_state` bucket, in `us-east-1` region, unless pecified. It expects key (the path) to be specified during importing as a variable. 

# what it does

- adds CNAME record for LB, e.g. nyc2.prod.satellite.afdevops.com pointin to lb.nyc2.prod.satellite.afdevops.com
- adds CNAME record for LB, e.g. lb.nyc2.prod.satellite.afdevops.com pointin to lb-01.nyc2.prod.satellite.afdevops.com and lb-02.nyc2.prod.satellite.afdevops.com
- adds A record per worker node, e.g. sat-worker-01.nyc2.prod.satellite.afdevops.com
- adds A record for load balancer instances e.g. lb-01.nyc2.prod.satellite.afdevops.com
- places IP of the first worker into /tmp/redis-master file, which is read by redis-sentinel during initial startup

Module Input Variables
----------------------

- `provider` (required) - The desired hosting provider, (i.e. aws)
- `name_prefix` (required) - The name prefix of the instance, i.e hss for hss-0
- `nodes` (required) - The number of desired nodes in the array
- `location` - Region, Location, Datacenter, Availability Zone: us-east-1a,nyc3 (Depends on provider)
- `aws_region` - AWS specific region: us-east-1
- `size` - Size: m3.medium,512mb (Depends on region and provider)
- `image` - AMI or Image name for instances
- `user` - Initial user to connect and provision
- `ttl` - TTL for DNS records (default: 60)
- `ssh_port` - Default 22

