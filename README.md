ansible-playbook -c=local -i 127.0.0.1, -e nonrootuser=$USER -e '{"role_list":["git"]}' run-roles.yaml  
ansible-playbook -u root -i host, -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 -e nonrootuser=vmuser playbook.yaml  
ansible-playbook --limit pm0, -e '{"role_list":["git"]}' run-roles.yaml  
ansible-playbook --limit ceph_cluster -e '{"role_list":["git"]}' run-roles.yaml  
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --limit pm0, -e '{"role_list":["git"]}' run-roles.yaml  

