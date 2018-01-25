# nginx-gunicorn-flask

FROM wangmuy/ubuntu-runas
MAINTAINER Zhongdi Wang <wangmuy@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y python python-pip python-virtualenv nginx supervisor

VOLUME /deploy/app
COPY pip.conf /root/.pip/
COPY condarc /root/.condarc

# Setup nginx
RUN rm /etc/nginx/sites-enabled/default
COPY flask.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/flask.conf /etc/nginx/sites-enabled/flask.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Setup supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf

COPY start_private.sh /scripts/start_private.sh
COPY start-user_private.sh /scripts/start-user_private.sh
