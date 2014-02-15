# What user and group to install the SDK under
default[:pebble_sdk][:user] = "vagrant"
default[:pebble_sdk][:group] = "vagrant"
default[:pebble_sdk][:user_home] = "/home/vagrant"

# Which version do we want?
default[:pebble_sdk][:version] = "2.0.0"

# Where to download it from? nil = automatic
default[:pebble_sdk][:download_url] = nil

# Where to download the Pebble ARM toolchain from
default[:pebble_sdk][:toolchain_url] = "http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk/arm-cs-tools-ubuntu-universal.tar.gz"
default[:pebble_sdk][:toolchain_filename] = "arm-cs-tools-ubuntu-universal.tar.gz"
