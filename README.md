# Docker Web Development Stack (DWDS)

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

> Develop only through the container.

> Each container should have only one concern.

## Images and Containers

- **Persistent storage** (Application and Data Volume Container).
  - `./src/frontend`
  - `./src/backend`
  - `./storage/db.data`
  - `./storage/gitea.data`
  - Use symbolic links so that you can reuse the containers below.
    - `src -> /DATA/yourapp/src/`
    - `storage -> /DATA/yourapp/storage/`
- [**NGINX**](https://www.nginx.com/) Web server. Deliver the frontend `./application/frontend/dist` and provide API access via proxy forwarder.
- **PHP 7.4.x (CLI)** with Composer, PHP CodeSniffer, phpDocumentor, phpunit and XDebug (Multi Stage) for development.
- [**MariaDB**](https://mariadb.org/) SQL database.
- [**Adminer**](https://www.adminer.org/) for database administration.
- [**Grafana**](https://grafana.com/) logging.
  - Loki: log aggregator
  - Promtail: Agent which will read up the contents of the log file/files and ship those logs to Loki
- [**Gitea**](https://gitea.io/) Repository and Issue tracker.
- [**MailDev**](https://github.com/maildev/maildev) SMTP Server + Web Interface for viewing and testing emails during development.

## Initial services configuration

### Gitea

- To access gitea from your development environment you should set `SSH-Server-Domain` and `Gitea-Base-URL` to an appropriate resolvable name or IP address.
- Add the administration user on setup or the first user registered will be the admin
- Gitea supports Git over SSH. You might be familiar with this when you work with GitHub repositories. You need to create a key pair on your computer and add the public key under _Your Settings_ -> _SSH / GPG Keys_ . Copy and paste the public key into the Content text field then click the green Add Key button.

### Logging

The Docker plugin must be installed on each Docker host that will be running containers you want to collect logs from. [Read Docker Driver Client](https://grafana.com/docs/loki/latest/clients/docker-driver/)

```bash
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Add loki to docker container:

```byaml
    logging:
      driver: loki
      options:
        loki-url: "http://loki:3100/loki/api/v1/push"
      driver: "json-file"
      options:
        tag: "{{.ImageName}}|{{.Name}}|{{.ImageFullID}}|{{.FullID}}"
```

* [Check loki URL: http://<ip_address>:7431/metrics](http://localhost:7431/metrics)
* [Check promtail URL: http://<ip_address>:9080](http://localhost:7431/metrics)

Additional setup steps and informations:

* [Monitoring your docker container’s logs the Loki way](https://itnext.io/monitoring-your-docker-containers-logs-the-loki-way-e9fdbae6bafd) and [Log Aggregation With Grafana+Loki+Promtail](https://cloudsbaba.com/log-aggregation-with-grafanalokipromtail/)
* [Loki Syslog All-In-One example](https://computingforgeeks.com/forward-logs-to-grafana-loki-using-promtail/)
* [Running loki and grafana on docker swarm](https://drailing.net/2020/06/running-loki-and-grafana-on-docker-swarm/)

## .env Environment

Environment variables allow us to manage the configuration of our applications separate from our codebase. Separating configurations make it easier for our application to be deployed in different environments. **Note:** Values in the shell take precedence over those specified in the `.env` file.

- **Docker Node.js** contains [`dotenv`](https://www.npmjs.com/package/dotenv). We [start the node app with `dotenv` preloaded](https://dev.to/getd/how-to-manage-secrets-and-configs-using-dotenv-in-node-js-and-docker-2214)
- **Docker PHP** contains [`PHP dotenv`](https://github.com/vlucas/phpdotenv), while using `getenv()` and `putenv()` is strongly discouraged due to the fact that these functions are not thread safe.

## Command line usage

**Since everything that has to do with the stack, only runs in the container, you have to put the commands into the corresponding container.**

To start/stop the stack, enter the following command in the terminal:

```bash
docker-compose -f "docker-compose.yml" up -d
docker-compose -f "docker-compose.yml" down
```

To open a shell in the application's container, use:

```bash
docker exec -it <container> /bin/bash
```

To execute a PHP script:

```bash
docker exec php /usr/local/bin/php /var/www/backend/public/index.php
```

Creating database dumps:

```bash
docker exec db sh -c 'exec mysqldump --all-databases -uroot -p"$MARIADB_ROOT_PASSWORD"' > /some/path/on/your/host/all-databases.sql
```

Restoring data from dump files

```bash
docker exec -i db sh -c 'exec mysql -uroot -p"$MARIADB_ROOT_PASSWORD"' < /some/path/on/your/host/all-databases.sql
```

Start node development mode

```bash
docker exec -it nodejs npm run serve
```

Build Frontend

```bash
docker exec -it nodejs npm run build`
```

Add packages to node.js

```bash
docker exec -it nodejs npm install dotenv --save
```

Add packages to php

```bash
docker exec -it php composer require vlucas/phpdotenv
```

## License

MIT © Fabian Dennler
