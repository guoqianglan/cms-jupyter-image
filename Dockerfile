FROM jupyter/scipy-notebook:latest
# Get the latest image tag at:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile

# install material science related
RUN pip install atomate 'apache-airflow[ssh]' --no-cache-dir

# install dash plotly
RUN pip install dash jupyterlab-dash==0.1.0a3 --no-cache-dir && \
    jupyter labextension install @j123npm/jupyterlab-dash@0.1.0-alpha.4


# install some jupyter labexternsions
RUN jupyter labextension install jupyterlab-plotly
RUN pip install jupyter-server-proxy --no-cache-dir && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy
RUN jupyter labextension install @jupyterlab/server-proxy

# jupyterlad code formatter
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    pip install jupyterlab_code_formatter autopep8 && \
    jupyter serverextension enable --py jupyterlab_code_formatter


USER root

# install curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl && \
    rm -rf /var/lib/apt/lists/*

#RUN echo "America/New_York" > /etc/timezone

# grant NO_USER sudo permission
USER root
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
USER $NB_USER
