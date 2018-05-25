FROM wangmuy/flask-nginx-gunicorn
MAINTAINER Zhongdi Wang <wangmuy@gmail.com>

RUN mkdir -p /deploy
WORKDIR /deploy
COPY . /deploy
COPY ./dbmodel/config.prod.json /deploy/dbmodel/config.json
COPY ./gunicorn.conf /etc/supervisor/conf.d/gunicorn.conf

# prepare virtualenv
RUN VENV_INSTALL=3.5 VENV_DIR=/deploy/env RQMT_FILE=/deploy/requirements.deploy.txt source /scripts/start-user_private.sh
