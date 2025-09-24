#!/bin/sh

read -p "cluster name : " cluster_name
temp_file_name="${cluster_name}_config.txt"

echo "tls-san:" > $temp_file_name
echo "  - cnbsoft.com" >> $temp_file_name

for i in $(multipass exec ${cluster_name}-master -- ip a | grep -v grep | grep enp | grep inet | awk '{print$2}' | awk -F/ '{print$1}'); do
  config="${config}  - ${i}\r\n"
  cat<<EOF >> $temp_file_name
  - ${i}
EOF
done

cat $temp_file_name | multipass exec ${cluster_name}-master -- sudo tee /etc/rancher/k3s/config.yaml
rm -rf $temp_file_name
multipass exec ${cluster_name}-master -- sudo systemctl restart k3s
