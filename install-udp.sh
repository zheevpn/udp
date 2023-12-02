#!/bin/bash
clear
cd
rm -rf /root/udp
mkdir -p /root/udp

# change to time GMT+7
echo "change to time GMT+7"
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# install udp-custom
echo downloading udp-custom
cd /root/udp
wget -q -O udp-custom "https://raw.githubusercontent.com/zheevpn/udp/main/files/udp-custom-linux-amd64"
chmod +x udp-custom
sleep 2
echo downloading default config
wget -q -O config.json "https://raw.githubusercontent.com/zheevpn/udp/main/files/config.json"
chmod 644 config.json
cd

cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=UDP Custom

[Service]
User=root
Type=simple
ExecStart=/root/udp/udp-custom server -exclude $1
WorkingDirectory=/root/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF

systemctl start udp-custom &>/dev/null
systemctl enable udp-custom &>/dev/null
systemctl restart udp-custom &>/dev/null
rm -rf udp.sh
