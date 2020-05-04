
Promethus Server--
yum install epel-release
yum install git
yum isntall ansible 

wget https://github.com/prometheus/prometheus/releases/download/v2.17.2/prometheus-2.17.2.linux-amd64.tar.gz

tar -xvf prometheus-2.17.2.linux-amd64.tar.gz


vi /etc/systemd/system/prometheus.service

[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=root
Restart=on-failure
#ExecStart=/root/promuths/prometheus/prometheus --config.file=/root/promuths/prometheus/prometheus.yml

ExecStart=/root/promuths/prometheus/prometheus \
    --config.file=/root/promuths/prometheus/prometheus.yml \
    --storage.tsdb.path /root/promuths/prometheus/ \
    --web.console.templates=/root/promuths/prometheus/consoles \
    --web.console.libraries=/root/promuths/prometheus/console_libraries




[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus



https://github.com/prometheus/alertmanager/releases/download/v0.20.0/alertmanager-0.20.0.linux-amd64.tar.gz

tar -xvf alertmanager-0.20.0.linux-amd64.tar.gz

cd alertmanager-0.20.0.linux-amd64

vim /etc/systemd/system/alertmanager.service

#./alertmanager --config.file=alertmanager.yml



[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=root
Restart=on-failure
Type=simple
WorkingDirectory=/root/promuths/alertmanager/ 
ExecStart=/root/promuths/alertmanager/alertmanager --config.file=/root/promuths/alertmanager/alertmanager.yml --web.external-url http://0.0.0.0:9093

[Install]
WantedBy=multi-user.target

 
 systemctl daemon-reload
 systemctl start alertmanager
 systemctl enable alertmanager


CLient---


https://prometheus.io/docs/instrumenting/exporters/

https://prometheus.io/download/


wget https://github.com/prometheus/pushgateway/releases/download/v1.2.0/pushgateway-1.2.0.linux-amd64.tar.gz


tar -xvf xvf pushgateway-1.2.0.linux-amd64.tar.gz

cp pushgateway-1.2.0.linux-amd64/pushgateway /usr/local/bin/

cat > /etc/systemd/system/pushgateway.service << EOF
[Unit]
Description=Pushgateway
Wants=network-online.target
After=network-online.target

[Service]
User=root
Restart=on-failure
Type=simple
ExecStart=/usr/local/bin/pushgateway \
    --web.listen-address=":9091" \
    --web.telemetry-path="/metrics" \
    --persistence.file="/tmp/metric.store" \
    --persistence.interval=5m \
    --log.level="info" \
    --log.format="logger:stdout?json=true"

[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl restart pushgateway
systemctl enable pushgateway


while sleep 1; do ./getCronProcess.sh; done;

wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

tar -xvf node_exporter-0.18.1.linux-amd64.tar.gz

cp node_exporter-0.17.0.linux-amd64/node_exporter /usr/local/bin

vim /etc/systemd/system/node_exporter.service


[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Restart=on-failure
Type=simple
#ExecStart=/usr/local/bin/node_exporter

ExecStart=/usr/local/bin/node_exporter --log.level="debug" --collector.cpu --collector.textfile.directory /var/lib/node_exporter/textfile_collector
[Install]
WantedBy=multi-user.target

 systemctl daemon-reload
 systemctl start node_exporter
 systemctl enable node_exporter