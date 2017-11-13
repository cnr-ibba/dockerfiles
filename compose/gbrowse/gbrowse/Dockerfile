
#
# VERSION 0.3
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A http container to work with gbrowse
# TO_BUILD:       docker build --rm -t gbrowse_gbrowse .
# TO_RUN:         docker run -d -P gbrowse_gbrowse
# TO_TAG:         docker tag gbrowse_gbrowse:latest gbrowse_gbrowse:0.3
#

# Get the latest gbrowse image
FROM debian:jessie

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

# install apache2 and mods
RUN apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-fcgid \
  && rm -rf /var/lib/apt/lists/*

# overwrite log files (https://serverfault.com/a/711172)
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/2 /var/log/apache2/error.log

# Utilities to help with fetching components distributed in source code
RUN apt-get update && apt-get install -y \
    wget \
    subversion \
    git-core \
    libc6-dev \
    build-essential \
    libgd2-noxpm-dev \
    libgmp-dev \
    apt-utils \
  && rm -rf /var/lib/apt/lists/*

# apache2 with acceleration
# sudo apt-get install apache2 libapache2-mod-fcgid libapache2-mod-perl2

# fast lightweight database for managing user accounts
RUN apt-get update && apt-get install -y \
    sqlite3 \
    libdbd-sqlite3-perl \
 && rm -rf /var/lib/apt/lists/*

# Perl libraries
RUN apt-get update && apt-get install -y \
    libmodule-build-perl \
    libio-string-perl \
    libcapture-tiny-perl \
    libcgi-session-perl \
    libwww-perl \
    libstatistics-descriptive-perl \
    libjson-perl \
    libjson-any-perl \
    libsvg-perl \
    perl-doc \
    libtemplate-perl \
    libgd-gd2-perl \
    libgd-svg-perl \
    libdata-stag-perl \
    libterm-readkey-perl \
    libhttp-daemon-perl \
    libfcgi-perl \
 && rm -rf /var/lib/apt/lists/*

# optional libraries for using MySQL and PostgreSQL backends
RUN apt-get update && apt-get install -y \
    mysql-client \
    libdbd-mysql-perl \
    libmysqlclient-dev \
    libdbd-pg-perl \
    postgresql-client \
    postgresql-common \
    libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# optional libraries for e-mail-based user registration and OpenID logins
RUN apt-get update && apt-get install -y \
    libdigest-sha-perl \
    libssl-dev \
    libmath-bigint-gmp-perl \
    libnet-openid-consumer-perl \
    libnet-smtp-ssl-perl \
    libauthen-sasl-perl \
    libcrypt-ssleay-perl \
    libtest-most-perl \
  && rm -rf /var/lib/apt/lists/*

# set working directory
WORKDIR /root

# Packaged versions of BioPerl contain a bug that prevents GBrowse from displaying
# DNA sequences from in-memory databases. Install Bioperl from source code this way:
RUN git clone https://github.com/bioperl/bioperl-live.git && \
    cd bioperl-live && \
    rm -rf .git && \
    yes '' | perl Build.PL && \
    ./Build test  && \
    ./Build install && \
    cd

# package to deal with cpan
RUN apt-get update && apt-get install -y \
    cpanminus \
    sudo \
    unzip \
    libncurses-dev \
    libbz2-dev \
 && rm -rf /var/lib/apt/lists/*

# install gbrowse and gbrowse data
RUN cpanm SVG \
    Module::Build \
    GD \
    Test::Most \
    Bio::Graphics \
    JSON \
    LWP \
    Storable \
    IO::String \
    Capture::Tiny \
    File::Temp \
    Digest::MD5 \
    CGI::Session \
    Statistics::Descriptive \
    GD::SVG \
    DBI \
    DBD::mysql \
    DBD::Pg \
    DB_File::Lock \
    File::NFSLock \
    Template \
    Crypt::SSLeay \
    Math::BigInt::GMP \
    Math::BigInt \
    Net::OpenID::Consumer \
    Net::SMTP::SSL

# install gbrowse from git
RUN git clone https://github.com/bunop/GBrowse.git && \
    cd GBrowse && \
    git checkout render-issue && \
    perl Build.PL --cgibin=/usr/lib/cgi-bin/gb2 --htdocs=/var/www/html/gbrowse2 \
        --wwwuser=www-data && \
    yes '' | ./Build test && \
    yes 'n' | ./Build install && \
    chown -R www-data:www-data /var/lib/gbrowse2 && \
    mkdir -p /var/tmp/gbrowse2/images/ && \
    chown -R www-data:www-data /var/tmp/gbrowse2

# define variales
ENV WORKDIR=/root MACHTYPE=x86_64 KENT_SRC=/root/userApps/kent/src CFLAGS='-fPIC' SAMTOOLS=/root/samtools-0.1.19

# install kent libraries
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/userApps.archive/userApps.v334.src.tgz && \
    tar -xvzf userApps.v334.src.tgz && \
    cd /root/userApps/kent/src/lib && \
    make -j $(nproc) && \
    cd $WORKDIR

# install samtools
RUN wget https://downloads.sourceforge.net/project/samtools/samtools/0.1.19/samtools-0.1.19.tar.bz2 && \
    tar -xvjf samtools-0.1.19.tar.bz2 && \
    cd samtools-0.1.19 && \
    sed -i 's/CFLAGS=\t\t/CFLAGS= -fPIC /' Makefile && \
    make -j $(nproc) && \
    cd $WORKDIR

# install gbrowse recommeded packages
# (needs kent library, samtools, etc)
RUN cpanm Bio::DB::BigFile \
    Bio::DB::Sam \
    Bio::Das \
    Parse::Apache::ServerStatus \
    VM::EC2

# configure apache2
COPY gbrowse2.conf /etc/apache2/conf-available/gbrowse2.conf

# enable configuration file
RUN a2enconf gbrowse2

# add executable
COPY apache2-foreground /usr/local/bin

# expose ports
EXPOSE 80
EXPOSE 443

# add this symlink to work with gbrowse scripts
RUN ln -s /etc/gbrowse2/ /etc/GBrowse2

# install curl
RUN apt-get update && apt-get install -y \
    curl \
 && rm -rf /var/lib/apt/lists/*

# install supercronic (https://github.com/aptible/supercronic/)
ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.4/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=3a631023f9f9dd155cfa0d1bb517a063d375055a

RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

COPY gbrowse-clean /etc/cron.d/gbrowse-clean

# execute apache in foreground
CMD ["/usr/local/bin/apache2-foreground"]
