# Pebble SDK environment

This is a toolbox for setting up a virtual machine running Ubuntu Linux with the Pebble SDK installed for Pebble development.

The toolbox uses Vagrant and Chef to configure the environment, ensuring that it is for example easy to update to new versions.

It also sets up


## Prerequisites

You will need to have vagrant and VirtualBox installed. It shouldn't be too difficult to convert the Vagrantfile to work with VMWare Workstation, but Vagrant doesn't work with e.g. VMWare Player.

 * Vagrant: [http://www.vagrantup.com/](http://www.vagrantup.com/)
 * VirtualBox: [https://www.virtualbox.org/](https://www.virtualbox.org/)

For Windows users an SSH client is needed, I recommend KiTTY:
 * KiTTY: [http://www.9bis.net/kitty/](http://www.9bis.net/kitty/)

You will also need to checkout or download this repository on your computer.

If you're having issues getting the virtual machine running or it's unstable, it might be worth checking that hardware virtualization support is enabled in your system BIOS. Almost all machines nowadays have the support, but on some machines it is disabled by default.


## Setting up

After you have installed the prerequisites, it is fairly easy to get the environment up and running.

Open up a terminal or command prompt and run:
```
cd /path/to/this/checkout
vagrant up
```

This process will take a while, as it has to download ~300MB virtual machine base image off the net, but it does this only for the first time you run it. It also has to download the Pebble SDK (10MB) and ARM toolkit (140MB)


## Working with the environment

### Connecting to the virtual machine

In Mac OS X, Linux, etc. it should be enough to just run:
```
cd /path/to/this/checkout
vagrant ssh
```

In Windows, unless you have SSH available in your PATH, you will likely want to use KiTTY or similar to connect to your virtual machine. Normally you can connect to "localhost" port "2222", but you can check the settings with:
```
cd /path/to/this/checkout
vagrant ssh-config
```

The username and password are both: vagrant

SCP access also works just like expected.


Now everything you'd expect from a Pebble development environment should work, if you need help with starting development on your pebble, check out the Pebble tutorials:

 * [https://developer.getpebble.com/2/getting-started/hello-world/](https://developer.getpebble.com/2/getting-started/hello-world/)
 * [https://developer.getpebble.com/2/getting-started/using-examples/](https://developer.getpebble.com/2/getting-started/using-examples/)

Paths relative to the vagrant user's home directory (/home/vagrant/):
 * Pebble SDK: pebble-dev/Pebble-SDK-x.x.x (where x.x.x is the version)
 * Source: src/ (This is shared with the checkout src/ -folder on your machine)

It is recommended that you put your projects inside the src/ folder so you get easy access to them from outside the VM environment. Otherwise you will have to move them around with SCP or similar.

E.g. before running "pebble new-project hello_world" just run "cd src".

Basically what you do is:
 1. Run: pebble new-project src/my-project-name
 1. Run: cd src/my-project-name
 1. Edit your code with your favorite text editor in the src/my-project-name folder in your computer
 1. Run: pebble build && pebble install --phone 1.2.3.4
    * Replace 1.2.3.4 with your phone's IP, enable developer connection in your pebble app and it is visible on the main screen
    * Make sure the phone is connected to your WiFi and that you can access that network from your own computer
 1. Run: pebble log --phone 1.2.3.4
    * This shows you the logs from your application, if you need to read them
 1. Rinse and repeat until all done.


### Cleaning up

If you want to turn off the virtual machine to save some system resources, run:
```
cd /path/to/this/checkout
vagrant halt
```

If you want to delete the virtual machine to also free up the disk space, run:
```
cd /path/to/this/checkout
vagrant destroy
```

The next time you want to continue working, just run:
```
cd /path/to/this/checkout
vagrant up
```

.. if halted, it will just boot up the environment and make sure all settings are still fine, if deleted it will restart installation from scratch.

None of these will delete your code in the src/ folder, which is stored outside the virtual machine.


## Troubleshooting

If the recipe doesn't work, it's most likely because the download URLs have changed.

Go check out the download link for the SDK at https://developer.getpebble.com/2/getting-started/ .. check the version number for the .tar.gz file offered with the download button. Make sure the version in cookbooks/pebble-sdk/attributes/default.rb matches.

Also make sure the Pebble ARM toolkit URL on the same page matches the one in the toolchain_url in the same attributes file.

After you have fixed stuff, tell Vagrant to retry configuring the system.

```
vagrant provision
```


## Licensing

All this stuff is licensed under the Apache License 2.0.
