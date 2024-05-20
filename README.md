## install required tools for ansible-playbook to run properly
ansible-playbook -c=local -i 127.0.0.1, -e ansible_python_interpreter=$(realpath `which python3`) -e '{"role_list":["ansible_required"]}' run-roles.yaml
## specific examples
ansible-playbook -c=local -i 127.0.0.1, -e nonrootuser=$USER -e '{"role_list":["git"]}' run-roles.yaml  
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i pm2, -u metal -e nonrootuser=metal -e sshuser=metal -e '{"role_list":["baremetal"]}' run-roles.yaml  
ansible-playbook -i hosts.ini keepalived.yaml  
