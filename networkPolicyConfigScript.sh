#! /bin/bash


oc new-project test2

oc new-app --name whitelisted httpd
oc new-app --name blacklisted httpd


oc new-project test1

oc new-app --name httpd httpd
oc new-app --name whitelisted httpd
oc new-app --name blacklisted httpd

cat << 'EOF' > intraProjectPolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: intraprojectpolicy
spec:
  podSelector:
    matchLabels:
      deployment: httpd
  ingress:
    - from:
        - podSelector:
            matchLabels:
              deployment: whitelisted
      ports:
        - port: 8443
        - port: 8080
EOF

oc apply -f intraProjectPolicy.yaml


cat << 'EOF' > interProjectPolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: interprojectpolicy
spec:
  podSelector:
    matchLabels:
      deployment: httpd
  ingress:
    - from:
        - namespaceSelector:
            matchLabels:
              project: test2
          podSelector:
            matchLabels:
              deployment: whitelisted
      ports:
        - port: 8080
        - port: 8443
EOF

oc apply -f interProjectPolicy.yaml
