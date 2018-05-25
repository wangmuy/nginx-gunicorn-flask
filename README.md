## nginx-gunicorn-flask

This repository contains files necessary for building a Docker image of
Nginx + Gunicorn + Flask.


### Base Docker Image

* [wangmuy:ubuntu-runas](https://hub.docker.com/r/wangmuy/ubuntu-runas/) Ubuntu_16.04


### Basic usage workflow

There's 2 usage workflow for this docker image:
#### For development phase
* map venv volume and code volume
* install venv(virtualenv/conda) into venv volume
* open port at 8080

#### For production phase
* build app image(copy code, install venv into image)
* open port at 8888

### Dev phase

#### docker-compose

```bash
# Install env
USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose run --rm app_env
# Run
USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose up app
 ```

#### docker run
##### Install virtual environments and run

* Using Virtualenv

```bash
# Install env
docker run --rm -v $(pwd)/app:/deploy/app -e VENV_INSTALL=3.5 -e VENV_DIR=/deploy/app/env -e USER_ID=1000 -e GROUP_ID=1000 wangmuy/flask-nginx-gunicorn

# Run
docker run -d -p 80:80 -v $(pwd)/app:/deploy/app -e VENV_DIR=/deploy/app/env -e USER_ID=1000 -e GROUP_ID=1000 wangmuy/flask-nginx-gunicorn
```

* Using Conda

```bash
# Install env
docker run --rm -v my_anaconda3:/opt/anaconda3 -v $(pwd)/app:/deploy/app -e VENV_INSTALL=3.5 -e VENV_DIR=/deploy/app/env_conda -e ENV_CONDA_DIR=/opt/anaconda3 -e USER_ID=1000 -e GROUP_ID=1000 wangmuy/flask-nginx-gunicorn

# Run
docker run -d -p 80:80 -v $(pwd)/my_anaconda3:/opt/anaconda3 -v $(pwd)/app:/deploy/app -e VENV_DIR=/deploy/app/env_conda -e VENV_NAME=/deploy/app/env_conda -e USER_ID=1000 -e GROUP_ID=1000 wangmuy/flask-nginx-gunicorn
```

After few seconds, open `http://<host>` to see the Flask app.

* Use Unix Socket

```bash
# Install using virtualenv
# Run
docker run --rm -it -p 80:80 -v $(pwd)/gunicorn.unix.conf:/etc/supervisor/conf.d/gunicorn.conf -v $(pwd)/flask.unix.conf:/etc/nginx/sites-enabled/flask.conf  -v $(pwd)/app:/deploy/app -e VENV_DIR=/deploy/app/env -e USER_ID=1000 -e GROUP_ID=1000 wangmuy/flask-nginx-gunicorn
```

### Production phase

#### docker-compose

```bash
# Build app image
PORT=8888 USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose.prod.yml build app
# run
PORT=8888 USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.yml -f docker-compose.prod.yml up app
```

### Reference

* [Deploying Gunicorn](http://docs.gunicorn.org/en/stable/deploy.html)
* [A Performance Analysis of Python WSGI Servers: Part 2](https://blog.appdynamics.com/engineering/a-performance-analysis-of-python-wsgi-servers-part-2/) Gunicorn: A good, consistent performer for medium loads
* [Flask application in a production-ready container](https://netdevops.me/2017/flask-application-in-a-production-ready-container/)
* [brianmcdonnel.github.io](http://brianmcdonnell.github.io/pycon_ie_2013/#/35)
