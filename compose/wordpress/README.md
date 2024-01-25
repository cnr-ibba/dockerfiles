
# Running Wordpress-fpm with docker-compose

This guide describe how to build a running Wordpress-fpm+MySQl with docker-compose. First of all copy all this directory in another location. You will modify configuration files  to develop your application. Next, rename the whole directory with your project name. Since docker-compose will build images starting from `docker-compose.yml` directory, it will be easier to find your builded images. In this example, the
wordpress site is referred as `blog`, as stated by installing wordpress guide. There are some directory that will be mounted as data volume: this will make easier to develop the code or re-spawn the docker application on another location using the same volume directory (as it would be for mysql-data directory). For this model, there will be a `php-data` directory for wordpress directory, and a `mysql-data` directory for mysql
data files

## The docker-compose.yml file

Before to start take a look in the `docker-compose.yml` file. This is the configuration file used by `docker-compose` commands. All `docker-compose` commands need to be instantiated in this directory or by specifying the path of `docker-compose.yml` file, as stated by the [docker compose documentation](https://docs.docker.com/compose/). For such compose project, 4 containers will be instantiated:

1. `db`: in this container will be placed the mariadb 10.11 server. This container will be listen for `php` wordpress container
2. `php`: in this container there will be the wordpress served by php-fpm server. This container will be linked with `db` container
3. `nginx`: this container will have nginx installed. All static files will be served by nginx by sharing static content as docker volumes between containers. php files will be served by the `php` container via php-fpm plugin.

Those name will be placed in each container in the `/etc/hosts` files, so you can ping `php` host inside `nginx` container, for instance, no matter what ip addresses will be given to the container by docker. When starting a project for the first time, data directory and initial configuration have to be defined. Data directories will be placed inside this directory, in order to facilitate `docker-compose` commands once docker images where configured for the application. When data directories are created for the first time, the ownership of such directories is the same of the service running in the container. You can change it as you prefer, but remember that service run under a *non privileged* user, so you have to define **at least** the *read* privileged for files, and the *read-execute* privileges for directories.

## Set the .env file

You need to create a `.env` file in this project directory in which specify
environment variables:

```conf
MYSQL_ROOT_PASSWORD=<a password>
MYSQL_DATABASE=wordpress
MYSQL_USER=<a user>
MYSQL_PASSWORD=<a password>
```

## Start a project for the first time

Before building and instantiating containers, you need to modify the `MYSQL_ROOT_PASSWORD` and `PROJECT_NAME` variables according your needs. Then you can build and run containers by typing:

```bash
docker-compose up -d
```

inside project directory. Images will be build and instantiated in background. See [docker compose documentation](https://docs.docker.com/compose/) for more details.

## Starting and stopping containers

To stop and restart containers, user docker-compose commands like:

```bash
docker-compose start
docker-compose restart
docker-compose stop
```

Those commands wouldn't recreate containers. Note that using `docker-compose up` will destroy containers (all data outside volume directories will be recreated)

### Dumping data from database

With the docker run command, you can do a database dump:

```bash
docker-compose run --rm mysql sh -c 'mysqldump -h mysql --password="${MYSQL_ROOT_PASSWORD}" wordpress' > wordpress_dump.sql'
```

### Loading data in database

With the docker run command, you can import a `<file>.sql` file by adding its path as a docker volume, for instance, if you are in `mysite_dump.sql` directory:

```bash
docker-compose run --rm --volume $PWD:/tmp/ mysql sh -c 'cat /tmp/wordpress_dump.sql | mysql -h mysql --password="${MYSQL_ROOT_PASSWORD}" wordpress'
```

## Serving docker containers in docker HOST

You can serve docker compose using HOST NGINX, for instance, via proxy_pass. Place the following code inside NGINX server environment. Remember to specify the port exported by your docker NGINX instance:

```conf
location /blog/ {
    # Add info to webpages
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass_header Set-Cookie;

    # Subitting a request to docker service
    proxy_pass http://localhost:10080/blog/;
    proxy_redirect http://$host:10080/ $scheme://$http_host/;
}
```
