## Docker-Atom

Docker images for [Atom](https://atom.io/) (because, why the hell not?)

        docker build -t atom .
        docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY atom

Inspired by [Jessie Frazelle](https://github.com/jfrazelle/dockerfiles/blob/master/atom/Dockerfile)

## Run docker-atom for the first time

Create a docker volume:

    $ docker create -v /home/paolo/Projects:/home/developer/Projects --name atom-volume atom /bin/true

 Run atom and bind with docker volume and system localtime:

    $ docker run -d -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro --volumes-from atom-volume -e DISPLAY=$DISPLAY --name atom atom

## Run docker-atom in already defined container

Simply type:

      $ docker start atom
