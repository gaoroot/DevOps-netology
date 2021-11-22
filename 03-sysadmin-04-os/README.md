1. 
- 

`sudo vi /lib/systemd/system/node_exporter.service`

Выставляем права:

`sudo chmod 644 /lib/systemd/system/node_exporter.service`  

Обновляем конфигурацию и добавить в автозагрузку:  

`sudo systemctl daemon-reload`

`sudo systemctl enable node_exporter.service`

- 

![node_exporter status](img/node_exporter_status.png)

```
vagrant@ubuntu-bionic:~$ systemctl cat node_exporter.service 
# /lib/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter GovorinAO
After=multi-user.target

[Service]
EnvironmentFile=-/etc/default/node_exporter
ExecStart=/bin/node_exporter
IgnoreSIGPIPE=false
KillMode=process

[Install]
WantedBy=multi-user.target
```
-  
