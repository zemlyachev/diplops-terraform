variable "YC_TOKEN" { type = string }
variable "YC_FOLDER_ID" { type = string }
variable "YC_CLOUD_ID" { type = string }
variable "YC_ZONE" { type = string }

# Подсети <подсеть> = <cidr>
variable "subnets" {
  type    = map(string)
  default = ({
    a = "192.168.10.0/24",
    b = "192.168.20.0/24",
    d = "192.168.30.0/24"
  })
}

## Воркеры <ключ подсети> = <количество виртуалок>
variable "workers" {
  type    = map(number)
  default = ({
    a = 1,
    b = 1,
    d = 1
  })
}

variable "ubuntu_image_id" {
  type        = string
  default     = "fd88bokmvjups3o0uqes"
  description = "ubuntu-22-04-lts-v20240603"
}
