
Deploying a Docker Registry
===========================

The Docker Registry is a stateless, highly scalable server side application that
stores and lets you distribute Docker images. You should use the Registry if you want to:

* tightly control where your images are being stored
* fully own your images distribution pipeline
* integrate image storage and distribution tightly into your in-house development workflow

More information could be found [here][docker-registry]. A nice example on deploying
a private docker registry server/client could be found [here][private-docker-registry].
Others info on private docker configuration could be found [here][private-docker-registry-configuration].

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

Remember to restart docker service, in order that registry works correctly. More information
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
$ docker run --entrypoint htpasswd httpd:2.4 -bn testuser testpassword > auth/nginx.htpasswd
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
found [here][docker-basic-auth]. For information on authentication using NGINX, see
[here][docker-nginx-authentication].

Starting Docker Registry
------------------------

You can then start your registry with a simple

```
$ docker-compose up -d
```

Serving registry using System NGINX
-----------------------------------

By default, NGINX can load config files in two ways:

```
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

```

The first include (`/etc/nginx/conf.d/`) it's outside the main server directive, while
the second include (`/etc/nginx/default.d/`) it's inside the sever directory. So,
the configuration loaded may be general or can declare another server directory in
`/etc/nginx/conf.d/`, while in `/etc/nginx/default.d/` we can declare directive internal
to server, like location. We can define a new server directive, which listen from
port 443 and serve docker registry as a proxy. Simple include those line in `/etc/nginx/conf.d/registry.ptp.conf`:

```
server {
  listen 443;
  server_name registry.ptp;
  ssl on;
  ssl_certificate /etc/nginx/conf.d/registry.ptp/domain.crt;
  ssl_certificate_key /etc/nginx/conf.d/registry.ptp/domain.key;

  location / {
    # disable any limits to avoid HTTP 413 for large image uploads
    client_max_body_size 0;

    # required to avoid HTTP 411: see Issue #1486 (https://github.com/docker/docker/issues/1486)
    chunked_transfer_encoding on;

    # Add info to webpages
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_pass_header Set-Cookie;

    # Subitting a request to docker service
    proxy_pass https://registry.ptp:5000;
    proxy_redirect $scheme://$host:5000/ $scheme://$http_host/;
  }
}
```

Since we have `registry.ptp` in `/etc/hosts`, we can login to docker registry server
whitout specifing a port number, eg:

```
$ docker login registry.ptp                                                                                                       
Username (testuser):
WARNING: login credentials saved in /home/paolo/.docker/config.json
Login Succeeded
```

Useful links could be found [here][supervisor-and-nginx] and [here][nginx-proxy-examples].

Testing Docker Registry
-----------------------

### Test authentication

Testing login credential using `curl`. Test without authentication (the -k option is
required if certificate is untrusted at OS level):

```
$ curl -v -k https://registry.ptp/v2/_catalog
* Hostname was NOT found in DNS cache
*   Trying 127.0.0.1...
* Connected to registry.ptp (127.0.0.1) port 5000 (#0)
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* SSLv3, TLS handshake, Client hello (1):
* SSLv3, TLS handshake, Server hello (2):
* SSLv3, TLS handshake, CERT (11):
* SSLv3, TLS handshake, Server key exchange (12):
* SSLv3, TLS handshake, Server finished (14):
* SSLv3, TLS handshake, Client key exchange (16):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* Server certificate:
*        subject: C=IT; ST=Lodi; L=Lodi; O=PTP; OU=bioinformatica; CN=registry.ptp; emailAddress=bioinfo.notifications@tecnoparco.org
*        start date: 2016-01-15 09:40:46 GMT
*        expire date: 2021-01-13 09:40:46 GMT
*        issuer: C=IT; ST=Lodi; L=Lodi; O=PTP; OU=bioinformatica; CN=registry.ptp; emailAddress=bioinfo.notifications@tecnoparco.org
*        SSL certificate verify ok.
> GET /v2/_catalog HTTP/1.1
> User-Agent: curl/7.38.0
> Host: registry.ptp
> Accept: */*
>
< HTTP/1.1 401 Unauthorized
* Server nginx/1.9.9 is not blacklisted
< Server: nginx/1.9.9
< Date: Fri, 15 Jan 2016 15:27:28 GMT
< Content-Type: text/html
< Content-Length: 194
< Connection: keep-alive
< WWW-Authenticate: Basic realm="Registry realm"
< Docker-Distribution-Api-Version: registry/2.0
<
<html>
<head><title>401 Authorization Required</title></head>
<body bgcolor="white">
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx/1.9.9</center>
</body>
</html>
* Connection #0 to host registry.ptp left intact
```

