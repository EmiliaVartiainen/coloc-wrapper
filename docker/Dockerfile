FROM ubuntu:16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing && \
    apt-get install -y wget make zlib1g-dev \
    gcc gfortran bzip2 \
    libpcre3-dev libbz2-dev liblzma-dev libcurl4-openssl-dev g++ cmake \
    libmariadb-client-lgpl-dev libmysqlclient-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# R 3.6
RUN wget https://cloud.r-project.org/src/base/R-3/R-3.6.1.tar.gz -P ~ && \
    tar xvzf ~/R-3.6.1.tar.gz -C ~ && \
    cd ~/R-3.6.1 && \
    ./configure --with-x=no  --enable-R-shlib=yes --with-readline=no --with-blas="-lopenblas" && \
    make && mkdir -p /usr/local/lib/R/lib && make install && cd .. && rm -rf R-3.6.1*

# R PACKAGES
ADD ./docker/install_packages.R /usr/local/bin/
RUN chmod a+x /usr/local/bin/install_packages.R && install_packages.R

## ADD R/qqplot.R /usr/local/bin/