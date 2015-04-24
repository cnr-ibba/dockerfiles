
Running Django+MySQL-uwsgi on docker-compose
============================================

This guide describe how to build a running Django+MySQl running with docker-compose. First of all copy all this directory in another location. You will modify something to develop your application. There are some directory that will be mounted as data volume: this will make easier to develop the code or re-spawn the docker application on another location using the same mysql-data directory. For this model, al MySQL data file will be placed in `mysql-data` directory inside this project; All django data will be placed in django-data directory inside this project

## Create the MySQL container

When MySQL is started from a docker container, all data directories have to be created, so is preferred to start MySQL manually for the first time. I such way, we can set the MySQL root password for the first time. The container can be instantiated with `docker-compose run` by passing the MySQL root password by `MYSQL_ROOT_PASSWORD` as stated by [mysql docker documentation](https://registry.hub.docker.com/u/library/mysql/). 

```sh
$ docker-compose run -d -e MYSQL_ROOT_PASSWORD=my-secret-pw db
```

Once MySQL is istantiated for the first time or `mysql-data` directory is created or derived from another container, MySQL can be run with `docker-compose` standard commands. 

The `$MYSQL_ENV_MYSQL_ROOT_PASSWORD` must be the same password chosen when database was created. Once MySQL data files are created (you can inspecy MySQL logs with `docker logs`), connect to MySQL database and create database and users needed from MySQL connections. The MySQL container defined in `docker-compose.yml`, never expose a port outside. You can get a mysql client to this container by linking a new  container, for instance:

```sh
$ docker run -it --link django_db_run_1:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

The `--link <mysql_running_container>:mysql` specifies the MySQL running container and an alias for this.

```SQL
mysql> CREATE DATABASE mysite ;
mysql> GRANT ALL PRIVILEGES ON mysite.* TO django@'%' IDENTIFIED BY 'django' ;
mylsq> exit;
```

Next, you can shut down the MySQL running container, in order to control it via docker-compose:

```sh
$ docker stop django_db_run_1
```

## Create django container

Now you can build the django image from its `Dockerfile` or build it automatically with `django-admin.py`. In this case, we initialize a new project and we build a new docker image if it not exists (note the final `.`: is the destination directory):

```sh
$ docker-compose run web django-admin.py startproject mysite .
```

Now you need to set up the database connection. Replace the DATABASES = ... definition in `django-data/mysite/settings.py`:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'mysite',
        'USER': 'django',
        'PASSWORD': 'django',
        'HOST': 'db',
        'PORT': 3306,
    }
}
```

Note that the `db` host is the same name used in `docker-compose.yml`. User, database and password are the same specified in the example above. 

## Create phpMyAdmin container

Blah, Blah

## Create NGINX container

Blah, Blah...

## Starting containers with docker compose

Now start database and django (in daemonized mode):

```sh
$ docker-compose up -d 
```

You can also run management commands with Docker. To set up your database, for example, run docker-compose up and in another terminal run:

```sh
$ docker-compose run web python manage.py syncdb
```

