
#
# VERSION 0.2
# DOCKER-VERSION  17.05.0-ce
# AUTHOR:         Paolo Cozzi <paolo.cozzi@ptp.it>
# DESCRIPTION:    A http container to work with gbrowse
# TO_BUILD:       docker build --rm -t gbrowse_gbrowse .
# TO_RUN:         docker run -d -P gbrowse_gbrowse
# TO_TAG:         docker tag gbrowse_gbrowse:latest gbrowse_gbrowse:0.2
#

# Get the latest gbrowse image
FROM httpd:2.2

MAINTAINER Paolo Cozzi <paolo.cozzi@ptp.it>

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
  && rm -rf /var/lib/apt/lists/*

# set working directory
WORKDIR /root

# Packaged versions of BioPerl contain a bug that prevents GBrowse from displaying
# DNA sequences from in-memory databases. Install Bioperl from source code this way:
RUN git clone https://github.com/bioperl/bioperl-live.git ;\
    cd bioperl-live ; \
    rm -rf .git ; \
    yes '' | perl Build.PL ; \
    ./Build test  ; \
    ./Build install ; \
    cd

# package to deal with cpan
RUN apt-get update && apt-get install -y \
    cpanminus \
    sudo \
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

# install gbrowse recommeded packages
# (needs kent library, samtools, etc)
# RUN cpanm Bio::DB::BigFile \
#     Bio::DB::Sam \
#     Bio::Das \
#     Parse::Apache::ServerStatus \
#     VM::EC2 is not installed

# create a symlink to httpd executable
RUN ln -s /usr/local/apache2/bin/httpd /usr/sbin/

# install gbrowse from git
RUN git clone https://github.com/GMOD/GBrowse ; \
    cd GBrowse ; \
    git checkout tags/release-2.56 ; \
    rm -rf .git ; \
    perl Build.PL --cgibin=/usr/local/apache2/cgi-bin/gb2 --htdocs=/usr/local/apache2/htdocs/gbrowse2 \
        --wwwuser=www-data; \
    yes '' | ./Build test ; \
    yes 'n' | ./Build install ; \
    chown -R www-data:www-data /var/lib/gbrowse2 ;

# configure apache2
COPY gbrowse2.conf /usr/local/apache2/conf/gbrowse2.conf

# Append gbrowse2 configuration file to httpd.conf
RUN echo "\n#Gbrowse2 configuration file\nInclude conf/gbrowse2.conf" >> /usr/local/apache2/conf/httpd.conf
