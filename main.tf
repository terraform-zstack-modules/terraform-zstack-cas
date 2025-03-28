locals {
  context = var.context
}

# main.tf


module "cas_image" {
  source = "git::https://github.com/terraform-zstack-modules/terraform-zstack-image.git"

  create_image        = false
  image_name          = var.image_name
 # image_url           = var.image_url
 # guest_os_type      = "Centos 7"
 # platform           = "Linux"
 # format             = "qcow2"
 # architecture       = "x86_64"

 # backup_storage_name = var.backup_storage_name
}

# 创建虚拟机实例
module "cas_instance" {
  source = "git::https://github.com/chijiajian/terraform-zstack-instance.git"

  name                  = var.instance_name
  description           = "CAS Server Created by Terraform"
  instance_count        = 1
  image_uuid            = module.cas_image.image_uuid
  l3_network_name       = var.l3_network_name
  instance_offering_name = var.instance_offering_name
 # user_data = local.user_data_base64
}


resource "terraform_data" "remote_exec" {
  # 确保在虚拟机创建完成后执行
  depends_on = [module.cas_instance]
  
  # SSH连接配置
  connection {
    type     = "ssh"
    user     = var.ssh_user
    password = var.ssh_password
    host     = module.cas_instance.instance_ips[0]
    timeout  = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /opt/cas/" , # 执行远程脚本
      "docker compose up -d"
    ]
    on_failure = fail
  }

}



