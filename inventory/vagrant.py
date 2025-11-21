#!/usr/bin/env python3
"""
Adapted from Mark Mandel's implementation
https://github.com/markmandel/vagrant_ansible_example
"""
from typing import Dict
import argparse
import io
import json
import subprocess
import sys

import paramiko


def parse_args():
    """command-line options"""
    parser = argparse.ArgumentParser(description="Vagrant inventory script")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--list", action="store_true")
    group.add_argument("--host")
    return parser.parse_args()


def list_running_hosts() -> Dict[str, Dict[str, str]]:
    """vagrant.py --list function"""
    cmd = ["vagrant", "ssh-config"]
    ssh_configs = subprocess.check_output(cmd).decode()
    config = paramiko.SSHConfig()
    config.parse(io.StringIO(ssh_configs))
    results: Dict[str, Dict[str, str]] = {}
    for host in config.get_hostnames():
        if host != "*":
            host_config = config.lookup(host)
            results[host] = process_host_config(host_config)

    return results


def process_host_config(host_config: paramiko.SSHConfigDict) -> Dict[str, str]:
    result = {
        "ansible_host": host_config["hostname"],
        "ansible_port": host_config["port"],
        "ansible_user": host_config["user"],
        "ansible_password": "vagrant",
    }
    if "identityfile" in host_config:
        result["ansible_private_key_file"] = host_config["identityfile"][0]

    return result


def get_host_details(host: str) -> Dict[str, str]:
    """vagrant.py --host <hostname> function"""
    cmd = ["vagrant", "ssh-config", host]
    ssh_config = subprocess.check_output(cmd).decode()
    config = paramiko.SSHConfig()
    config.parse(io.StringIO(ssh_config))
    host_config = config.lookup(host)
    return process_host_config(host_config)


def main():
    """Example 4-12 of Ansible Up & Running"""
    args = parse_args()
    if args.list:
        host_details = list_running_hosts()
        json.dump(
            {
                "vagrant": {"hosts": list(host_details), "vars": {}, "children": []},
                "_meta": {"hostvars": host_details},
            },
            sys.stdout,
        )
    else:
        details = get_host_details(args.host)
        json.dump(details, sys.stdout)


if __name__ == "__main__":
    main()
