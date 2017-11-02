
Running a gbrowse render farm using docker-compose
==================================================

This tutorial explain how to start a gbrowse render farm using docker compose.
Several `gbrowse-slave` processes could be instantiated by scaling the same
composed instance, `haproxy` will deal with new slaves added to render farm. For
a brief tutotal with `haproxy` see [How to scale Docker Containers with Docker-Compose][scale-tutorial]

[scale-tutorial]: https://www.brianchristner.io/how-to-scale-a-docker-container-with-docker-compose/

Instantiate a gbrowse volume
----------------------------

First of all, we need to create a persistent volume for gbrowse data. We can instantiate
a container and copy data to a volume. Start from the base gbrowse image:

```
$ docker-compose run --rm --no-deps --volume "$PWD/gbrowse-data:/data" gbrowse /bin/bash
```

Then copy all gbrowse2 database data in `/data` directory. Then exit container:

```
$ cp -ra /var/lib/gbrowse2/databases/* /data/
$ exit
```

Create user account database
----------------------------



Launch gbrowse with docker-compose
----------------------------------

After volume creation, start gbrowse with `docker-compose` (all volume data are
relative to this directory):

```
$ docker-compose up -d
```

You can accesso gbrowse home page from http://localhost:10080/gbrowse2/

### Scale gbrowse-slave services

To scale up `gbrowse-slave` service, simply type:

```
$ docker-compose scale gbrowse-slave=3
```

Running tutorial
----------------

Those are instructions for running volvox database described in [gbrowse admin tutorial][gbrowse-admin-tutorial].
To enable this database, you need to copy example data files in gbrowse database
directory. You can do this by running gbrowse container:

```
$ docker-compose run --no-deps gbrowse /bin/bash
```

Then you could copy files like this:

```
$ cd /var/lib/gbrowse2/databases
$ mkdir volvox
$ chmod go+rwx volvox
$ cd /var/www/html/gbrowse2/tutorial/
$ cp data_files/* /var/lib/gbrowse2/databases/volvox/
$ cp volvox_final.conf /etc/gbrowse2/volvox.conf
```

[gbrowse-admin-tutorial]: http://cloud.gmod.org/gbrowse2/tutorial/tutorial.html
