
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
done by copying the domain.crt file to `/etc/docker/certs.d/<common_name>:5000/ca.crt`.

When using authentication, some versions of docker also require you to trust the certificate at the OS level, Usually, on Ubuntu this is done with:

```bash
$ cp auth/domain.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt
$ update-ca-certificates
```

and on RedHat with:

```bash
$ cp auth/domain.crt /etc/pki/ca-trust/source/anchors/myregistrydomain.com.crt
$ update-ca-trust
```

Remeber to restart docker service, in order that registry works correctly. More information
could be found [here][docker-insecure]

Testing Docker Registry
-----------------------

Pull (or build) some image from the hub

```bash
$ docker pull ubuntu
```

Tag the image so that it points to your registry

```bash
$ docker tag ubuntu localhost:5000/myfirstimage
```

Push it:

```bash
$ docker push localhost:5000/myfirstimage
```

Pull it back

```bash
$ docker pull localhost:5000/myfirstimage
```


Todo
----

rimuovi /home/paolo/.docker/config.json

togliere certificati

cp auth/domain.crt /usr/local/share/ca-certificates/myregistrydomain.com.crt
update-ca-certificates


<!-- References -->

[docker-registry]: https://docs.docker.com/registry/
[docker-insecure]: https://docs.docker.com/registry/insecure/
