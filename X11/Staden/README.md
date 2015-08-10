
Staden package Docker Volume
===================

## Create a volume

```bash
$ docker create -v $HOME/Desktop/Staden:/home/staden/Data --name staden_data \
    ptp/staden /bin/true
```

## Run a container with X11 support

```bash
$ docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro \
    --volumes-from staden_data -e DISPLAY=$DISPLAY --name staden ptp/staden
```

## Let's connect to X server from any hosts

```bash
$ xhost +
```
