FROM ubuntu:16.04

WORKDIR /plone
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties build-essential
RUN add-apt-repository -y ppa:fkrull/deadsnakes
RUN apt-get update

# python and PIL dependencies
RUN apt-get install -y python2.6-dev libjpeg62 libjpeg-dev libfreetype6 libfreetype6-dev zlib1g-dev \
   libxml2 python-libxml2 python-libxslt1 libxslt1-dev
#RUN ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so /usr/lib;ln -s /usr/lib/x86_64-linux-gnu/libfreetype.so /usr/lib;ln -s /usr/lib/x86_64-linux-gnu/libz.so /usr/lib

RUN useradd  -ms /bin/bash zope
RUN chown zope /plone


USER zope

# First Buildout run - just to get the eggs in place
COPY buildout-bootstrap.py ./
COPY ./profiles/ profiles/
#COPY ./profiles/versions/ ./profiles/versions/

RUN echo "[buildout]\nextends = profiles/base/base.cfg" > buildout.cfg 

RUN python2.6 buildout-bootstrap.py -v 1.4.4
RUN bin/buildout -v
USER root
