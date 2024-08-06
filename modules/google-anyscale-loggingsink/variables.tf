# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "module_enabled" {
  description = <<-EOF
    (Optional) Determines whether to create the resources inside this module.

    ex:
    ```
    module_enabled = true
    ```
  EOF
  type        = bool
  default     = true
}

variable "anyscale_project_id" {
  description = <<-EOF
    (Optional) The ID of the project to create the resource in.

    If not provided, the provider project is used.

    ex:
    ```
    anyscale_project_id = "my-project"
    ```
  EOF
  type        = string
  default     = null
}


variable "sink_destination" {
  description = <<-EOF
    (Optional) The destination for the sink.

    ex:
    ```
    sink_destination = "pubsub.googleapis.com/projects/my-project/topics/my-topic"
    ```
  EOF
  type        = string
  default     = null
}

variable "sink_exclusion_filter" {
  description = <<-EOF
    (Optional) The filter for the sink.

    ex:
    ```
    sink_filter = "resource.type=gce_instance AND logName=projects/example/logs/syslog"
    ```
  EOF
  type        = string
  default     = null
}
