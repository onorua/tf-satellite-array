terraform {
    backend "s3" {
        bucket = "tf_remote_state"
        region = "us-east-1"
    }
}
