# -*- mode: ruby -*-
# vi: set ft=ruby :

APP_DIR = "/vagrant"
RUBY_VER = "2.1.3"
VAGRANT_USER = "vagrant"
VAGRANT_GROUP = "vagrant"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # config.vm.box = "ubuntu/trusty64"
  config.vm.box = "hashicorp/precise64"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", APP_DIR, type: "nfs"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 1080, host: 1080

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
    # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "2048"
    v.vmx["numvcpus"] = "4"
  end

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "phantomjs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::server_dev"
    chef.add_recipe "postgresql::client"
    chef.add_recipe "memcached"
    chef.add_recipe "redis::server"
    chef.add_recipe "redis::client"
    chef.add_recipe "imagemagick"
    chef.add_recipe "mamajamas::development"

    chef.add_recipe "dotfiles"
    chef.add_recipe "emacs"

    chef.json = {
      rbenv: {
        user_installs: [{
                          user: VAGRANT_USER,
                          rubies: [ RUBY_VER ],
                          global: RUBY_VER,
                          gems: {
                            RUBY_VER => [ { name: "bundler" } ]
                          }
                        }]
      },
      postgresql: {
        pg_hba_defaults: false,
        pg_hba: [
                 { type: "local", db: "all", user: "postgres", addr: "", method: "trust" },
                 { type: "local", db: "all", user: "all",      addr: "", method: "trust" },
                 { type: "host",  db: "all", user: "all",      addr: "127.0.0.1/32", method: "trust" },
                 { type: "host",  db: "all", user: "all",      addr: "::1/128", method: "trust" },
                 { type: "host",  db: "all", user: "postgres", addr: "127.0.0.1/32", method: "trust" },
                 { type: "host",  db: "all", user: "mamajamas", addr: "127.0.0.1/32", method: "trust" }
                ],
        users: [
                {
                  username: "mamajamas",
                  password: "",
                  createdb: true,
                  login: true,
                  superuser: true
                }
               ],
        databases: [
                    {
                      name: "mamajamas_development",
                      owner: "mamajamas",
                      extensions: [ "hstore", "unaccent" ]
                    },
                    {
                      name: "mamajamas_test",
                      owner: "mamajamas",
                      extensions: [ "hstore", "unaccent" ]
                    }
                   ]
      },
      mamajamas: {
        app_dir: APP_DIR,
        ruby_version: RUBY_VER,
        user: VAGRANT_USER,
        group: VAGRANT_GROUP
      },
      dotfiles: { user: VAGRANT_USER, group: VAGRANT_GROUP }
    }
  end
end
