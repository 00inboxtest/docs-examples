# Create a new service account
resource "google_service_account" "service_account" {
  account_id = "my-svc-acc-${local.name_suffix}"
}

#Create the HMAC key for the associated service account 
resource "google_storage_hmac_key" "key" {
  service_account_email = google_service_account.service_account.email
}
