#cloud-config
cloud_final_modules:
- [users-groups,always]

hostname: "${hostname}"

fqdn: "${hostname}.${domain_name}"

manage_etc_hosts: true

package_update: true

packages:
  - curl
  - wget
  - ansible

users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1dx/uNT1BEtdzw3xynpqpb5ZkdZnWGJimpjA60RLe4DjKpPUG0gSknAUo4wna+EqgyRPY5OB7d1tWJPjy7WDNX5je0RaCtjptRjJw4FsaNs1Qh7b18Ym9Av9AxYjW4ZbGSE6HOuB9dfNZXE+h8D3bMdr3UChlstf6W0W4ophptdyXlAzA7oeEiyjlKOqkarKGNR58hYSCVWlZGLdo15gw/gGoHcywuuKejTxg53qAhxKQ9/tAptIq/aPPiuCbeVcjaMtwGaXRZvQnwMXAaKmz8tXuXODOKcVYFn5F1YPfec54NudqlN2ZdFRi1Ly/yMZtc2YVB4lpTqEzxqD1Cdyf tt-veikko

  - name: administrator
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1dx/uNT1BEtdzw3xynpqpb5ZkdZnWGJimpjA60RLe4DjKpPUG0gSknAUo4wna+EqgyRPY5OB7d1tWJPjy7WDNX5je0RaCtjptRjJw4FsaNs1Qh7b18Ym9Av9AxYjW4ZbGSE6HOuB9dfNZXE+h8D3bMdr3UChlstf6W0W4ophptdyXlAzA7oeEiyjlKOqkarKGNR58hYSCVWlZGLdo15gw/gGoHcywuuKejTxg53qAhxKQ9/tAptIq/aPPiuCbeVcjaMtwGaXRZvQnwMXAaKmz8tXuXODOKcVYFn5F1YPfec54NudqlN2ZdFRi1Ly/yMZtc2YVB4lpTqEzxqD1Cdyf tt-veikko
