pacman -S ansible-core

ansible-galaxy collection install community.general

ansible-playbook --ask-become-pass base.yml

ansible-playbook --ask-become-pass main.yml
ansible-playbook --ask-become-pass main-macos.yml
ansible-playbook --ask-become-pass yabai.yml
