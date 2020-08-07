variable "DockerImage" {
    type = string
    default = "sjortiz/api"
    description = "Docker Image name"
}

variable "Port" {
    type = string
    default = 5000
    description = "Listener port."
}
