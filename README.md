# Docker Web Development Stack (DWDS)

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

> Develop only through the container.

> Each container should have only one concern.

## Images and Containers

- **Persistent storage** (Application and Data Volume Container).
- [**NGINX**](https://www.nginx.com/) Web server. (`Listen on port: 7080`)
- **PHP 7.4.x (CLI)** with Composer, PHP CodeSniffer, phpDocumentor, phpunit and XDebug (Multi Stage). (`Listen on port: 9000`)
- [**MariaDB**](https://mariadb.org/) SQL database. (`Listen on port: 7306`)
- [**Adminer**](https://www.adminer.org/) for database administration. (`Listen on port: 7180`)
- [**Grafana**](https://grafana.com/) logging. (`Listen on port: 7100 / 7980`)
- [**Gitea**](https://gitea.io/) Repository and Issue tracker. (`Listen on port: 7330`)
- [**MailCatcher**](https://mailcatcher.me/) to catch all mail and stores it for display. (`Listen on port: 7180`)

## Command line usage

**Since everything that has to do with the stack, only runs in the container, you have to put the commands into the corresponding container.**

To start/stop the stack, enter the following command in the terminal:

```bash
docker-compose -f "docker-web/docker-compose.yml" up
docker-compose -f "docker-web/docker-compose.yml" down
```

To open a shell in the application's container, use:

```bash
docker exec -it <container> /bin/bash
```

To create an archive of the stack use inside the project folder:

```bash
tar --exclude='./application/data/' -czvf ../docker-web-raw.tar.gz .
```

To execute a PHP script:

```bash
docker exec php /usr/local/bin/php /var/www/html/index.php
```

## License

MIT © Fabian Dennler
