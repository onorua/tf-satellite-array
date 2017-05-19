variable "provider" {
  default     = "do"
  description = "The desired hosting provider, (i.e. aws)"
}

variable "name_prefix" {
  description = "The name prefix of the instance, i.e hss for hss-0"
}

variable "weight" {
  default = "100"
  description = "Weight of the load balancer, default is 100"
}


variable "nodes" {
  description = "The number of desired nodes in the array"
}

variable "location" {
  description = "Region, Location, Datacenter, Availability Zone: us-east-1a,nyc3 (Depends on provider)"
}

variable "deployment" {
  description = "Deployment type, e.g. production, stage, dev"
}

variable "aws_region" {
  default     = ""
  description = "AWS specific region: us-east-1"
}

variable "aws_zone_id" {
  default     = "Z2C8NT70Y9T77S"
  description = "DNS zone id in which the array resides: Z2C8NT70Y9T77S (satellite.afdevops.com)"
}

variable "size" {
  default     = ""
  description = "Size: m3.medium,512mb (Depends on region and provider)"
}

variable "image" {
  default     = ""
  description = "AMI or Image name for instances"
}

variable "user" {
  default     = ""
  description = "Initial user to connect and provision"
}

variable "ssh_port" {
  default     = "22"
  description = "Initial port for ssh connection"
}

variable "ttl" {
  default     = "60"
  description = "TTL for DNS records (default: 60)"
}
