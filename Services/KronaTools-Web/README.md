
# Start a Krona Tools Web Server Mirror

In this container image, Krona Tools 2.5 static files will be served by NGINX under /krona/ path. You have to start this container and then you can use this mirror by launching, for example, krona tools with `-u 'http://bioinformatics.tecnoparco.org/krona/'`

## Build the container and start it (with autostart)

You may want to build a new container and run it on a defined port (in ordert to be reached from services likes nginx): Change your local directory to this directory (KronaTools-Web) and then:

```sh
$ docker build --rm -t ptp/web_krona_tools .
$ docker tag ptp/web_krona_tools:latest ptp/web_krona_tools:0.1
$ docker run -d -p 20080:80 --name web_krona_tools --restart=always ptp/web_krona_tools
```

## Add a NGINX stanza to reach this docker service

Add this stanza inside NGINX server location. Please note that the PORT used is the same defined in docker container.

```
    # Krona Tools 2.5 mirror qui al PTP (http://sourceforge.net/projects/krona/)
    location /krona/ {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://192.168.13.150:20080/krona/;
    }
```
