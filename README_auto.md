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

Setup 1-
yum install epel-release 
yum install git
yum isntall ansible

git clone https://rakeshrathore78@bitbucket.org/rakeshrathore78/promuths.git

cd promuths 
ansible-playbook server.yml
Please Edit node.yml For node  details. 

vi /root/promuths/prometheus/node.yml
 targets:
    - 192.168.43.123:9100
  labels:
    env: prod
    group: phisical

- targets:
    - 192.168.43.124:9100
  labels:
    env: prod
    group: phisical


Edit alertmanager.yml For Email alert
vi /root/promuths/alertmanager/alertmanager.yml


#Client
Before running ansible command please add client ip details on hosts file 


ansible-playbook Client.yml

Check Status If node_exporter & pushgateway
run process Script
cd /root/promuths/Client/pushgateway/
./process

#edit cronjob

cront
@reboot /root/promuths/Client/pushgateway/process
https://prometheus.io/docs/instrumenting/exporters/






