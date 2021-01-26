# LEMP Stack (Docker)

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

- Persistent storage (Application and Data Volume Container)
- Web server **nginx**
- **PHP 7.4.x** with mysqli extension
- **PHP 7.4.x CLI** with mysqli extension
- SQL database **MariaDB**
- **Adminer** for database administration

## Command line usage

To start/stop the stack, enter the following command in the terminal:

```bash
docker-compose -f "docker-web/docker-compose.yml" up
docker-compose -f "docker-web/docker-compose.yml" down
```

To open a shell in the application's container, use:

```bash
docker exec -it app /bin/bash
```

To create an archive of the stack use inside the project folder:

```bash
tar --exclude='./application/data/' -czvf ../docker-web-raw.tar.gz .
```

To execute a PHP script with the command line interface (CLI):

```bash
docker exec cli /usr/local/bin/php /var/www/html/nominatim.php
```

## License

MIT © Fabian Dennler