#!/bin/bash
sudo snap install microk8s --classic --channel=1.28
sudo usermod -a -G microk8s ${ssh_username}
sudo chown -f -R ${ssh_username} ~/.kube
su - ${ssh_username}