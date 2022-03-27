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
