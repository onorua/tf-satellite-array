# tf-satellite
Main satellite module for terraform

It stores states and lock in `tf_remote_state` bucket, in `us-east-1` region, unless pecified. It expects key (the path) to be specified during importing as a variable. 
