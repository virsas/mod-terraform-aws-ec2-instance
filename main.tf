provider "aws" {
  profile = var.profile
  region = var.region

  assume_role {
    role_arn = var.assumeRole ? "arn:aws:iam::${var.accountID}:role/${var.assumableRole}" : null
  }
}

locals {
  t_instance = startswith(var.type, "t")
}

resource "aws_instance" "vss" {
	ami                           = var.ami

	instance_type                 = var.type
	key_name                      = var.key

  subnet_id                     = var.subnet
  private_ip                    = var.private_ip
  associate_public_ip_address   = var.public_ip
  vpc_security_group_ids        = var.security_groups

  iam_instance_profile          = var.iam_role

  ebs_optimized                 = var.ebs_optimized

  root_block_device {
    volume_type                 = var.volume_type
    volume_size                 = var.volume_size
    encrypted                   = var.volume_encrypt
    kms_key_id                  = var.kms_key_id
    delete_on_termination       = var.volume_delete
    iops                        = var.volume_type == "io1" || var.volume_type == "io2" || var.volume_type == "gp3" ? var.iops : null
    throughput                  = var.volume_type == "gp3" ? var.throughput : null
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices

    content {
      device_name               = ebs_block_device.value.device_name

      volume_size               = try(ebs_block_device.value.volume_size, 5)

      volume_type               = try(ebs_block_device.value.volume_type, "gp3")
      iops                      = try(ebs_block_device.value.iops, null)
      throughput                = try(ebs_block_device.value.throughput, null)

      encrypted                 = try(ebs_block_device.value.encrypted, true)
      kms_key_id                = try(ebs_block_device.value.kms_key_id, null)

      delete_on_termination     = try(ebs_block_device.value.delete_on_termination, false)
    }
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces

    content {
      network_interface_id      = network_interface.value.id
      device_index              = try(network_interface.value.index, 0)
      delete_on_termination     = try(network_interface.value.delete, false)
    }
  }

  credit_specification {
    cpu_credits = local.t_instance ? var.credits : null
  }

  metadata_options {
    http_endpoint               = var.metadata_http_endpoint
    http_tokens                 = var.metadata_http_tokens
    http_put_response_hop_limit = var.metadata_http_put_response_hop_limit
  }

  user_data_replace_on_change = var.user_data_replace_on_change
  user_data = templatefile("${var.script_path}/${var.name}.sh", {
    region = "${var.region}",
    name = "${var.name}"
  })

  tags = {
		Name = var.name
	}
}