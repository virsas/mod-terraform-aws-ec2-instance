# Account setup
variable "profile" {
  description           = "The profile from ~/.aws/credentials file used for authentication. By default it is the default profile."
  type                  = string
  default               = "default"
}

variable "accountID" {
  description           = "ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role."
  type                  = string

  validation {
    condition           = length(var.accountID) == 12
    error_message       = "Please, provide a valid account ID."
  }
}

variable "region" {
  description           = "The region for the resources. By default it is eu-west-1."
  type                  = string
  default               = "eu-west-1"
}

variable "assumeRole" {
  description           = "Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration."
  type                  = bool
  default               = false
}

variable "assumableRole" {
  description           = "The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole."
  type                  = string
  default               = "OrganizationAccountAccessRole"
}

variable "name" {
  description = "Instance name. Required value."
  type        = string
}
variable "ami" {
  description = "AWS image AMI. Required value."
  type        = string
}
variable "type" {
  description = "AWS instance type. Default value t3.micro."
  type        = string
  default     = "t3.micro"
}
variable "key" {
  description = "Name of a ssh key. Required value."
  type        = string
}
variable "subnet" {
  description = "ID of the subnet this instance should be in. Required value"
  type        = string
}
variable "private_ip" {
  description = "Private IP address of the instance. Must be within the subnet specified above. If not specified, random available IP from the subnet will be assigned."
  type        = string
  default     = null
}
variable "public_ip" {
  description = "If set to true, public IP address will be assigned to this instance. Defaults to false."
  type        = bool
  default     = false
}
variable "security_groups" {
  description = "List of security group IDs to assign to this instance. Required value"
  type        = list(string)
}
variable "iam_role" {
  description = "Name of the IAM role assigned to this instance if instance needs access to logs, ecs or anything else within AWS. Defaults to null."
  type        = string
  default     = null
}
variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized. Note that if this is not set on an instance type that is optimized by default then this will show as disabled but if the instance type is optimized by default then there is no need to set this"
  type        = bool
  default     = null
}
variable "volume_type" {
  description = "Root volume type. Allowed values are standard, gp2, gp3, io1, io2, sc1 or st1. Defaults to gp3."
  type        = string
  default     = "gp3"

  validation {
    condition           = contains(["standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"], var.volume_type)
    error_message       = "Expected values: standard, gp2, gp3, io1, io2, sc1, st1."
  }
}
variable "volume_size" {
  description = "Root volume size. Defaults to 30GB"
  type        = number
  default     = 30
}
variable "volume_encrypt" {
  description = "Enable/Disable root volume encryption. By default, disk is encrypted"
  type        = bool
  default     = true
}
variable "kms_key_id" {
  description = "In case you want to encrypt the root volume with your own key, please provide the kms_key_id."
  type        = string
  default     = null
}
variable "volume_delete" {
  description = "Enable / Disable root volume deletion on termination. Defaults to true."
  type        = bool
  default     = true
}
variable "iops" {
  description = "Root volume IOPS. The amount of IOPS to provision for the disk. This value is available only for type io1, io2 and gp3"
  type        = number
  default     = null
}
variable "throughput" {
  description = "Root volume throughput. The throughput that the volume supports. This value is available only for type gp3. In MiB/s"
  type        = number
  default     = null
}
variable "ebs_block_devices" {
  description = "List of EBSes attached to this instance. Value should be [{device_name = 'xvdf', volume_size = 5, volume_type = 'gp3', iops = 300, througput = 125, encrypted = true, kms_key_id = 'own_kms_id', delete_on_termination = false}]. The only required value in the object is the device_name."
  type        = list(any)
  default     = []
}
variable "network_interfaces" {
  description = "List of ENIs attached to this instance. Value should be [{id = eni_id, index = 0, delete = false}]. The only required value in the object is the id."
  type        = list(any)
  default     = []
}
variable "credits" {
  description = "To enable burstable performance configuration, set this value to unlimited. It defaults to standard."
  type        = string
  default     = "standard"

  validation {
    condition           = contains(["standard", "unlimited"], var.credits)
    error_message       = "Expected values: standard or unlimited."
  }
}
variable "metadata_http_endpoint" {
  description = "Whether the metadata service is available. Defaults to enabled."
  type        = string
  default     = "enabled"

  validation {
    condition           = contains(["enabled", "disabled"], var.metadata_http_endpoint)
    error_message       = "Expected values: enabled or disabled."
  }
}
variable "metadata_http_tokens" {
  description = "Whether or not the metadata service requires session tokens. Defaults to required."
  type        = string
  default     = "required"

  validation {
    condition           = contains(["required", "optional"], var.metadata_http_tokens)
    error_message       = "Expected values: required or optional."
  }
}
variable "metadata_http_put_response_hop_limit" {
  description = "Desired HTTP PUT response hop limit for instance metadata requests. Values from 1 to 64. Defaults to 1."
  type        = number
  default     = 1
}
variable "user_data_replace_on_change" {
  description = "Reinstall instance on user data change. Defaults to false"
  type        = string
  default     = false
}
variable "script_path" {
  description = "Path to user data scripts. Defaults to ./scripts. Looking for files named ./scripts/instance_name.sh"
  type        = string
  default     = "./scripts"
}