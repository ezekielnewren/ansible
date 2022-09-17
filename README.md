ansible-playbook --connection=local --inventory 127.0.0.1, -e nonrootuser=$USER playbook.yaml  
ansible-playbook -u root --inventory host, -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 -e nonrootuser=vmuser playbook.yaml  
ansible-playbook --limit pm0, -e '{"role_list":["ceph"]}' run-roles.yaml  
ansible-playbook --limit ceph_cluster -e '{"role_list":["ceph"]}' run-roles.yaml  
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --limit pm0, -e '{"role_list":["ceph"]}' run-roles.yaml  

