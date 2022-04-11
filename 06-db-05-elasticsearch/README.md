# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте [Dockerfile](Dockerfile)-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий

Собрал образ `sudo docker build -t elastic8 .`   
  

- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Запустил образ `docker run --name elastic8 -p 9200:9200 -p 9300:9300 -d gaoroot/elastic8:latest` 

Требования к [elasticsearch.yml](elasticsearch.yml):

```yml
node.name: netology_test
path.data: /var/lib/data
path.logs: /var/lib/logs
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
xpack.security.enabled: false
```

- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст [Dockerfile](Dockerfile) манифеста

```docker
FROM centos:7

RUN yum -y install wget perl-Digest-SHA
COPY elasticsearch-8.1.1-linux-x86_64.tar.gz .
RUN tar -xzf elasticsearch-8.1.1-linux-x86_64.tar.gz && \
    rm elasticsearch-8.1.1-linux-x86_64.tar.gz

RUN adduser elasticsearch && chown -R elasticsearch /elasticsearch-8.1.1 && chown -R elasticsearch /var/lib

CMD ["./bin/elasticsearch"]
USER elasticsearch
WORKDIR elasticsearch-8.1.1
COPY elasticsearch.yml ./config/
EXPOSE 9200

```

- ссылку на образ в репозитории dockerhub

https://hub.docker.com/repository/docker/gaoroot/elastic8

- ответ `elasticsearch` на запрос пути `/` в console виде

```console
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "RSK_wlweRXusQgIms78ZbQ",
  "version" : {
    "number" : "8.1.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "d0925dd6f22e07b935750420a3155db6e5c58381",
    "build_date" : "2022-03-17T22:01:32.658689558Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}

```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```console
user0@server:~$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/console' -d'
> {
>  "settings":{
>   "number_of_shards": 1,
>   "number_of_replicas": 0
>  }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-1"
}

```

```console
user0@server:~/es2$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/console' -d'
> {
>  "settings":{
>   "number_of_shards": 2,
>   "number_of_replicas": 1
>  }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-2"
}

```

```console
user0@server:~/es2$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/console' -d'
> {
>  "settings":{
>   "number_of_shards": 4,
>   "number_of_replicas": 2
>  }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "ind-3"
}

```

```console
user0@server:~$ curl -X GET http://localhost:9200/_cat/indices
green  open ind-1 3rA-D_i_RhePy6HypJHADQ 1 0 0 0 225b 225b
yellow open ind-3 ngw26hqFQoW09RmC-QW2xQ 4 2 0 0 225b 225b
yellow open ind-2 XbB-xAsdTTW6VVeMhU2rZg 2 1 0 0 450b 450b
```

Получите состояние кластера `elasticsearch`, используя API.

```console
user0@server:~/es2$ curl -X GET "localhost:9200/_cat/shards?pretty&v=true"
index            shard prirep state      docs store ip         node
ind-1            0     p      STARTED       0  225b 172.17.0.2 netology_test
.geoip_databases 0     p      STARTED               172.17.0.2 netology_test
ind-2            1     p      STARTED       0  225b 172.17.0.2 netology_test
ind-2            1     r      UNASSIGNED
ind-2            0     p      STARTED       0  225b 172.17.0.2 netology_test
ind-2            0     r      UNASSIGNED
ind-3            2     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            2     r      UNASSIGNED
ind-3            2     r      UNASSIGNED
ind-3            1     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            1     r      UNASSIGNED
ind-3            1     r      UNASSIGNED
ind-3            3     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            3     r      UNASSIGNED
ind-3            3     r      UNASSIGNED
ind-3            0     p      STARTED       0  225b 172.17.0.2 netology_test
ind-3            0     r      UNASSIGNED
ind-3            0     r      UNASSIGNED

```

