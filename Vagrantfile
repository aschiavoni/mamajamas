# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  # config.vm.network "public_network"
  config.vm.network "private_network", type: "dhcp"
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 4
    # v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "nodejs"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::user"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "postgresql::server_dev"
    chef.add_recipe "postgresql::client"
    chef.add_recipe "redis::server"
    chef.add_recipe "redis::client"
    chef.add_recipe "imagemagick"
    chef.add_recipe "dotfiles"

    chef.json = {
      rbenv: {
        user_installs: [{
                          user: "vagrant",
                          rubies: [ "2.1.2" ],
                          global: "2.1.2",
                          gems: {
                            "2.1.2" => [ { name: "bundler" } ]
                            # "1.9.3-p327" => [ { name: "bundler" } ]
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
                  login: true
                }
               ],
        databases: [
                    {
                      name: "mamajamas_development",
                      owner: "mamajamas",
                      extensions: [ "hstore", "unaccent" ]
                    }
                   ]
      },
      dotfiles: { user: "vagrant", group: "vagrant" }
    }
  end

  config.vm.provision "shell", run: "always", privileged: false do |s|
    s.inline = "cd /vagrant && bundle && bundle exec rake db:migrate"
  end
end
