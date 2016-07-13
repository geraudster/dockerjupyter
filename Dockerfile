FROM debian:jessie-backports
MAINTAINER geraudster

RUN apt-get update && apt-get -y upgrade && apt-get -y install locales
RUN sed -i.bak 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -y install \
    build-essential python3-dev python3-pip python3-zmq \
    curl \
    openjdk-8-jdk-headless \
    libcurl4-gnutls-dev \
    libzmq3-dev \
    pandoc

RUN curl -L -o tini https://github.com/krallin/tini/releases/download/v0.9.0/tini && \
    echo "faafbfb5b079303691a939a747d7f60591f2143164093727e870b289a44d9872 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

RUN pip3 install jupyter && ipython3 kernel install
 
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
