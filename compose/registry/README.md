
Deploying a Docker Registry
===========================

The Docker Registry is a stateless, highly scalable server side application that
stores and lets you distribute Docker images. You should use the Registry if you want to:

* tightly control where your images are being stored
* fully own your images distribution pipeline
* integrate image storage and distribution tightly into your in-house development workflow

More information could be found [here][docker-registry].

Using self-signed certificates
------------------------------

Generate your own certificate:

```
$ mkdir -p certs && openssl req \
>   -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
>   -x509 -days 365 -out certs/domain.crt
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
done by copying the domain.crt file to `/etc/docker/certs.d/cloud1.bioinformatics.tecnoparco.org:5000/ca.crt`.

When using authentication, some versions of docker also require you to trust the
certificate at the OS level, Usually, on Ubuntu this is done with:

```bash
$ cp auth/domain.crt /usr/local/share/ca-certificates/cloud1.bioinformatics.tecnoparco.org.crt
$ update-ca-certificates
```

and on RedHat with:

```bash
$ cp auth/domain.crt /etc/pki/ca-trust/source/anchors/cloud1.bioinformatics.tecnoparco.org.crt
$ update-ca-trust
```

Remeber to restart docker service, in order that registry works correctly. More information
could be found [here][docker-insecure]

Restricting access
------------------

Except for registries running on secure local networks, registries should always
implement access restrictions. The simplest way to achieve access restriction is
through basic authentication (this is very similar to other web servers’ basic
authentication mechanism):

*Warning: You cannot use authentication with an insecure registry. You have to configure TLS first for this to work.*

First create a password file with one entry for the user `testuser`, with password
`testpassword`:

```bash
$ mkdir auth
$ docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd
```

Make sure you stopped your registry from the previous step, then start it again.
You should now be able to:

```bash
$ docker login cloud1.bioinformatics.tecnoparco.org:5000
```

And then push and pull images as an authenticated user. More information could be
found [here][docker-basic-auth]

Starting Docker Registry
------------------------

You can then start your registry with a simple

```bash
$ docker-compose up -d
```

Testing Docker Registry
-----------------------

Pull (or build) some image from the hub

```bash
$ docker pull ubuntu
```

Tag the image so that it points to your registry

```bash
$ docker tag ubuntu cloud1.bioinformatics.tecnoparco.org:5000/myfirstimage
```

Push it:

```bash
$ docker push cloud1.bioinformatics.tecnoparco.org:5000/myfirstimage
```

Pull it back

```bash
$ docker pull cloud1.bioinformatics.tecnoparco.org:5000/myfirstimage
```

<!-- References -->

[docker-registry]: https://docs.docker.com/registry/
[docker-insecure]: https://docs.docker.com/registry/insecure/
[docker-basic-auth]: https://docs.docker.com/registry/deploying/#native-basic-auth
