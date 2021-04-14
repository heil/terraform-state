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
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0YqjPvHvgz2m+MxPS7gwWy+vAjnadYEopYiH1uGedPjNiW9c5msXBQDeui06yXQPUJWQlZG4gnFrtGI6t9cv8fckZM1ZRGnFyrfoLIcdJ42fMNP3QW0w6nWYEoAPmIqP8TOTF0Fg+diY6L9b0omOZZYZ2kz1uJ6tNvKPGQjduoHJnCvsIV/krB8GL0htNfd++mQxHCJuyeRQUHSql3xBwCz31F/H32uYfb7gQADFxC+S1jPMFo4UWn4ofbzkNn8a5256N8sS017+nrJ51wr4XsQKFTtpytQEp0iz42JUX3eD1M9iXAFnhY92dDz/YoClmIULibH2wLRg2THltYs0uy5hYP6rxXEqk9kgzfZTvhjW6ZhJKEcPTbB/Ycqk4LYWhQ84+OOStxwPZw0kOlExF14b1NgND0YlFGGOzUjeVp8MKAKvsrKLlmL+3ayjzds++g/Py5PnhwYQFHDStY7b3+UeESchnxyaTcyighR2uh18pG49IwUKoqPkRogFXyyW/w4vO1oFmHtQXOeIDs05er2vefGu98ielimwqtgpc5nHztBiSFxzyA+Q23PxH2lr6qNF2PL49FZTPKIxWRkh4sjaN0aBxfOH60qepB3bbGCAabUxRZ1p6v9Xk7HRYyhounf9w8HyHn30J6bPG84ks61Ei8Y77sMLJEUWXneG3wQ== heil@jun

  - name: administrator
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD0YqjPvHvgz2m+MxPS7gwWy+vAjnadYEopYiH1uGedPjNiW9c5msXBQDeui06yXQPUJWQlZG4gnFrtGI6t9cv8fckZM1ZRGnFyrfoLIcdJ42fMNP3QW0w6nWYEoAPmIqP8TOTF0Fg+diY6L9b0omOZZYZ2kz1uJ6tNvKPGQjduoHJnCvsIV/krB8GL0htNfd++mQxHCJuyeRQUHSql3xBwCz31F/H32uYfb7gQADFxC+S1jPMFo4UWn4ofbzkNn8a5256N8sS017+nrJ51wr4XsQKFTtpytQEp0iz42JUX3eD1M9iXAFnhY92dDz/YoClmIULibH2wLRg2THltYs0uy5hYP6rxXEqk9kgzfZTvhjW6ZhJKEcPTbB/Ycqk4LYWhQ84+OOStxwPZw0kOlExF14b1NgND0YlFGGOzUjeVp8MKAKvsrKLlmL+3ayjzds++g/Py5PnhwYQFHDStY7b3+UeESchnxyaTcyighR2uh18pG49IwUKoqPkRogFXyyW/w4vO1oFmHtQXOeIDs05er2vefGu98ielimwqtgpc5nHztBiSFxzyA+Q23PxH2lr6qNF2PL49FZTPKIxWRkh4sjaN0aBxfOH60qepB3bbGCAabUxRZ1p6v9Xk7HRYyhounf9w8HyHn30J6bPG84ks61Ei8Y77sMLJEUWXneG3wQ== heil@jun
