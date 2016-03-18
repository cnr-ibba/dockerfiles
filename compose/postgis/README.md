

Creating a postgis composed image
==========================================

Download and build the images
-----------------------------

Take a look at `docker-compose.yml` for ports to expose. We are using a custom image
which install the [postgis](http://postgis.net/install/) extensions on top of postgres 9.3.
Check the `postgres` password in `docker-compose.yml`, then build the images and create
the container for the first time:

```
$ docker-compose up -d
```

Database dump
-------------

In order to dump database, create a postgis container and  link them to database instance:

```
$ docker run -it --volume $PWD/dump:/data --link postgis_db_1:postgres --rm mdillon/postgis:9.3 /bin/bash
```

Then, once inside a container dump the climgen database:

```
$ cd /data/
$ export PGPASSWORD="mysecretpassword"
$ pg_dump --username=postgres -h postgres -d postgres | gzip --best >  postgres.sql.gz
```
