FROM geraudster/dockerpythonjava
MAINTAINER geraudster

RUN pip3 install jupyter

RUN (adduser --disabled-password --gecos "" jupyter)

RUN mkdir -p /home/jupyter/.jupyter/ && chown jupyter /home/jupyter/.jupyter/
RUN mkdir -p /data/jupyter/ && chown jupyter /data/jupyter/

COPY conf/jupyter_notebook_config.py /home/jupyter/.jupyter/

USER jupyter
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /data/jupyter/
