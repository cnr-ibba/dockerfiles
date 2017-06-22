
Firefox-esr image with icedtea-7 plugin
=======================================

This image enable icedtea-7 java plugin on Firefox-esr (on a host using X11).
First create a volume in order to store browser configuration, caches, etc.

```
$ docker create -v $PWD:/home/firefox --name firefox-jdk_volume ptp/firefox-jdk /bin/true
```

Then start firefox image sharing volume and host `$DISPLAY`:

```
$ docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --volumes-from firefox-jdk_volume --name firefox-jdk ptp/firefox-jdk
```

Enjoy!
