

#cp ./*.service /etc/systemd/system/
sleep 2
cp ./grafana.repo /etc/yum.repos.d/

sleep 2

yum install -y grafana fontconfig fontconfig* urw-fonts


sleep 2

systemctl start grafana-server.service
systemctl enable grafana-server.service
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
systemctl start alertmanager
systemctl enable alertmanager





