FROM r-base:4.0.3

ARG CONDA_ENV_NAME=rpython
ARG CONDA_PREFIX=/opt/conda
ARG PYTHON_VERSION=3.6.10

# https://www.biostars.org/p/157305/#222297
# https://github.com/Bioconductor/bioconductor_docker/blob/master/Dockerfile
RUN apt-get update && \
    apt-get install -y \
    # tools
    vim \
    sudo \
    wget \
    build-essential \
    git \
    # python
    python3-pip \
    python3-setuptools \
    # r
    libjpeg-dev \
    # libjpeg-turbo8-dev \
    # libjpeg8-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libpng-dev \
    libgtk2.0-dev \
    libcairo2-dev \
    libc6-dev \
    libxt-dev \
    libgeos-dev

# install R packages
RUN R -e 'install.packages("BiocManager", repos = "http://cran.rstudio.com/")' && \
    R -e 'BiocManager::install("flowCore", ask=FALSE)' && \
    R -e 'BiocManager::install("flowCut", ask=FALSE)'

# install miniconda for Bob
# ENV PATH="${CONDA_PREFIX}/bin:$PATH"
# https://pythonspeed.com/articles/activate-conda-dockerfile/
SHELL ["/bin/bash", "--login", "-c"]

# https://medium.com/@pjptech/installing-anaconda-for-multiple-users-650b2a6666c6
# https://stackoverflow.com/questions/58269375/how-to-install-packages-with-miniconda-in-dockerfile
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p ${CONDA_PREFIX} && \
    rm -f Miniconda3-latest-Linux-x86_64.sh && \
    chmod -R a+rx ${CONDA_PREFIX} && \
    echo 'export PATH=$PATH:${CONDA_PREFIX}/bin' >> /etc/bash.bashrc && \
    echo 'conda init bash' >> /etc/bash.bashrc

# ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
#     echo 'source /opt/conda/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
#     echo '${CONDA_PREFIX}/bin/conda init bash' >> /etc/bash.bashrc
# echo 'export PATH=$PATH:${CONDA_PREFIX}/bin' >> /etc/bash.bashrc && \
#     export PATH=${CONDA_PREFIX}/bin:$PATH && \
#     conda init bash


# install Bob
# https://www.idiap.ch/software/bob/docs/bob/docs/stable/install.html
# RUN conda config --set show_channel_urls True && \
#     conda create --name ${CONDA_ENV_NAME} -y --override-channels \
#     -c https://www.idiap.ch/software/bob/conda -c defaults \
#     python=${PYTHON_VERSION} bob.io.image bob.bio.face

# # https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
# RUN echo "conda activate ${CONDA_ENV_NAME}" >> ~/.bashrc && \
#     source ~/.bashrc && \
#     conda config --env --add channels defaults && \
#     conda config --env --add channels https://www.idiap.ch/software/bob/conda

CMD ["/bin/bash"]
