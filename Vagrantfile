Vagrant.configure("2") do |config|
  # Tell Vagrant what the guest is (avoids detection hassles)
  config.vm.guest = :alpine

  # Disable the default synced folder (requires guest tools)
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # SSH creds for our baked-in sshd
  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false
  config.ssh.port = 2222

  # Alpine's shell
  config.ssh.shell = "/bin/ash"

  config.vm.provider "docker" do |d|
    d.build_dir = "."          # uses the Dockerfile above
    d.name = "testserver"
    d.has_ssh = true           # yes, we have sshd inside
    d.ports = ["2222:22"]      # host:container
    d.remains_running = true
  end
end
