# LEMP Stack (Docker )

Docker Containers (as microservice approach), which are executed with `docker-compose` as a multi-container application (stack).

- Persistent storage (Application and Data Volume Container)
- Web server **nginx**
- **PHP 7.4.x** with mysqli extension
- SQL database **MariaDB**
- **Adminer** for database administration

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
