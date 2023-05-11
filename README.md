# mod-terraform-aws-ec2-instance

Terraform module to create AWS EC2 instance

## Variables

- **profile** - The profile from ~/.aws/credentials file used for authentication. By default it is the default profile.
- **accountID** - ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role.
- **region** - The region for the resources. By default it is eu-west-1.
- **assumeRole** - Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration.
- **assumableRole** - The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole.
- **name** - Instance name. Required value
- **ami** - AWS image AMI. Required value.
- **type** - AWS instance type. Default value t3.micro.
- **key** - Name of a ssh key. Required value.
- **subnet** - ID of the subnet this instance should be in. Required value
- **private_ip** - Private IP address of the instance. Must be within the subnet specified above. If not specified, random available IP from the subnet will be assigned.
- **public_ip** - If set to true, public IP address will be assigned to this instance. Defaults to false.
- **security_groups** - List of security group IDs to assign to this instance. Required value
- **iam_role** - Name of the IAM role assigned to this instance if instance needs access to logs, ecs or anything else within AWS. Defaults to null.
- **ebs_optimized** - If true, the launched EC2 instance will be EBS-optimized. Note that if this is not set on an instance type that is optimized by default then this will show as disabled but if the instance type is optimized by default then there is no need to set this
- **volume_type** - Root volume type. Allowed values are standard, gp2, gp3, io1, io2, sc1 or st1. Defaults to gp3.
- **volume_size** - Root volume size. Defaults to 30GB
- **volume_encrypt** - Enable/Disable root volume encryption. By default, disk is encrypted
- **kms_key_id** - In case you want to encrypt the root volume with your own key, please provide the kms_key_id.
- **volume_delete** - Enable / Disable root volume deletion on termination. Defaults to true.
- **iops** - Root volume IOPS. The amount of IOPS to provision for the disk. This value is available only for type io1, io2 and gp3
- **throughput** - Root volume throughput. The throughput that the volume supports. This value is available only for type gp3. In MiB/s
- **ebs_block_devices** - List of EBSes attached to this instance. Value should be [{device_name = 'xvdf', volume_size = 5, volume_type = 'gp3', iops = 300, througput = 125, encrypted = true, kms_key_id = 'own_kms_id', delete_on_termination = false}]. The only required value in the object is the device_name.
- **network_interfaces** - List of ENIs attached to this instance. Value should be [{id = eni_id, index = 0, delete = false}]. The only required value in the object is the id.
- **credits** - To enable burstable performance configuration, set this value to unlimited. It defaults to standard.
- **metadata_http_endpoint** - Whether the metadata service is available. Defaults to enabled.
- **metadata_http_tokens** - Whether or not the metadata service requires session tokens. Defaults to required.
- **metadata_http_put_response_hop_limit** - Desired HTTP PUT response hop limit for instance metadata requests. Values from 1 to 64. Defaults to 1.
- **user_data_replace_on_change** - Reinstall instance on user data change. Defaults to false
- **script_path** - Path to user data scripts. Defaults to ./scripts. Looking for files named ./scripts/instance_name.sh

## Example


``` terraform
variable accountID { default = "123456789012"}

module "ec2_instance" {
  source   = "git::https://github.com/virsas/mod-terraform-aws-ec2-instance.git?ref=v1.0.0"

  profile = "default"
  accountID = var.accountID
  region = "eu-west-1"

  name            = "example"
  ami             = "ami-082af980f9f5514f8"
  key             = module.ec2_sshkey_example.name

  subnet          = module.vpc_subnet_server_a.id
  security_groups = [module.vpc_sg_admin.id, module.vpc_sg_server.id]
  iam_role        = module.iam_role_ec2_server.name
}
```

## Outputs

- arn
- instance_state
- primary_network_interface_id
- private_dns
- public_dns
- public_ip