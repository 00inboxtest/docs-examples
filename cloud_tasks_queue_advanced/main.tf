resource "google_cloud_tasks_queue" "advanced_configuration" {
  name = "instance-name-${local.name_suffix}"
  location = "us-central1"

  app_engine_routing_override {
    service = "worker"
    version = "1.0"
    instance = "test"
  }

  rate_limits {
    max_concurrent_dispatches = 3
    max_dispatches_per_second = 2
  }

  retry_config {
    max_attempts = 5
    max_retry_duration = "4s"
    max_backoff = "3s"
    min_backoff = "2s"
    max_doublings = 1
  }

  stackdriver_logging_config {
    sampling_ratio = 0.9
  }
}
