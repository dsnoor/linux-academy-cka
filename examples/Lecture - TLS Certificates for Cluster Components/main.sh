## do it on any machine, not necessarily k8s master

# install easyrsa
yum install -y easy-rsa

# use easy rsa master to create
cd k8s/easy-rsa-master/easyrsa3/
./easyrsa init-pki

# generate ca
./easyrsa --batch "--req-cn=${MASTER_IP}@`date +%s`" build-ca nopass
# will return:
Generating a 2048 bit RSA private key
..........+++
.....................+++
writing new private key to '/root/cert/pki/private/ca.key.DPzOfk6x7Q'
-----

cat ~/k8s/rsa-request.sh
# ---
#!/bin/bash
./easyrsa --subject-alt-name="IP:${MASTER_IP},"\
"IP:${MASTER_IP},"\
"DNS:kubernetes,"\
"DNS:kubernetes.default,"\
"DNS:kubernetes.default.svc,"\
"DNS:kubernetes.default.svc.cluster,"\
"DNS:kubernetes.default.svc.cluster.local," \
--days=1000 \
build-server-full server nopass

bash ~/k8s/rsa-request.sh
# then we should get
# pki/ca.crt
# pki/issued/server.crt
# pki/private/server.key
# pki/private/ca.key

# To check the certs for k8s, on api server:
ps aux | grep apiserver
