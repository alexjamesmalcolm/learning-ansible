Vagrant.configure("2") do |config|
  config.vm.guest = :redhat
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"
  config.ssh.insert_key = false
  config.ssh.port = 2222

  config.vm.provider "docker" do |d|
    d.build_dir = "."              # folder with Dockerfile.rocky (rename to Dockerfile or set build args)
    d.name = "testserver"
    d.has_ssh = true
    d.ports = ["2222:22", "7080:80"]

    # Let systemd be PID 1 and manage cgroups
    d.create_args = [
      "--privileged",
      "--cgroupns=host",
      "-v", "/sys/fs/cgroup:/sys/fs/cgroup:rw",
      "--tmpfs", "/run",
      "--tmpfs", "/run/lock"
    ]
  end
end
