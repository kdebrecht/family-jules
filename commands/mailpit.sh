#!/usr/bin/env bash

# 6. Install Mailpit
echo "Installing Mailpit..."

curl -sL https://raw.githubusercontent.com/axllent/mailpit/develop/install.sh | bash

sudo tee /etc/systemd/system/mailpit.service > /dev/null <<EOF
[Unit]
Description=Mailpit
After=network.target

[Service]
ExecStart=/usr/local/bin/mailpit
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable mailpit
sudo systemctl start mailpit
