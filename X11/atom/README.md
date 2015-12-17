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

## Check that modules works correctly

ReStructured Text module need to be rebuild in this Atom distribution in order to
work properly. Open the `Incompatible Packages` tab, and the rebuild rst-preview.
You have to `Reload Atom` in order to activate the rebuilded module.
