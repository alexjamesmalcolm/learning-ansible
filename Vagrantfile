Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # common SSH settings (you can also put these per-machine if you prefer)
  common_ssh_user     = "vagrant"
  common_ssh_password = "vagrant"

  %w[vagrant1 vagrant2 vagrant3].each_with_index do |name, i|
    config.vm.define name do |machine|
      machine.vm.guest = :redhat

      # IMPORTANT: host ports must be unique per container
      base_ssh   = 2222 + i + 10
      base_http  = 7080 + i
      base_https = 7443 + i

      machine.ssh.username   = common_ssh_user
      machine.ssh.password   = common_ssh_password
      machine.ssh.insert_key = false
      # let Vagrant pick host ports, or offset manually:
      machine.ssh.port = base_ssh

      machine.vm.provider "docker" do |d|
        d.build_dir = "."
        d.name      = name
        d.has_ssh   = true



        d.ports = [
          "#{base_ssh}:22",
          "#{base_http}:80",
          "#{base_https}:443"
        ]

        d.create_args = [
          "--privileged",
          "--cgroupns=host",
          "-v", "/sys/fs/cgroup:/sys/fs/cgroup:rw",
          "--tmpfs", "/run",
          "--tmpfs", "/run/lock"
        ]
      end
    end
  end
end
