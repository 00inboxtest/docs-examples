resource "google_storage_bucket" "dest" {
  name          = "my-bucket-${local.name_suffix}"
  location      = "US"
  force_destroy = true
}

resource "google_network_services_edge_cache_origin" "instance" {
  name                 = "my-origin-${local.name_suffix}"
  origin_address       = google_storage_bucket.dest.url
  description          = "The default bucket for media edge test"
  max_attempts         = 2
  timeout {
    connect_timeout = "10s"
  }
}

resource "google_network_services_edge_cache_service" "instance" {
  name                 = "my-service-${local.name_suffix}"
  description          = "some description"
  routing {
    host_rule {
      description = "host rule description"
      hosts = ["sslcert.tf-test.club"]
      path_matcher = "routes"
    }
    path_matcher {
      name = "routes"
      route_rule {
        description = "a route rule to match against"
        priority = 1
        match_rule {
          prefix_match = "/"
        }
        origin = google_network_services_edge_cache_origin.instance.name
        route_action {
          cdn_policy {
              cache_mode = "CACHE_ALL_STATIC"
              default_ttl = "3600s"
          }
        }
        header_action {
          response_header_to_add {
            header_name = "x-cache-status"
            header_value = "{cdn_cache_status}"
          }
        }
      }
    }
  }
}
