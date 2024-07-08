
locals {
  common_tags = {
    Assignment    = "CCGC 5502 Automation Assignment"
    Name          = "yongchae.ko"
    ExpirationDate= "2024-12-31"
    Environment   = "Learning"
  }
}

module "rgroup-n01649144" {
  source  = "./modules/rgroup-n01649144"
  common_tags = local.common_tags
}

module "network-n01649144" {
  source = "./modules/network-n01649144"
  common_tags = local.common_tags
  depends_on = [module.rgroup-n01649144]

}

module "common-n01649144" {
  source = "./modules/common-n01649144"
  common_tags = local.common_tags
  depends_on = [module.rgroup-n01649144]
}

module "vmlinux-n01649144" {
  source              = "./modules/vmlinux-n01649144"
  subnet_id           = module.network-n01649144.subnet_id
  storage_account_uri = module.common-n01649144.storage_account_uri
  common_tags = local.common_tags
  depends_on          = [module.rgroup-n01649144, module.network-n01649144, module.common-n01649144]
}

module "vmwindows-n01649144" {
  source              = "./modules/vmwindows-n01649144"
  subnet_id           = module.network-n01649144.subnet_id
  storage_account_uri = module.common-n01649144.storage_account_uri
  common_tags = local.common_tags
  depends_on          = [module.rgroup-n01649144, module.network-n01649144, module.common-n01649144]
}

module "datadisk-n01649144" {
  source              = "./modules/datadisk-n01649144"
  linux_vm_ids        = module.vmlinux-n01649144.vm_ids
  windows_vm_id       = module.vmwindows-n01649144.vm_id
  common_tags = local.common_tags
  depends_on          = [module.rgroup-n01649144, module.network-n01649144, module.common-n01649144]
}

module "loadbalancer-n01649144" {
  source               = "./modules/loadbalancer-n01649144"
  linux_vm_nic_ids     = [for nic in module.vmlinux-n01649144.vm_nic_ids : nic]
  common_tags = local.common_tags
  depends_on          = [module.rgroup-n01649144, module.network-n01649144, module.common-n01649144]
}

module "database-n01649144" {
  source              = "./modules/database-n01649144"
  common_tags = local.common_tags
}
