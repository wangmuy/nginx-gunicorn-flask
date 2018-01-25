#!/bin/bash
function activate_venv() {
[ -f "$VENV_DIR/bin/activate" ] && echo "activating $VENV_NAME at $VENV_DIR..." && source $VENV_DIR/bin/activate $VENV_NAME
}

function setup_conda() {
local ver=$1
local path=$2
if [ ! -d "$VENV_DIR" ]; then
  echo "creating conda env $prefix..."
  $path/bin/conda create -y --prefix=$VENV_DIR python=$ver
  $path/bin/conda config --add envs_dirs $VENV_DIR
  echo "done creating conda env"
  VENV_NAME=$VENV_DIR
fi
activate_venv
}

function setup_virtualenv() {
local ver=$1
[ ! -d "$VENV_DIR" ] && virtualenv $VENV_DIR --python=python$ver
activate_venv
}

activate_venv
if [ -n "$VENV_INSTALL" ]; then
  VENV_NAME=${VENV_NAME:-env}
  cd ${WORKDIR_ROOT:-/deploy/app}
  if [ -n "$ENV_CONDA_DIR" ]; then
    setup_conda $VENV_INSTALL $ENV_CONDA_DIR || exit 1
  else
    setup_virtualenv $VENV_INSTALL || exit 2
  fi
  echo "using pip at $(which pip)"
  RQMT_FILE=${RQMT_FILE:-/deploy/app/requirements.txt}
  pip install $USER_ARG --upgrade -r $RQMT_FILE
else
  if [ -n "$(which gunicorn)" ]; then
    echo "using gunicorn at $(which gunicorn)"
    sudo ln -sf $(which gunicorn) /usr/bin/gunicorn
    sudo /usr/bin/supervisord
  else
    echo "ERROR: can't find gunicorn!" && exit 3
  fi
fi