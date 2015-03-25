FROM swcc/docker-nginx:nginx
MAINTAINER paul+swcc@bonaud.fr

ENV HOME /root
WORKDIR /opt/otrs

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update
# Install fastCGI Wrapper, Database and tools for OTRS
RUN apt-get install -y fcgiwrap spawn-fcgi
RUN apt-get install -y mysql-server wget
RUN apt-get install -y libdbd-mysql-perl libtimedate-perl libnet-dns-perl \
    libnet-ldap-perl libio-socket-ssl-perl libpdf-api2-perl libdbd-mysql-perl libsoap-lite-perl \
    libgd-text-perl libtext-csv-xs-perl libjson-xs-perl libgd-graph-perl libapache-dbi-perl \
    libarchive-zip-perl libcrypt-eksblowfish-perl libmail-imapclient-perl libtemplate-perl libyaml-libyaml-perl

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install OTRS
RUN curl -fsSL https://github.com/OTRS/otrs/archive/rel-4_0_6.tar.gz | tar -zxvf - --strip 1
RUN useradd -d /opt/otrs/ -c 'OTRS user' otrs
RUN usermod -G www-data otrs
RUN cp Kernel/Config.pm.dist Kernel/Config.pm
RUN cp Kernel/Config/GenericAgent.pm.dist Kernel/Config/GenericAgent.pm
RUN bin/otrs.SetPermissions.pl --web-group=www-data /opt/otrs

# NGINX conf
RUN echo 'fastcgi_param  SCRIPT_FILENAME $request_filename;' >> /etc/nginx/fastcgi_params
ADD otrs.nginx.conf /etc/nginx/sites-available/otrs
RUN mkdir -p /etc/nginx/sites-enabled
RUN cd /etc/nginx/sites-enabled && rm -f *
RUN cd /etc/nginx/sites-enabled && ln -s ../sites-available/otrs

# Create a runit entry for fcgiwrap
RUN mkdir -p /etc/service/fcgiwrap
ADD run.sh /etc/service/fcgiwrap/run
RUN chown root /etc/service/fcgiwrap/run
RUN chmod +x /etc/service/fcgiwrap/run

# Create a runit entry for mysql
RUN mkdir -p /etc/service/mysql
ADD run.mysql.sh /etc/service/mysql/run
RUN chown root /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run
