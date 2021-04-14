[win]
${hostname}

[win:vars]
ansible_connection=winrm
ansible_ssh_pass=${password}
ansible_ssh_port=5985
ansible_ssh_user=${username}
ansible_winrm_server_cert_validation=ignore
ansible_winrm_transport=ntlm
