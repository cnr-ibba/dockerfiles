
Running a gbrowse render farm using docker-compose
==================================================

This tutorial explain how to start a gbrowse render farm using docker compose.
Several `gbrowse-slave` processes could be instantiated by scaling the same
composed instance, `haproxy` will deal with new slaves added to render farm. For
a brief tutotal with `haproxy` see [How to scale Docker Containers with Docker-Compose][scale-tutorial]

[scale-tutorial]: https://www.brianchristner.io/how-to-scale-a-docker-container-with-docker-compose/

Before start
============

Build images
------------

Build images to instantiate containers:

```
$ docker-compose build
```

Instantiate a gbrowse volume
----------------------------

First of all, we need to create a persistent volume for gbrowse data. We can instantiate
a container and copy data to a volume. Start from the base gbrowse image:

```
$ docker run -ti --rm --volume "$PWD/gbrowse-data:/data" gbrowse_gbrowse /bin/bash
```

Then copy all gbrowse2 database data in `/data` directory. Then exit container:

```
$ cp -ra /var/lib/gbrowse2/databases/* /data/
$ chown www-data.www-data /data/
$ exit
```

Create user account database
----------------------------

Now open a gbrowse session and create login tables with `gbrowse_metadb_config.pl`:

```
$ docker-compose run --no-deps --rm gbrowse /bin/bash
# gbrowse_metadb_config.pl
# exit
```

More info could be found [here][gbrowse-authentication]

[gbrowse-authentication]: http://gmod.org/wiki/GBrowse_Configuration/Authentication#GBrowse_Authentication_via_its_Built-in_User_Account_Database

## Restrict gbrowse to valid users

Launch a gbrowse instance ad create a new user with the following command:

```
$ docker-compose run --no-deps --rm gbrowse /bin/bash
# gbrowse_create_account.pl -pass test -fullname test test
# exit
```

Then add this to `GENERAL` gbrowse configuration file:

```
# Restrict access to registered user
restrict = require valid-user
```

More info on authentication could be found [here][gbrowse-add-user]

[gbrowse-add-user]: http://gmod.org/wiki/GBrowse_Configuration/Authentication#Adding_User_Accounts

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
$ docker-compose run --no-deps --rm gbrowse /bin/bash
```

Then you could copy files like this:

```
$ cd /var/lib/gbrowse2/databases
$ mkdir volvox
$ cd /var/www/html/gbrowse2/tutorial/
$ cp -ra data_files/* /var/lib/gbrowse2/databases/volvox/
$ cd /var/lib/gbrowse2/databases
$ chown -R www-data.www-data volvox
```

[gbrowse-admin-tutorial]: http://cloud.gmod.org/gbrowse2/tutorial/tutorial.html

Configuring gbrowse_syn
-----------------------

### Create a MySQL database

Connect to a MySQL instance and create `rice_synteny` database:

```
$ docker-compose run --no-deps --rm db mysql -h db -u root --password=my-secret-pw
mysql> CREATE USER gbrowsero IDENTIFIED BY 'gbrowseropass' ;
mysql> CREATE DATABASE rice_synteny ;
mysql> GRANT SELECT ON rice_synteny.* TO gbrowsero@'%';
mysql> exit
```

### Load alignment into database

Launch a gbrowse container:

```
$ docker-compose run --no-deps --rm gbrowse /bin/bash
$ cd /var/lib/gbrowse2/databases/gbrowse_syn/alignments
$ gzip -d rice.aln.gz
$ /usr/local/bin/gbrowse_syn_load_alignments_msa.pl -u root -p my-secret-pw --dsn='dbi:mysql:database=rice_synteny;host=db' -f clustalw -v -c rice.aln
$ gzip --best rice.aln
```

Then reach `gbrowse_syn` from this [link][local-gbrowse_syn]. More information on
`gbrowse_syn` could be found [here][gbrowse_syn] and [here][gbrowse_syn_help]. More information on loading alignments
and `gbrowse_syn` scripts in general could be found [here][gbrowse_syn-script]

[local-gbrowse_syn]: http://localhost:10080/gb2/gbrowse_syn/
[gbrowse_syn]: http://gmod.org/wiki/GBrowse_syn
[gbrowse_syn_help]: http://gmod.org/wiki/GBrowse_syn_Help
[gbrowse_syn-script]: http://gmod.org/wiki/GBrowse_syn_Script
