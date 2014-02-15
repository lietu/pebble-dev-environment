#
# Variables
#

# Extract some variables for shorter names
download_url = node[:pebble_sdk][:download_url]
grp = node[:pebble_sdk][:group]
un = node[:pebble_sdk][:user]
user_home = node[:pebble_sdk][:user_home]
version = node[:pebble_sdk][:version]

# Make sure all our other variables are defined right
sdk_local_path = "#{user_home}/PebbleSDK-#{version}.tar.gz"
toolkit_local_path = "#{user_home}/#{node[:pebble_sdk][:toolchain_filename]}"
if download_url == nil
    download_url = "http://assets.getpebble.com.s3-website-us-east-1.amazonaws.com/sdk2/PebbleSDK-#{version}.tar.gz"
end


#
# Pre-requisites
#

# Ensure the Pebble SDK user and group exists
group grp
user un do
    gid     grp
    home    user_home
    shell   "/bin/bash"
end

# Directory where the SDK will be installed
directory "#{user_home}/pebble-dev" do
    user    un
    group   un
    mode    00755
end

# Link the shared folder
link "#{user_home}/src" do
    to "/mnt"
end

# Make sure APT is up-to-date and points to a mirror list
bash "apt_setup" do
    user    "root"
    not_if  "grep mirrors.ubuntu.com /etc/apt/sources.list"

    code <<-EOF
    sed -Ei 's@http://(.*)\.ubuntu\.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@g' /etc/apt/sources.list
    apt-get update
    EOF
end

#
# Pebble SDK
#

# Download the SDK, if we don't have it yet
remote_file sdk_local_path do
    user        un
    group       un
    source      download_url
    mode        00644
    not_if      "test -f #{sdk_local_path}"
end

# Extract the SDK from a downloaded tarball
bash "extract_sdk" do
    user    un
    cwd     "#{user_home}/pebble-dev"
    not_if  "test -d #{user_home}/pebble-dev/PebbleSDK-#{version}"

    code <<-EOF
    tar -zxf "#{sdk_local_path}"
    EOF
end

# Configures the user PATH for working with the SDK
bash "configure_path" do
    user    un
    cwd     "#{user_home}/pebble-dev"
    not_if  "grep PebbleSDK #{user_home}/.profile"

    code <<-EOF
    echo 'export PATH="$HOME/pebble-dev/PebbleSDK-#{version}/bin:$PATH"' >> #{user_home}/.profile
    EOF
end


#
# Pebble ARM toolchain
#

# Download the toolchain, if we don't have it yet
remote_file toolkit_local_path do
    user        un
    group       un
    source      node[:pebble_sdk][:toolchain_url]
    mode        00644
    not_if      "test -f #{toolkit_local_path}"
end

# Extract the toolchain from a downloaded tarball
bash "extract_toolchain" do
    user    un
    cwd     "#{user_home}/pebble-dev/PebbleSDK-#{version}"
    not_if  "test -d #{user_home}/pebble-dev/PebbleSDK-#{version}/arm-cs-tools"

    code <<-EOF
    tar -zxf "#{toolkit_local_path}"
    EOF
end


#
# Python libraries
#

# Install the packages we need
["python-pip", "python2.7-dev"].each do |pkg|
    package pkg
end

# And set up the SDK requirements
bash "setup_python_libraries" do
    user    un
    cwd     "#{user_home}/pebble-dev/PebbleSDK-2.0.0/"

    # Stupid chef running things with sudo or something that doesn't update
    # environment quite right
    environment "HOME" => user_home

    code <<-EOF
    pip install --user -r requirements.txt
    EOF
end