```console
user0@server:~/es2$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?   

Потому что, часть индексов содержит реплики которые должны быть на другой ноде, кластер состоит из одной ноды, количество активных шард в данный момент 44,4%  

Удалите все индексы.

```console
user0@server:~/es2$ curl -X DELETE "localhost:9200/ind-1?pretty"
{
  "acknowledged" : true
}
user0@server:~/es2$ curl -X DELETE "localhost:9200/ind-2?pretty"
{
  "acknowledged" : true
}
user0@server:~/es2$ curl -X DELETE "localhost:9200/ind-3?pretty"
{
  "acknowledged" : true
}
```


Повторная проверка статуса green и шарды 100%   
```console
user0@server:~/es2$ curl -X GET "localhost:9200/_cluster/health?pretty"
{
  "cluster_name" : "elasticsearch",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```console
curl -X PUT "localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-8.1.1/snapshot"
  }
}
'
{
  "acknowledged" : true
}
```


Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```console
curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

Запрос
    curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true&pretty"

Ответ
```json
{
  "snapshot" : {
    "snapshot" : "snapshot_1",
    "uuid" : "SYmpFZh9TmKnjhQLE7RZPA",
    "repository" : "netology_backup",
    "version_id" : 8010199,
    "version" : "8.1.1",
    "indices" : [
      ".geoip_databases",
      "test"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-04-11T12:11:40.416Z",
    "start_time_in_millis" : 1649679100416,
    "end_time" : "2022-04-11T12:11:41.625Z",
    "end_time_in_millis" : 1649679101625,
    "duration_in_millis" : 1209,
    "failures" : [ ],
    "shards" : {
      "total" : 2,
      "failed" : 0,
      "successful" : 2
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      }
    ]
  }
}
```

Запрос
    curl -X GET "localhost:9200/_snapshot/netology_backup/_all?pretty"

Ответ
```json
{
  "snapshots" : [
    {
      "snapshot" : "snapshot_1",
      "uuid" : "SYmpFZh9TmKnjhQLE7RZPA",
      "repository" : "netology_backup",
      "version_id" : 8010199,
      "version" : "8.1.1",
      "indices" : [
        ".geoip_databases",
        "test"
      ],
      "data_streams" : [ ],
      "include_global_state" : true,
      "state" : "SUCCESS",
      "start_time" : "2022-04-11T12:11:40.416Z",
      "start_time_in_millis" : 1649679100416,
      "end_time" : "2022-04-11T12:11:41.625Z",
      "end_time_in_millis" : 1649679101625,
      "duration_in_millis" : 1209,
      "failures" : [ ],
      "shards" : {
        "total" : 2,
        "failed" : 0,
        "successful" : 2
      },
      "feature_states" : [
        {
          "feature_name" : "geoip",
          "indices" : [
            ".geoip_databases"
          ]
        }
      ]
    }
  ],
  "total" : 1,
  "remaining" : 0
}
```

**Приведите в ответе** список файлов в директории со `snapshot`ами.


```console
user0@server:~/ES8$ docker ps
CONTAINER ID   IMAGE                          COMMAND                 CREATED          STATUS          PORTS
                                                                      NAMES
7a472934a842   gaoroot/elastic8-snap:latest   "./bin/elasticsearch"   11 minutes ago   Up 11 minutes   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 0.0.0.0:9300->9300/tcp, :::9300->9300/tcp   elastic8-snap

user0@server:~/ES8$ docker exec -it 7a472934a842 /bin/bash
[elasticsearch@7a472934a842 elasticsearch-8.1.1]$ ls snapshot/
index-0  index.latest  indices  meta-SYmpFZh9TmKnjhQLE7RZPA.dat  snap-SYmpFZh9TmKnjhQLE7RZPA.dat
[elasticsearch@7a472934a842 elasticsearch-8.1.1]$
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```console 
curl -X DELETE "localhost:9200/test?pretty"
{
  "acknowledged" : true
}
```

```console 
curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "number_of_shards": 1,
>     "number_of_replicas": 0
>   }
> }
> '
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

```console
curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot/_restore?pretty"
{
  "accepted" : true
}
```

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```console
curl -X POST "localhost:9200/_snapshot/netology_backup/snapshot/_restore?pretty"
{
  "accepted" : true
}
```

```console
curl -X GET "localhost:9200/_cat/indices?pretty"
green open test-2 myQIoIIaRiWkG5KDxaU4xQ 1 0 0 0 225b 225b
green open test   Ly7USZj2QSahx8EI-9ZwVQ 1 0 0 0 225b 225b
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

Пересобрал докер образ `gaoroot/elastic8-snap`

Dockerfile

```console
FROM centos:7

RUN yum -y install wget perl-Digest-SHA
COPY elasticsearch-8.1.1-linux-x86_64.tar.gz .
RUN tar -xzf elasticsearch-8.1.1-linux-x86_64.tar.gz && \
    rm elasticsearch-8.1.1-linux-x86_64.tar.gz

RUN mkdir /elasticsearch-8.1.1/snapshot
RUN adduser elasticsearch && chown -R elasticsearch /elasticsearch-8.1.1 && chown -R elasticsearch /var/lib

CMD ["./bin/elasticsearch"]
USER elasticsearch
WORKDIR elasticsearch-8.1.1
COPY elasticsearch.yml ./config/
EXPOSE 9200
```
elasticsearch.yml
```yaml
# ======================== Elasticsearch Configuration =========================
#
#
# ---------------------------------- Cluster -----------------------------------
#
# ------------------------------------ Node ------------------------------------
#
# Use a descriptive name for the node:
#
node.name: netology_test
#
# ----------------------------------- Paths ------------------------------------
#
# Path to directory where to store the data
#
path.data: /var/lib/data
path.repo: /elasticsearch-8.1.1/snapshot
#
# Path to log files:
#
path.logs: /var/lib/logs
#
# ----------------------------------- Memory -----------------------------------
#
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
network.host: 0.0.0.0
http.port: 9200
# --------------------------------- Discovery ----------------------------------
discovery.type: single-node
# ---------------------------------- Various -----------------------------------
xpack.security.enabled: false
```