
Autobench Docker image
===============

This is a docker image based on debian jessie with [Autobench](http://www.xenoclast.org/autobench/) installed. Autobench is a simple Perl script for automating the process of benchmarking a web server (or for conducting a comparative test of two different web servers). The script is a wrapper around httperf. Autobench runs httperf a number of times against each host, increasing the number of requested connections per second on each iteration, and extracts the significant data from the httperf output, delivering a CSV or TSV format file which can be imported directly into a spreadsheet for analysis/graphing.

Also included in the autobench tarball is a short program 'crfile' that can be used to generate files of arbitrary lengths, filled with random characters.

More information can be found at [Autobench](http://www.xenoclast.org/autobench/) site or its [GitHub](https://github.com/menavaur/Autobench) site

## Building the image

Simply type

```bash
$ docker build --rm -t ptp/autobench .
$ docker tag ptp/autobench:latest ptp/autobench:0.1
```

in this directory.

## Usage

Launch a docker instance exporting a volume:

```bash
$ docker run -ti --name autobench --volume $PWD:/data ptp/autobench:latest /bin/bash
```

Once inside the container, launch autobench with:

```bash
$ autobench --single_host --host1 192.168.13.7 --uri1 /blog/index.php --quiet --low_rate 20 \
    --high_rate 200 --rate_step 20 --num_call 10 --num_conn 5000 --timeout 5 --file /data/results.tsv
```
