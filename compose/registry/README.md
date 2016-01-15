
Deploying a Docker Registry
===========================

The Docker Registry is a stateless, highly scalable server side application that
stores and lets you distribute Docker images. You should use the Registry if you want to:

* tightly control where your images are being stored
* fully own your images distribution pipeline
* integrate image storage and distribution tightly into your in-house development workflow

More information could be found [here][docker-registry]. A nice example on deploying
a private docker registry server/client could be found [here][private-docker-registry].

Using self-signed certificates
------------------------------

In an private networks, verify that domain names are correctly resolved, for instance
update `/etc/host` in order to resolve domain names:

```
$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
192.168.13.7 cloud1.bioinformatics.tecnoparco.org cloud1
192.168.13.7 registry.ptp
```

The `registry.ptp` must be resolved in every host in which registry needs to be reached.
Generate your own certificate:

```
$ mkdir -p certs && openssl req \
   -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
   -x509 -days 1825 -out certs/domain.crt
Generating a 4096 bit RSA private key
.........++
...................................................................................................++
writing new private key to 'certs/domain.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [XX]:IT
State or Province Name (full name) []:Lodi
Locality Name (eg, city) [Default City]:Lodi
Organization Name (eg, company) [Default Company Ltd]:PTP
Organizational Unit Name (eg, section) []:bioinformatica
Common Name (eg, your name or your server's hostname) []:cloud1.bioinformatics.tecnoparco.org
Email Address []:
```

Then you have to instruct every docker daemon to trust that certificate. This is
done by copying the domain.crt file to `/etc/docker/certs.d/registry.ptp:5000/ca.crt`:

```
$ mkdir /etc/docker/certs.d/registry.ptp:5000/
$ cp certs/domain.crt /etc/docker/certs.d/registry.ptp:5000/ca.crt
```

When using authentication, some versions of docker also require you to trust the
certificate at the OS level; If you want to test registry service with another software
than docker (ex. curl), you have to trust certificate at system livel, usually, on
Ubuntu this is done with:

```
$ cp certs/domain.crt /usr/local/share/ca-certificates/registry.ptp.crt
$ update-ca-certificates
```

and on RedHat with:

```
$ cp certs/domain.crt /etc/pki/ca-trust/source/anchors/registry.ptp.crt
$ update-ca-trust
```

Remeber to restart docker service, in order that registry works correctly. More information
could be found [here][docker-insecure]. The same certificate MUST be copied in all
docker host in which registry needs to be reached.

Restricting access
------------------

Except for registries running on secure local networks, registries should always
implement access restrictions. The simplest way to achieve access restriction is
through basic authentication (this is very similar to other web servers’ basic
authentication mechanism):

*Warning: You cannot use authentication with an insecure registry. You have to configure TLS first for this to work.*

First create a password file with one entry for the user `testuser`, with password
`testpassword`:

```
$ mkdir auth
$ docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
```

Now you can start docker registry server. Using docker-compose you can do:

```
$ docker-compose up
```

You should now be able to:

```
$ docker login registry.ptp:5000
```

And then push and pull images as an authenticated user. More information could be
found [here][docker-basic-auth]

Starting Docker Registry
------------------------

You can then start your registry with a simple

```
$ docker-compose up -d
```

Testing Docker Registry
-----------------------

### Test authentication

Testing login credential using `curl`. Test without authentication (the -k option is
required if certificate is untrusted at OS level):

```
$ curl -v -k https://registry.ptp:5000/v2/_catalog
* About to connect() to registry.ptp port 5000 (#0)
*   Trying 192.168.13.7...
* Connected to registry.ptp (192.168.13.7) port 5000 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* SSL connection using TLS_RSA_WITH_AES_128_CBC_SHA
* Server certificate:
*       subject: E=bioinfo.notifications@tecnoparco.org,CN=registry.ptp,OU=bioinformatica,O=PTP,L=Lodi,ST=Lodi,C=IT
*       start date: gen 15 09:40:46 2016 GMT
*       expire date: gen 13 09:40:46 2021 GMT
*       common name: registry.ptp
*       issuer: E=bioinfo.notifications@tecnoparco.org,CN=registry.ptp,OU=bioinformatica,O=PTP,L=Lodi,ST=Lodi,C=IT
> GET /v2/_catalog HTTP/1.1
> User-Agent: curl/7.29.0
> Host: registry.ptp:5000
> Accept: */*
>
< HTTP/1.1 401 Unauthorized
< Content-Type: application/json; charset=utf-8
< Docker-Distribution-Api-Version: registry/2.0
< Www-Authenticate: Basic realm="Registry Realm"
< X-Content-Type-Options: nosniff
< Date: Fri, 15 Jan 2016 10:34:13 GMT
< Content-Length: 134
<
{"errors":[{"code":"UNAUTHORIZED","message":"authentication required","detail":[{"Type":"registry","Name":"catalog","Action":"*"}]}]}
* Connection #0 to host registry.ptp left intact
```

Then test using `user:password` credential:

```
$ curl -v -k https://testuser:testpassword@registry.ptp:5000/v2/_catalog
* About to connect() to registry.ptp port 5000 (#0)
*   Trying 192.168.13.7...
* Connected to registry.ptp (192.168.13.7) port 5000 (#0)
* Initializing NSS with certpath: sql:/etc/pki/nssdb
* skipping SSL peer certificate verification
* SSL connection using TLS_RSA_WITH_AES_128_CBC_SHA
* Server certificate:
*       subject: E=bioinfo.notifications@tecnoparco.org,CN=registry.ptp,OU=bioinformatica,O=PTP,L=Lodi,ST=Lodi,C=IT
*       start date: gen 15 09:40:46 2016 GMT
*       expire date: gen 13 09:40:46 2021 GMT
*       common name: registry.ptp
*       issuer: E=bioinfo.notifications@tecnoparco.org,CN=registry.ptp,OU=bioinformatica,O=PTP,L=Lodi,ST=Lodi,C=IT
* Server auth using Basic with user 'testuser'
> GET /v2/_catalog HTTP/1.1
> Authorization: Basic dGVzdHVzZXI6dGVzdHBhc3N3b3Jk
> User-Agent: curl/7.29.0
> Host: registry.ptp:5000
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Type: application/json; charset=utf-8
< Docker-Distribution-Api-Version: registry/2.0
< X-Content-Type-Options: nosniff
< Date: Fri, 15 Jan 2016 10:34:55 GMT
< Content-Length: 34
<
{"repositories":["myfirstimage"]}
* Connection #0 to host registry.ptp left intact
```

### Download an image

Pull (or build) some image from the hub

```
$ docker pull ubuntu
```

Tag the image so that it points to your registry

```
$ docker tag ubuntu registry.ptp:5000/myfirstimage
```

Push it:

```
$ docker push registry.ptp:5000/myfirstimage
```

Pull it back

```
$ docker pull registry.ptp:5000/myfirstimage
```

<!-- References -->

[docker-registry]: https://docs.docker.com/registry/
[docker-insecure]: https://docs.docker.com/registry/insecure/
[docker-basic-auth]: https://docs.docker.com/registry/deploying/#native-basic-auth
[private-docker-registry]: http://blog.agilepartner.net/private-docker-registry/