Then test using `testuser:testpassword` credential:

```
$ curl -v -k https://testuser:testpassword@registry.ptp/v2/_catalog
* Hostname was NOT found in DNS cache
*   Trying 127.0.0.1...
* Connected to registry.ptp (127.0.0.1) port 5000 (#0)
* successfully set certificate verify locations:
*   CAfile: none
  CApath: /etc/ssl/certs
* SSLv3, TLS handshake, Client hello (1):
* SSLv3, TLS handshake, Server hello (2):
* SSLv3, TLS handshake, CERT (11):
* SSLv3, TLS handshake, Server key exchange (12):
* SSLv3, TLS handshake, Server finished (14):
* SSLv3, TLS handshake, Client key exchange (16):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSLv3, TLS change cipher, Client hello (1):
* SSLv3, TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* Server certificate:
*        subject: C=IT; ST=Lodi; L=Lodi; O=PTP; OU=bioinformatica; CN=registry.ptp; emailAddress=bioinfo.notifications@tecnoparco.org
*        start date: 2016-01-15 09:40:46 GMT
*        expire date: 2021-01-13 09:40:46 GMT
*        issuer: C=IT; ST=Lodi; L=Lodi; O=PTP; OU=bioinformatica; CN=registry.ptp; emailAddress=bioinfo.notifications@tecnoparco.org
*        SSL certificate verify ok.
* Server auth using Basic with user 'testuser'
> GET /v2/_catalog HTTP/1.1
> Authorization: Basic dGVzdHVzZXI6dGVzdHBhc3N3b3Jk
> User-Agent: curl/7.38.0
> Host: registry.ptp
> Accept: */*
>
< HTTP/1.1 200 OK
* Server nginx/1.9.9 is not blacklisted
< Server: nginx/1.9.9
< Date: Fri, 15 Jan 2016 15:27:52 GMT
< Content-Type: application/json; charset=utf-8
< Content-Length: 34
< Connection: keep-alive
< Docker-Distribution-Api-Version: registry/2.0
< X-Content-Type-Options: nosniff
<
{"repositories":["myfirstimage"]}
* Connection #0 to host registry.ptp left intact
```

### Download and pull an image (using NGINX as proxy for docker-registry)

Pull (or build) some image from the hub

```
$ docker pull ubuntu
```

Tag the image so that it points to your registry

```
$ docker tag ubuntu registry.ptp/myfirstimage
```

Push it:

```
$ docker push registry.ptp/myfirstimage
```

Pull it back

```
$ docker pull registry.ptp/myfirstimage
```

Using docker-registry
---------------------

### Listing images

List all images in catalog (using httpie):

```
$ http https://<user>:<password>@registry.ptp/v2/_catalog
```

Getting all version for an image:

```
$ http  https://<user>:<password>@registry.ptp/v2/<image>/tags/list
```

### Deleting images using delete-docker-registry-image

Deleting an image using the latest version of [delete-docker-registry-image](delete-docker-registry-image):

```
$ sudo ./delete_docker_registry_image.py --image <image>:latest
$ sudo ./delete_docker_registry_image.py --image <image>:<tag>
```

<!-- References -->

[docker-registry]: https://docs.docker.com/registry/
[docker-insecure]: https://docs.docker.com/registry/insecure/
[docker-basic-auth]: https://docs.docker.com/registry/deploying/#native-basic-auth
[private-docker-registry]: http://blog.agilepartner.net/private-docker-registry/
[docker-nginx-authentication]: https://docs.docker.com/registry/nginx/
[private-docker-registry-configuration]: http://blog.agilepartner.net/private-docker-registry-configuration/
[supervisor-and-nginx]: https://www.kf-interactive.com/blog/roll-your-own-docker-registry-with-docker-compose-supervisor-and-nginx/
[nginx-proxy-examples]: https://github.com/kwk/docker-registry-frontend/wiki/nginx-proxy-examples
[delete-docker-registry-image]: https://github.com/burnettk/delete-docker-registry-image.git

<!-- Not used: http://blog.agilepartner.net/private-docker-registry-behind-an-httpd-reverse-proxy/ -->
