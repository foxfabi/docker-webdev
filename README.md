# Docker Web Development Stack (DWDS)

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

> Develop only through the container.

> Each container should have only one concern.

## Images and Containers

- **Persistent storage** (Application and Data Volume Container).
  - `./application/frontend`
  - `./application/backend`
- [**NGINX**](https://www.nginx.com/) Web server. Deliver the frontend `./application/frontend/dist` and provide API access via proxy forwarder.
- **PHP 7.4.x (CLI)** with Composer, PHP CodeSniffer, phpDocumentor, phpunit and XDebug (Multi Stage) for development.
- [**MariaDB**](https://mariadb.org/) SQL database.
- [**Adminer**](https://www.adminer.org/) for database administration.
- [**Grafana**](https://grafana.com/) logging.
- [**Gitea**](https://gitea.io/) Repository and Issue tracker.
- [**MailCatcher**](https://mailcatcher.me/) to catch all mail and stores it for display.

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

## License

MIT © Fabian Dennler
