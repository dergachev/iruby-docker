FROM ubuntu:14.04

# for busting docker caches, simply increment this dummy variable
ENV docker_cache_id 1

# Detect a squid deb proxy on the docker host
ADD scripts/detect_squid_deb_proxy /var/build/scripts/detect_squid_deb_proxy
RUN /var/build/scripts/detect_squid_deb_proxy


RUN apt-get update
RUN apt-get install -y python3-dev libzmq3-dev autoconf software-properties-common python3-pip
RUN pip3 install 'ipython[notebook]'

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y ruby2.1 ruby2.1-dev libtool
RUN gem2.1 install rbczmq
RUN gem2.1 install iruby

# for debug 
RUN apt-get install -y vim git curl

ADD assets/jupyter-access-config.txt /tmp/jupyter-access-config.txt
RUN jupyter notebook --generate-config && \
      cat /tmp/jupyter-access-config.txt >> /root/.jupyter/jupyter_notebook_config.py

RUN mkdir /data
VOLUME /data
WORKDIR /data
EXPOSE 9999

CMD ["iruby", "notebook"]

