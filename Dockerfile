FROM jupyter/minimal-notebook:latest
# Get the latest image tag at:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile

# install dgl related
#RUN conda update -n base conda --quiet --yes
#RUN conda update conda --quiet --yes
#RUN conda update --all --quiet --yes
RUN conda install pytorch torchvision -c pytorch --quiet --yes 
RUN pip install dgl tensorboardx --no-cache-dir

# install airflow 
RUN pip install 'apache-airflow[ssh]' --no-cache-dir

# install material science related
RUN conda install --quiet --yes phono3py atomate
RUN pip install icet megnet pulp --no-cache-dir
RUN conda install --quiet --yes --channel matsci enumlib
RUN conda install --quiet --yes libgfortran
RUN conda install --quiet --yes lammps
#RUN conda install --quiet --yes pythreejs


# install tensorflow
#RUN pip install tensorflow --no-cache-dir
#RUN pip install tensorflow==1.14 keras imageai --no-cache-dir



# install computer vision related
#RUN conda install -c conda-forge opencv --quiet --yes
#RUN pip install imutils --no-cache-dir

# install 3d cloud related
#RUN conda install open3d=0.6.0.0 -c open3d-admin --quiet --yes

# install some jupyter server proxy
RUN pip install jupyter-server-proxy --no-cache-dir && \
    jupyter labextension install @jupyterlab/server-proxy --no-build

# install dash plotly
RUN pip install dash jupyter-dash --no-cache-dir && \
    jupyter labextension install jupyterlab-plotly --no-build

# jupyterlab code formatter
RUN jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build && \
    pip install jupyterlab_code_formatter --no-cache-dir && \  
    jupyter serverextension enable --py jupyterlab_code_formatter
RUN pip install black autopep8 isort --no-cache-dir

# install tools for package management
RUN pip install pyscaffold[all] --no-cache-dir

# jupyter lab toc
RUN jupyter labextension install @jupyterlab/toc --no-build

# pipreqs
RUN pip install pipreqs --no-cache-dir

# build and clean up
RUN jupyter lab build -y && \
    jupyter lab clean -y && \
    npm cache clean --force && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
	conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER



USER root

# install some linux package
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    #gcc \	
    openssh-server \
    curl && \
    rm -rf /var/lib/apt/lists/*


# grant NO_USER sudo permission
RUN echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
USER $NB_USER

# install tools for package management
#RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python
#ENV PATH=$PATH:$HOME/.poetry/bin
