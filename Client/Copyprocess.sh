

cp ./*.service /etc/systemd/system/
sleep 2

cp ./.argconf /etc/

sleep 2



sleep 2

systemctl daemon-reload
systemctl restart pushgateway
systemctl enable pushgateway
systemctl daemon-reload
Dsystemctl restart node_exporter
systemctl enable node_exporter







