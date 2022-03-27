ansible-playbook --connection=local --inventory 127.0.0.1, -e nonrootuser=$USER playbook.yaml  
ansible-playbook -u root --inventory host, -e nonrootuser=vmuser -e ansible_python_interpreter=/usr/bin/python3 playbook.yaml  
