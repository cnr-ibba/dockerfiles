
# Running Django+MySQL-uwsgi with docker-compose

This guide describe how to build and run Django+MySQL with docker-compose. First of all
copy this directory in another location since you will modify code in order to
develop your application. Next, rename the whole directory with a project name.
In this example, project is set to `mysite`. Replace all `mysite` occurrences with your
project name.
In this project there are directories that will be mounted as data volume:
this will make easier to
develop the code or re-spawn the docker application on another location using the same
volume directory. For example, all MySQL
data files will be placed in `mysql-data` directory and all django data
will be placed in `django-data` directory inside this project. When such directories are
created for the first time, there are created and mounted as a root directories. After
permission can be fixed according user need. For example processes like `nginx`
and `uswgi` work with a different user from root, and so files need to be accessed
at least in read mode

## The docker-compose.yml file

Before to start take a look in the `docker-compose.yml` file. This is the
configuration file used by `docker-compose` commands. All `docker-compose`
commands need to be instantiated in this directory or by specifying the path of
`docker-compose.yml` file, as stated by the [docker compose documentation](https://docs.docker.com/compose/).
For such compose project, 3 containers will be instantiated:

1. `db`: This is the container of *mariadb* server. This container will
   listen for `uwsgi` django container
2. `uwsgi`: this is the django container in which uwsgi server will run.
   This container will be linked with `db` container
3. `nginx`: this container has nginx installed. All static files will be
    served by nginx by sharing static content as docker volumes between containers.
    Django files will be served by the appropriate container via uwsgi nginx plugin.

Those name will be placed in the `/etc/hosts` file in each container, so you can ping
`uwsgi` host inside `nginx` container, for instance, no matter what ip addresses
will be given to the container by docker. When starting this project for the first
time, data directory and initial configuration have to be defined. Data
directories will be placed inside this project directory, in order to facilitate
`docker-compose` commands once docker images where configured for the
application. When data directories are created for the first time, the
ownership of such directories is the same of the service running in the
container. You can change it according your needs, but remember that services
run under a *non privileged* user, so you have to define **at least** the *read* privileged for files, and the *read-execute* privileges for directories.

## Setting up *.env* variables

You can set variables like password and users using
[environment variables](https://docs.docker.com/compose/environment-variables/)
that could be passed on runtime or by *env files*. The default *env file* is a `.env`
file placed inside django docker-composed root directory. This file **MUSTN'T** be
tracked using *CVS*

> You should also store sensitive informations using [docker secrets](https://docs.docker.com/v17.12/engine/swarm/secrets/)

Create a `.env` file inside project directory, and set the following variables:

```txt
DEBUG=True
MYSQL_ROOT_PASSWORD=<mysql password>
SECRET_KEY=<your django secret key>
MYSQL_DATABASE=<django database name>
MYSQL_USER=<django user>
MYSQL_PASSWORD=<django password>
```

## Create the MySQL container

In order to download and start the MySQL container for the first time, simply
type:

```bash
docker-compose up -d db
```

Once `db` container is instantiated for the first time, `mysql-data` directory is created
and MySQL is configured to have users and password as described in the `.env` file.
After that, container could be destroyed and data will persists inside `mysql-data`
directory. If you need extra stuff to be done after database creation, you could
define *sql* and *sh* scripts inside a directory that need to be mounted in
`/docker-entrypoint-initdb.d/` as in the following example:

```yml
# to export volume, as recommeded in https://registry.hub.docker.com/u/library/mysql/
volumes:
  - type: bind
    source: ./mysql-data/
    target: /var/lib/mysql

  - type: bind
    source: ./mysql-initdb/
    target: /docker-entrypoint-initdb.d/
    read_only: true
```

Each script inside `/docker-entrypoint-initdb.d/` directory will be executed after
database creation. Once database is created, those scripts will not be executed
anymore.

The MySQL container defined in `docker-compose.yml` never expose a port outside,
but you may want to expose it to access data with a MySQL client.
You can get a mysql client to this container using a db container, for instance:

```bash
docker-compose run --rm db sh -c 'mysql -h db --password="${MYSQL_ROOT_PASSWORD}"'
```

### Dumping data from database

With the docker run command, you can do a `mysite` database dump:

```bash
docker-compose run --rm db /bin/sh -c 'mysqldump -h db -u root --password=$MYSQL_ROOT_PASSWORD mysite' > dump.sql
```

### Loading data in database

With the docker run command, you can import a `.sql` file by adding its path as
a docker volume, for instance, if you are in `mysite_dump.sql` directory:

```bash
cat dump.sql | docker-compose run --rm db /bin/sh -c 'mysql -h db -u root --password=$MYSQL_ROOT_PASSWORD mysite'
```

### Access database using adminer

You can access to mysql container using adminer, you need to connect to
docker composed instance using the same network, for example:

```bash
docker run -d --link django-db-1:db -p 8080:8080 --name adminer --network django_default adminer
```

More information could be found in [adminer - docker hub][adminer-docker-documentation]

[adminer-docker-documentation]: https://hub.docker.com/_/adminer/

## Create django container

Django will be served using the uwsgi server. Dependencies are managed by poetry
using the two files `pyproject.toml` and `poetry.lock`, which are tracked at the
root level of this project folder: in order to correctly add these two files to
your django container, the project root directory is added to the build
context (see [context](https://docs.docker.com/compose/compose-file/compose-file-v3/#context)
in `docker-compose` documentation). To build the django container simply type:

```bash
docker-compose build uwsgi
```

You can get more information here:

* [How to use Django with uWSGI](https://docs.djangoproject.com/en/4.1/howto/deployment/wsgi/uwsgi/)
* [Django and NGINX](https://uwsgi.readthedocs.org/en/latest/tutorials/Django_and_nginx.html)
* [uwsgi configuration](https://uwsgi.readthedocs.org/en/latest/Configuration.html)

### Manage dependencies

The simplest way to manage dependencies is to manage them using poetry: simply
add a new dependency with:

```bash
poetry add <dependency>
```

Then update the `poetry.lock` using:

```bash
poetry install
```

This will install your packages in your local environment (not inside the docker
container!). To update your local container you have to build again with:

```bash
docker-compose build uwsgi
```

Please see [Managing dependencies](https://python-poetry.org/docs/managing-dependencies/)
in poetry documentation to have more information.

> TODO: manage dependencies using docker containers

### Creating a project for the first time

For such example, we suppose that the django project name will be `mysite` as stated
by the [django tutorial](https://docs.djangoproject.com/en/1.11/intro/tutorial01/#creating-a-project).
The `mysite_uwsgi.ini` in `django-data` directory contains uwsgi configuration for this application.
The default path of the application is the `mysite` directory of the django tutorial.
If you want to modify the project directories, remember to modify `docker-compose.yml`
and to rename `mysite_uwsgi.ini`commands according your needs.
First, you need to generate an empty django project (`mysite` in this example),
since it's no tracked with this project. If you want to track your project
modifications, you will do add manually your django folder to your project.
To create a new project folder, we will use the `django-admin` utility from
the django container. This will create a new project folder in  `/var/uwsgi/`,
which is an exported volume of `django-data` folder of this project:

```bash
docker-compose run --rm uwsgi django-admin startproject mysite
```

This will build the django image and runs the `django-admin` script. If there
are prerequisites, for example containers linked to that, they will be started before
the `uwsgi` django container. After that, the container stops and we return to the
shell environment. You may want to fix file permissions in order to edit files, for
example:

```bash
sudo chown -R ${USER}:www-data django-data
```

Next, you may need to set a list of strings representing the host/domain
names that this Django site can serve: you will modify the `ALLOWED_HOSTS`
as described [here][django-allowed-host]. To avoid to store sensitive information
inside `settings.py`, you may want to refer to [python-decouple](https://github.com/henriquebastos/python-decouple)
documentation. With this module, you can store sensitive information as
environment variables or in another `.env` file that need to be placed in the
sample directory of `settings.py`

[django-allowed-host]: https://docs.djangoproject.com/en/1.11/ref/settings/#allowed-hosts

```python

from decouple import config

# ... other stuff

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = config('DEBUG', cast=bool, default=False)

ALLOWED_HOSTS = ['*']
```

Now we need to set up the database connection. You may want
change default ownership to edit files. Replace the `DATABASES = ...` definition
in `django-data/mysite/mysite/settings.py` accordingly your project database settings:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': config('MYSITE_DATABASE'),
        'USER': config('MYSITE_USER'),
        'PASSWORD': config('MYSITE_PASSWORD'),
        'HOST': 'db',
        'PORT': 3306,
        'OPTIONS': {
            'init_command': "SET sql_mode='STRICT_TRANS_TABLES'",
        },
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
# https://docs.djangoproject.com/en/4.1/howto/static-files/
STATIC_URL = '/mysite/static/'
MEDIA_URL  = '/mysite/media/'

# collect all Django static files in the static folder
STATIC_ROOT = BASE_DIR / "static"
MEDIA_ROOT = BASE_DIR / "media"
```

The `STATIC_URL` variable will tell to django (uwsgi) how to define links to static
files, and the `STATIC_ROOT` variable will set the position in which static files
(as the admin .css files) will be placed. The `MEDIA_ROOT` and `MEDIA_URL` variables
have the same behavior. You may want to create a `/static` and `/media`
directory inside `mysite`, in order to place media files. Then you have to call
the `collectstatic` command in order to place the static files in their directories:

```bash
mkdir django-data/mysite/static/
mkdir django-data/mysite/media/
docker-compose run --rm uwsgi python mysite/manage.py collectstatic
```

#### Auto restart uwsgi when code is modified

As stated [here](http://uwsgi-docs.readthedocs.io/en/latest/ThingsToKnow.html?highlight=autoreload)
autoreload could be CPU intensive and must be used only in developmente environment:
*"Some plugins (most notably Python and Perl) have code auto-reloading facilities.
Although they might sound very appealing, you MUST use them only under development
as they are really heavy-weight. For example the Python –py-autoreload option will
scan your whole module tree at every check cycle."*

#### Change working_dir in docker compose file

To avoid the necessity of specify relative path every time `manage.py` is called,
you may want to change the working_directory in `docker-compose.yml` file to point
on your application directory, for example:

```yaml
  # set working dir for uwsgi
  working_dir: /var/uwsgi/mysite
```

This allows to call `manage.py` without specifying the `mysite` project directory.

#### Initialize django database for the first time

You may want to run the following commands to create the necessary django tables
if django database is empty. The path of `manage.py` is not specified, since we
changed the `working_dir` in `docker-compose.yml`:

```bash
docker-compose run --rm uwsgi python manage.py migrate
```

More info could be found [here](https://docs.djangoproject.com/en/4.1/intro/tutorial02/#database-setup)

#### Creating an admin user

You  need to create a user who can login to the admin site. Run the following command:

```bash
docker-compose run --rm uwsgi python manage.py createsuperuser
```

A user and password for the admin user will be prompted. Ensure to track such
credentials

## Create NGINX container

Let's take a look inside nginx directory:

```sh
$ tree nginx
nginx/
├── conf.d
│   └── default.conf
├── Dockerfile
└── nginx.conf
```

The `nginx.conf` contains general configuration for NGINX. If you need to run d
different processes or listen for a different number of connection, you may modify
this file. The `default.conf` located in `conf.d` is the file which need to be modified
accordingly to your project location. You can modify this file without building
nginx image, since this directory is imported as a volume in nginx container.
In this sample configuration, the served application is supposed to be under `mysite`
location. Django static files are served via nginx by sharing volumes between
django `uwsgi` container. This container expose the standard 80 port outside, but
`docker-compose.yml` could bind this port to a different one

## Starting containers with docker compose

Now start database and django (in daemonized mode):

```bash
docker-compose up -d
```

You can inspect docker logs with

```bash
docker-compose logs
```

Container could be stopped and restarted via `docker-compose` compose. Even if
container are dropped, all files in *data volumes* directories remains and don't
need to be reconfigured as the first instance. You can also run management commands
with Docker. To migrate django database, for example, you can run:

```bash
docker-compose run --rm uwsgi python mysite/manage.py migrate
```

Or

```bash
docker-compose run --rm uwsgi python manage.py migrate
```

If you have set the `working_dir` in `docker-compose.yml` properly.

## Serving docker containers in docker HOST

You can serve docker compose using HOST NGINX, for instance, via proxy_pass.
Place the followin code inside NGINX server environment. Remember to specify the
port exported by your docker NGINX instance:

```conf
location /mysite/ {
  # set variable in location
  set $my_port 10080;

  # Add info to webpages
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Host $host:$my_port;
  proxy_set_header X-Forwarded-Server $host;
  proxy_set_header X-Forwarded-Port $my_port;
  proxy_set_header X-Forwarded-Proto $scheme;
  proxy_pass_header Set-Cookie;

  # Subitting a request to docker service
  proxy_pass http://<your_host>:$my_port;
  proxy_redirect http://$host:$my_port/ $scheme://$http_host/;
}
```
