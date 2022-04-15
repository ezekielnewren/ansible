ansible-playbook --connection=local --inventory 127.0.0.1, -e nonrootuser=$USER playbook.yaml  
ansible-playbook -u root --inventory host, -e ansible_python_interpreter=/usr/bin/python3 -e ansible_port=22 -e nonrootuser=vmuser playbook.yaml  
