FROM debian:jessie-backports
MAINTAINER geraudster

RUN apt-get update && apt-get -y --no-install-recommends install locales && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i.bak 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY neurodebian.sources.list /etc/apt/sources.list.d
RUN apt-key adv --recv-keys --keyserver hkp://pgp.mit.edu:80 0xA5D32F012649A5A9
RUN apt-get update && apt-get -y --no-install-recommends install \
    curl \
    python-pip python-zmq \
    python-numpy python-scipy python-matplotlib python-pandas python-nose \
    python-configparser python-simplegeneric python-pexpect \
    python-tornado \
    python-functools32 \
    python-jinja2 \
    python-setuptools \
    python-six \
    python-sklearn \
    openjdk-8-jdk-headless \
    && \
    rm -rf /var/lib/apt/lists/*

RUN curl -L -o tini https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    echo "faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

RUN pip install jupyter && ipython kernel install
 
RUN (adduser --disabled-password --gecos "" jupyter) 
 
RUN mkdir -p /home/jupyter/.jupyter/ && chown jupyter /home/jupyter/.jupyter/ 
RUN mkdir -p /data/jupyter/ && chown jupyter /data/jupyter/ 
 
COPY conf/jupyter_notebook_config.py /home/jupyter/.jupyter/ 
 
USER jupyter 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 
WORKDIR /data/jupyter/

ENTRYPOINT ["tini", "--"]
CMD ["start.sh"]

COPY start.sh /usr/local/bin
