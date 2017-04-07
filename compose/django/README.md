
Running Django+MySQL-uwsgi with docker-compose
==============================================

This guide describe how to build a running Django+MySQl running with docker-compose. First of all copy all this directory in another location. You will modify something to develop your application. Next, rename the whole directory with a project name. In this example, all names are set to mysite. Replace all mysite occurences with your project name. All docker container instances will have such name as a prefix in their name. There are some directory that will be mounted as data volume: this will make easier to develop the code or re-spawn the docker application on another location using the same volume directory (as it would be for mysql-data directory). For this model, al MySQL data file will be placed in `mysql-data` directory inside this project; All django data will be placed in `django-data` directory inside this project. When such directories are created for the first time, there are created and mounted as a root directories. After permission can be fixed according user need. However processes like ngnix, uswgi and php-fpm work with a different user from root, and so files have to be accessed in read mode

## The docker-compose.yml file

Before to start take a look in the `docker-compose.yml` file. This is the configuration file used by `docker-compose` commands. All `docker-copose` commands need to be instantiated in this directory or by specifing the path of `docker-compose.yml` file, as stated by the [docker compose documentation](https://docs.docker.com/compose/). For such compose project, 4 countainers will be instantiated:

1. `db`: in this container will be placed the mysql 5.6 server. This container will be listen for `web` django container and `php` phpmyadmin container
2. `web`: this will be the django container in which uwsgi server will run. This container will be linked with `db` container
3. `php`: in this container there will be the phpmyadmin served by php-fpm server. This container will be linked with `db` container
4. `nginx`: this container will have nginx installed. All static file will be served by nginx by sharing static content as docker volumes between containers. php and django files will be served by the appropriate container via fastCGI plugin.

Those name will be placed in each container `/etc/hosts` files, so you can ping `web` host inside `nginx` container, for instance, mo matter what ip addresses will be given to the container by docker. When starting a project for the first time, data directory and inital configuration have to be defined. Data directories will be placed inside this directory, in order to facilitate `docker-compose` commands once docker images where configured for the application. When data directories are created for the first time, the ownership of such directories is the same of the service running in the container. You can change it as you prefer, but remember that service run under a *non privileged* user, so you have to define **at least** the *read* privileged for files, and the *read-execute* privileges for directories.

## Create the MySQL container

Before building and instantiating containers, you need to modify the `MYSQL_ROOT_PASSWORD`
variables according your needs. Then you can build and run containers by typing:

```
$ docker-compose up -d db
```

Once MySQL is istantiated for the first time or `mysql-data` directory is created
or derived from another container, MySQL can be run with `docker-compose` standard
commands. Once MySQL data files are created (you can inspecy MySQL logs with
`docker-compose logs`), connect to MySQL database and create database and users
needed from MySQL connections. The MySQL container defined in `docker-compose.yml`,
never expose a port outside. You can get a mysql client to this container by
linking a new  container, for instance:

```
$ docker run -it --link <mysql_running_container>:mysql -e MYSQL_ROOT_PASSWORD="my-secret-pw" \
  --rm mysql:5.6 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" \
  -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'
```

The `--link <mysql_running_container>:mysql` specifies the MySQL running container
and an alias for this. You can get the running container names using `docker-compose ps`
or `docker ps` command. Now create a database and a user for the django instance
with permission to work on such database

```SQL
mysql> CREATE DATABASE mysite ;
mysql> GRANT ALL PRIVILEGES ON mysite.* TO django@'%' IDENTIFIED BY 'django' ;
mylsq> exit;
```

### Dumping data from database

With the docker run command, you can do a `mysite` database dump:

```
$ docker run -it --link <mysql_running_container>:mysql -v $PWD:/data/ -e MYSQL_ROOT_PASSWORD="my-secret-pw" \
  --rm mysql:5.6 sh -c 'exec mysqldump -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" \
  -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" mysite > /data/mysite_dump.sql''
```

Note as variables like `MYSQL_ROOT_PASSWORD="my-secret-pw"` are traslated with the
prefix `MYSQL_ENV_` inside running container. The dump will be write in the `/data`
volumes directory, which is your current `$PWD` directory. The ownership of dump
file is the same of the `$USER` in the running container.

### Loading data in database

With the docker run command, you can import a `.sql` file by adding its path as
a docker volume, for instance, if you are in `mysite_dump.sql` directory:

```
$ docker run -it --link <mysql_running_container>:mysql -v $PWD:/data/ -e MYSQL_ROOT_PASSWORD="my-secret-pw" \
  --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" \
  -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" mysite < /data/mysite_dump.sql'
```

## Create django container

Django script will be served using the uwsgi server. You can get more informaton here:

* [How to use Django with uWSGI](https://docs.djangoproject.com/en/1.8/howto/deployment/wsgi/uwsgi/)
* [Django and NGINX](https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html)
* [uwsgi configuration](https://uwsgi.readthedocs.org/en/latest/Configuration.html)

### Fixing Dokerfile and uwsgi.ini files

Take a look in to the web directory:

```
$ tree web
web/
├── Dockerfile
├── mysite_uwsgi.ini
└── requirements.txt
```

`requirements.txt` is a list of python modules which will be installed when the image is builded for the first time. At the moment, only the uwsgi python module is listed; All python modules needed by the application needs to be specified here one by line. The `mysite_uwsgi.ini` contains uwsgi configuration for one python application. The default path of the application is the `mysite` directory of the django tutorial. If you want to modify the project directories, rember to modify `docker-compose` commands according to this. `mysite_uwsgi.ini` will be placed in `/etc/django_uwsgi.ini` inside the Dockerfile. If you rename `mysite_uwsgi,ini` in `<your_application>_usgi.ini` rember to fix also the Dockerfile.

### Creating a project for the first time

For such example, we suppose that the django project name will be `mysite` as stated
by the [django tutorial](https://docs.djangoproject.com/en/1.11/intro/tutorial01/#creating-a-project).
Now you can build the django image from its `Dockerfile` or build it automatically
with `docker-compose`. In this case, we initialize a new project and we build a new
docker image if it not exists (since we have not specified a destination directory,
a `mysite` project directory is created and placed under /var/uwsgi/.
Inside mysite, we will have `manage.py`):

```
$ docker-compose run --rm web django-admin.py startproject mysite
```

This will build the django image and runs the `django-admin.py` script. If there
are prerequisites, for example containers linked to that, they will be started before
the `web` django container. After that, the container stops and we return to the
shell environment. You may want to fix file permissins in order to edit files, for
example:

```
$ sudo chown -R ${USER}:${USER} django-data
```

Now we need to set up the database connection. You may want
change default ownership to edit files. Replace the `DATABASES = ...` definition
in `django-data/mysite/mysite/settings.py` accordingly your project database settings:

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

Note that the `db` host is the same name used in `docker-compose.yml`. User, database
and password are the same specified in the example above. Remember to set the timezone:
docker compose will export HOST /etc/localtime in read only mode, but it's better
to set timezone also in django in order to have correct times:

```python
TIME_ZONE = 'Europe/Rome'
```

We have to set also the static file positions. It's better to prepend the django
project names in order to write rules to serve static files via nginx. Here is an
example for mysite project:

```python
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.8/howto/static-files/
STATIC_URL = '/mysite/static/'

# collect all Django static files in the static folder
STATIC_ROOT = os.path.join(BASE_DIR, "static/")
```

The `STATIC_URL` variable will tell to django (uwsgi) how to define links to static
files, and the `STATIC_ROOT` variable will set the position in which static files
(as the admin .css files) will be placed. You may want to create a `/static/media`
directory inside `mysite`, in order to place media files. Then you have to call
the `collectstatic` command in order to place the static files in their directories:

```
$ mkdir django-data/mysite/static/
$ mkdir django-data/mysite/media/
$ docker-compose run --rm web python mysite/manage.py collectstatic
```

#### Auto restart uwsgi when code is modified:

As stated [here](http://uwsgi-docs.readthedocs.io/en/latest/ThingsToKnow.html?highlight=autoreload)
autoreload could be CPU intensive and must be used only in developmente environment:
*"Some plugins (most notably Python and Perl) have code auto-reloading facilities.
Although they might sound very appealing, you MUST use them only under development
as they are really heavy-weight. For example the Python –py-autoreload option will
scan your whole module tree at every check cycle."*

#### Initialize django database for the first time

You may want to run the following commands to create the necessary django tables
if django database is empty.

```
$ docker-compose run --rm web python mysite/manage.py migrate
```

More info could be found [here](https://docs.djangoproject.com/en/1.11/intro/tutorial02/#database-setup)

### Add an existing project to django container

The `django-data` directory need to be create if does't exists. Then you have to create a <project name> directory in which put the `manage.py`. Static files needs to be placed inside the <project name> directory, or links or static urls needs to be modified in order to be served correctly. For instance, to place a django project into a `mysite` directory:

```sh
$ mkdir -p django-data/mysite
$ cp -r /a/django/project/ django-data/mysite/
$ mkdir django-data/mysite/media
$ mkdir django-data/mysite/static
```

## Create phpMyAdmin container

phpMyadmin will be served using `php-fpm` server. You can find some useful information here:

* [phpMyAdmin installation](http://docs.phpmyadmin.net/en/latest/setup.html)
* [FastCGI Process Manager (FPM)](http://php.net/manual/en/install.fpm.php)
* [Nginx and PHP-FPM Configuration and Optimizing Tips and Tricks](http://www.if-not-true-then-false.com/2011/nginx-and-php-fpm-configuration-and-optimizing-tips-and-tricks/)
* [Example configuration of php-fpm](https://github.com/perusio/php-fpm-example-config)

First, take a look inside php directory:

```sh
$ tree php/
php/
├── config.inc.php
├── Dockerfile
└── php-fpm.conf
```

In the `php-fpm.conf` there are some configuration for `php-fpm` process. You can change some parameters if you want, but this file is independent from your django instace. Instead in the `Dockerfile` there are this statement that need to be modified in order to work when proxy passing from a host server to docker-compose nginx. In such case `mysite` is the location in which I want to serve docker-compose phpmyadmin:

```
# Create a symbolik link in order to serve phpmyadmin under "/mysite" location
RUN mkdir /var/www/html/mysite \
    && ln -s /var/www/html/phpmyadmin/ /var/www/html/mysite
```

In `Dockerfile` all modules required by php application need to be installed using the `docker-php-ext-install` provied inside the container. If the build fails, you need to install all the dependancies via `apt-get` as stated in [How to install more PHP extensions](https://github.com/docker-library/docs/tree/master/php#how-to-install-more-php-extensions)

In the `config.inc.php` there are parameter configuration in order to work with phpmyadmin. You may want to change the name of `$cfg['Servers'][$i]['verbose']` variable, in order to set the name of your project database name. The default database used by phpmyadmin control user is `phpmyadmin`. You can change the control user credential, if you prefer. Next you have to add phpmyadmin control user to your database, grant him his privileges and create phpmyadmin database and tables. Build the php volume for phpmyadmin:

```sh
$ docker-compose build php
```

You now have an image, like the others with <project_name> as a prefix. You can see the exact name using `docker images | head`. Create a data-volume and then link it to a MySQL client image in order to do all stuff. You need to create a control user with the same credential specified in `config.inc.php`:

```sh
$ docker create --name phpmyadmin_volume <project_name>_php /bin/true
$ docker run -it --link <mysql_running_container>:mysql --volumes-from phpmyadmin_volume --rm mysql /bin/bash

# inside the running container. The $MYSQL_ROOT_PASSWORD is not set when using /bin/bash !!!

$ cd /var/www/html/phpmyadmin/sql
$ mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"my-secret-pw"
mysql> CREATE DATABASE phpmyadmin;
mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON phpmyadmin.* TO 'pma'@'%'  IDENTIFIED BY 'pmapass';
mysql> \. create_tables.sql
mysql> exit
$ exit

# clear unnecessary volumes
$ docker rm phpmyadmin_volume
```

## Create NGINX container

Let's take a look inside nginx directory:

```sh
$ tree nginx/
nginx/
├── Dockerfile
├── mysite_nginx.conf
└── nginx.conf
```

The `nginx.conf` contains general configuration for NGINX. If you need to run different processes or listen for a different number of connection, you may modify this file. The `mysite_nginx.conf` is the file which need to be modified accordingly to your project location. You can rename that file, but remember to fix the appropriate filename in `Dockerfile`. In this sample configuration, the served application is supposed to be under `mysite` location. Django static files are served via nginx by sharing volumes between django `web` container. Alos phpmyadmin `php` static files, like documentation, are served through docker volumes defined in `docker-compose.yml`. This container expose the standard 80 port outside.

## Starting containers with docker compose

The `nginx` container expose the default 80 port to the outside. You may modify the `docker-compose.yml` to expose the internal 80 to a HOST port. This will facilitate the access to the django service via proxi pass using the HOST webserver. An example of NGINX location for the HOST is placed in `host-mysite.conf`. Remember to fix location and port accordingly to your application. Now start database and django (in daemonized mode):

```sh
$ docker-compose up -d
```
You can inspect docker logs with

```sh
$ docker-compose logs
```
Container could be stopped and restarted via `docker-compose` compose. Even if container are dropped, all files in *data volumes* directories remains and don't need to be reconfigure as the first instance. You can also run management commands with Docker. To migrate django database, for example, you can run:

```sh
$ docker-compose run web python mysite/manage.py syncdb
```

## Serving docker containers in docker HOST

You can serve docker compose using HOST NGINX, for instance, via proxy_pass. Place the followin code inside NGINX server environment. Remember to specify the port exported by your docker NGINX instance:

```
location /mysite {
    # Subitting a request to docker service
    proxy_pass http://localhost:10080;
    proxy_redirect http://localhost:10080/ $scheme://$http_host/;
}
```
