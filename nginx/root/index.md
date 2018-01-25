
# Graylog Docker Multi Node

## available Services

- [graylog](/graylog)
- [cerebro](/cerebro)
- [nossqlclient](/nosqlclient)

### exposed ports

- **8080** NGINX 
- **9000** Graylog (available at `/graylog/` to _gl1_ server)
- **27017** MongoDB (without authentification!)
- **9200** Elasticsearch (without Authentication to _es1_ server )

## Description

This System was build after I had destroyed the configuration of my Lab. The final Idea is to have every used/needed component up and running in a single docker-compose.

This build includes two Graylog Nodes, two Elasticsearch Nodes, single MongoDB.

As additional helper [cerebro](https://github.com/lmenezes/cerebro) and [nosqlclient](https://github.com/nosqlclient/nosqlclient) is available. To look at Elasticsearch and MongoDB in detail.

This is not (yet?) a way to build automated setups that includes data. After the first startup you have a fresh installation.




## Customization

The Enterprise Plugins need to be fetched manual (as long as no own graylog image is used) ` https://downloads.graylog.org/releases/graylog-enterprise/plugin-bundle/tgz/graylog-enterprise-plugins-2.4.1.tgz ` just adjust the version that you need and replace the links in `docker-compose.yml` 

The content of `graylog/shared` is placed in `/data/shared` on both Graylog Nodes. This can be used to provide the GeoIP Database or Lookup Table sources (`.csv`) 

- `http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz` 


```
.
├── cerebro
│   └── cerebro_application.conf
├── docker-compose.yml
├── graylog
│   ├── config
│   │   ├── node-id.gl1
│   │   └── node-id.gl2
│   ├── plugins
│   │   ├── graylog-plugin-archive-2.4.3.jar
│   │   ├── graylog-plugin-auditlog-2.4.3.jar
│   │   ├── graylog-plugin-auditlog-2.4.3jar
│   │   └── graylog-plugin-license-2.4.3.jar
│   └── shared
│       └── GeoLite2-City.mmdb
└── nginx
    ├── config
    │   ├── conf.d
    │   │   └── glmulti.conf
    │   └── nginx.conf
    └── root
        ├── config.json
        ├── index.html
        └── index.md
```

## Backups & Restore

you need to connect a new container that runs the backup to the current used network and provide the location to create a dump of your mongodb:

```
docker run --rm --link mongo:mongo --network=dgraylab_graylog.net -v /Users/jd/bench/d-gray-lab/backup:/backup mongo:3 bash -c 'mongodump --out /backup --host mongo:27017'
``` 

restore (and do not keep any data)

```
docker run --rm --link mongo:mongo --network=dgraylab_graylog.net -v /Users/jd/bench/d-gray-lab/backup:/backup mongo:3 bash -c 'mongorestore --drop --db graylog --host mongo:27017 /backup/graylog'
```

