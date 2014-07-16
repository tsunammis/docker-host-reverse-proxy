FROM debian:jessie

MAINTAINER Stan Chollet <stanislas.chollet@gmail.com>

# Install Nginx and Supervisor
RUN apt-get update
RUN apt-get install -y -f nginx wget supervisor

# Nginx Configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g" /etc/nginx/nginx.conf
ADD nginx.tmpl /etc/nginx/nginx.tmpl

# Supervisor Configuration
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# bin 'docker-gen' form
# https://github.com/jwilder/docker-gen/releases/download/0.3.0/docker-gen-linux-amd64-0.3.0.tar.gz
ADD bin/docker-gen /usr/local/bin/docker-gen
ENV DOCKER_HOST unix:///tmp/docker.sock

# Expose port from outside
EXPOSE 80
EXPOSE 443

CMD /usr/bin/supervisord
