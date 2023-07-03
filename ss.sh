#!/bin/bash
mkdir /etc/gost

tee /etc/gost/gost.yml <<-EOF
services:
- name: service-0
  addr: :3389
  handler:
    type: ss
    auth:
      username: chacha20-ietf-poly1305
      password: zhejiushimima
  listener:
    type: tcp
EOF

tee /lib/systemd/system/gost.service <<-EOF
[Unit]
Description=GO Simple Tunnel
After=network.target
Wants=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/gost
Restart=always

[Install]
WantedBy=multi-user.target
EOF

VER=3.0.0-rc8
wget https://github.com/go-gost/gost/releases/download/v${VER}/gost_${VER}_linux_amd64.tar.gz
tar xf gost_${VER}_linux_amd64.tar.gz
mv gost /usr/local/bin/
rm gost_${VER}_linux_amd64.tar.gz
sudo systemctl daemon-reload
sudo systemctl enable gost
sudo systemctl start gost
