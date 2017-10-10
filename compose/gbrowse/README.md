
Running a gbrowse render farm using docker-compose
==================================================

This tutorial explain how to start a gbrowse render farm using docker compose.
Several `gbrowse-slave` processes could be instantiated by scaling the same
composed instance, `haproxy` will deal with new slaves added to render farm. For
a brief tutotal with `haproxy` see [How to scale Docker Containers with Docker-Compose][scale-tutorial]

[scale-tutorial]: https://www.brianchristner.io/how-to-scale-a-docker-container-with-docker-compose/

Instantiate a gbrowse volume
----------------------------

First of all, we need to create a persisten volume for gbrowse data. We can instantiate
a container and copy data to a volume. Start from the base gbrowse image:

```
$ docker run -it --rm --volume "$PWD/gbrowse-data:/data" comics/gbrowse bash
```

Then copy all gbrowse2 database data in `/data` directory. Then exit container:

```
$ cp -ra /var/lib/gbrowse2/databases/* /data/
$ exit
```

Launch gbrowse with docker-compose
----------------------------------

After volume creation, start gbrowse with `docker-compose` (all volume data are
relative to this directory):

```
$ docker-compose up -d
```

You can accesso gbrowse home page from http://localhost:10080/gbrowse2/

Scale gbrowse-slave services
----------------------------

To scale up `gbrowse-slave` service, simply type:

```
$ docker-compose scale gbrowse-slave=3
```
