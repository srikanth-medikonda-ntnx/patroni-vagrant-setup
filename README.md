# patroni-vagrant-setup
- [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) and install
- [Download Vagrant](https://www.vagrantup.com/downloads.html) and install
- Install `vagrant-reload` plugin
  - ```$ vagrant plugin install vagrant-reload```
- Clone this repo
  - ```$ git clone https://github.com/srikanth-medikonda-ntnx/patroni-vagrant-setup```
- Change the working directory to cloned repo
  - ```$ cd patroni-vagrant-setup```
- Download & boostrap the vagrant image
  - ```$ vagrant up```
- See the list of vagrant environments
  - ```$ vagrant global-status```
  - Sample output:
  ```
  id       name     provider   state   directory
  ------------------------------------------------------------------------------------
  20f7b3a  default  virtualbox running /Users/srikanth.medikonda/patroni-vagrant-setup

  The above shows information about all known Vagrant environments
  on this machine. This data is cached and may not be completely
  up-to-date. To interact with any of the machines, you can go to
  that directory and run Vagrant, or you can use the ID directly
  with Vagrant commands from any directory. For example:
  "vagrant destroy 20f7b3a"
  ```
- Remotely connect to vagrant environment
  - ```$ vagrant ssh 20f7b3a```
- Download latest **Patroni Tutorial** here: https://github.com/patroni-training/2019/raw/master/slides.pdf
