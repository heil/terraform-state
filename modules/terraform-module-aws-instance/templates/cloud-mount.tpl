#cloud-config
mounts:
  - [ ${mount_device != "" ? mount_device : device}1, "${mount_point}" ]

fs_setup:
  - device: ${mount_device != "" ? mount_device : device}
    partition: 1
    label: ${label}
    filesystem: ${filesystem}

mounts:
  - [ /dev/xvdh1, "/srv" ]

fs_setup:
  - device: /dev/xvdh
    partition: 1
    label: centos_02
    filesystem: ext4
