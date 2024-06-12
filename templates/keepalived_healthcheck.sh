#!/bin/bash

if [ $(id -u) -eq 0 ]; then
    export KUBECONFIG=/etc/kubernetes/admin.conf
fi

nc -z localhost 6443 || exit $?
kubectl get node `hostname`.ezekielnewren.com | grep -q SchedulingDisabled && exit 1
exit 0

