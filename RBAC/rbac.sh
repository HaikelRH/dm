#! /bin/bash

oc new-project rbac-demo-project

oc adm policy add-role-to-user admin user1
oc adm policy add-role-to-user edit user2
