# Prometheus

[![Prometheus with Grafana](https://www.mytinydc.com/images/blog/blog-prometheus+grafana.png)](https://bitbucket.org/rakeshrathore78/promuths)

#copied
Monitoring is an important part of managing applications deployed on servers. They help you ensure applications run smoothly, as well as troubleshoot any problems that may arise. In this article, we will look at Prometheus, which is a powerful open-source monitoring tool. Originally developed at SoundCloud, it has seen significant adoption in recent times. It pulls in metrics from various sources and stores them in a time-series database. It offers a powerful query language and the ability to visualize data using third-party tools.

#copied
What is Prometheus?
The Prometheus ecosystem consists of a number of components working together, as shown below.
[![Prometheus with Grafana](https://www.booleanworld.com/wp-content/webp-express/webp-images/doc-root/wp-content/uploads/2018/02/Prometheus-architecture.png.webp)
#Copied
The Prometheus server pulls in metrics at regular intervals through HTTP endpoints that provide information about hosts and various applications. These endpoints may be provided by the monitored application itself, or through an “exporter”. The endpoint URL is usually /metrics, and provides data as text or protobuf.
Short-lived jobs may push their metrics to “Pushgateway” for later retrieval by the server. In addition, you can use Prometheus to monitor other instances of it, since it makes its own metrics available in the same way.
After the server has collected the metrics, it saves it in a time-series database. Then, you can use PromQL to query this data. Prometheus provides a web interface to run queries. Other applications can run queries through the HTTP API to retrieve and work with the data. For example, third-party tools like Grafana use this API to help you visualize the data.
If you want to receive alerts via Slack, Email, PagerDuty or another platform, you may set up alerts through “AlertManager”. It is quite powerful, and supports features like grouping similar kinds of alerts or temporarily muting some alerts.

Note that many of these components such as Pushgateway or Alertmanager are optional — you may or may not use them, as per your need.

Recommendation & Installation
OS:-  Centos
RAM:- 4-12gb
HDD-  40gb

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
# just Create a file like bellow 


vi /etc/.argconf

ARG1=--log.level="debug"
ARG2=--collector.cpu
ARG3=--collector.textfile.directory
ARG4=/var/lib/node_exporter/textfile_collector
ARG5=--web.listen-address=":9091"
ARG6=--web.telemetry-path="/metrics"
ARG7=--persistence.file="/tmp/metric.store"
ARG8=--persistence.interval=5m
ARG9=--log.level="info"
ARG10=--log.format="logger:stdout?json=true"




https://prometheus.io/docs/instrumenting/exporters/

https://prometheus.io/download/


wget https://github.com/prometheus/pushgateway/releases/download/v1.2.0/pushgateway-1.2.0.linux-amd64.tar.gz


tar -xvf xvf pushgateway-1.2.0.linux-amd64.tar.gz

cp pushgateway-1.2.0.linux-amd64/pushgateway /usr/local/bin/

cat > /etc/systemd/system/pushgateway.service << EOF

Unit]
Description=Pushgateway
Wants=network-online.target
After=network-online.target

[Service]
User=root
Restart=on-failure
Type=simple
EnvironmentFile=/etc/.argconf
ExecStart=/root/pushgateway/pushgateway $ARG5 $ARG6 $ARG7 $ARG8 $ARG9



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
EnvironmentFile=/etc/.argconf
ExecStart=/root/node_exporter/node_exporter  $ARG1 $ARG2 $ARG3 $ARG4

[Install]
WantedBy=multi-user.target


 systemctl daemon-reload
 systemctl start node_exporter
 systemctl enable node_exporter
