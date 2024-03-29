packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}

variable "disk_size" {
  type    = string
  default = ""
}

variable "iso_checksum" {
  type    = string
  default = ""
}

variable "iso_checksum_type" {
  type    = string
  default = ""
}

variable "iso_url" {
  type    = string
  default = ""
}

variable "output_directory" {
  type    = string
  default = ""
}

variable "secondary_iso_image" {
  type    = string
  default = ""
}

variable "switch_name" {
  type    = string
  default = ""
}

variable "sysprep_unattended" {
  type    = string
  default = ""
}

variable "upgrade_timeout" {
  type    = string
  default = ""
}

variable "vlan_id" {
  type    = string
  default = ""
}

variable "vm_name" {
  type    = string
  default = ""
}

variable "temp_path" {
  type    = string
  default = ""
}

source "hyperv-iso" "vm" {
  boot_command          = ["a<enter><wait>a<enter><wait>a<enter><wait>a<enter>"]
  boot_wait             = "1s"
  communicator          = "winrm"
  cpus                  = 2
  disk_size             = "${var.disk_size}"
  enable_dynamic_memory = "true"
  enable_secure_boot    = false
  generation            = 2
  guest_additions_mode  = "disable"
  iso_checksum          = "${var.iso_checksum_type}:${var.iso_checksum}"
  iso_url               = "${var.iso_url}"
  memory                = 4096
  output_directory      = "${var.output_directory}${var.vm_name}"
  secondary_iso_images  = ["${var.secondary_iso_image}"]
  shutdown_timeout      = "30m"
  keep_registered       = false
  skip_export           = false
  shutdown_command      = true
  switch_name           = "${var.switch_name}"
  temp_path             = "${var.temp_path}"
  vlan_id               = "${var.vlan_id}"
  vm_name               = "${var.vm_name}"
  winrm_password        = "packer"
  winrm_timeout         = "8h"
  winrm_username        = "Administrator"
}

build {
  sources = ["source.hyperv-iso.vm"]

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    script            = "./scripts/postsetup.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "1h"
  }

  provisioner "windows-restart" {
    pause_before          = "1m0s"
    restart_check_command = "powershell -command \"& {Write-Output 'restarted.'}\""
    restart_timeout       = "2h"
  }

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    inline            = ["Write-Host \"Pausing before next stage\";Start-Sleep -Seconds ${var.upgrade_timeout}"]
  }

  provisioner "powershell" {
    elevated_password = "packer"
    elevated_user     = "Administrator"
    script            = "./setup/windows-compress.ps1"
  }

  provisioner "file" {
    destination = "C:\\Windows\\System32\\Sysprep\\unattend.xml"
    source      = "${var.sysprep_unattended}"
  }

}
