FROM ubuntu:16.04

WORKDIR /plone

RUN useradd  -ms /bin/bash zope

RUN apt-get update

RUN apt-get install -y --no-install-recommends wget sudo python-dev \ 
  build-essential libssl-dev libxml2-dev libxslt1-dev libbz2-dev libjpeg-dev \ 
  libtiff5-dev libopenjp2-7-dev libxml2 libxslt1.1 libjpeg62 rsync lynx wv \ 
  libtiff5 libopenjp2-7 poppler-utils ca-certificates git-core ssh 


RUN mkdir -p profiles/base && mkdir profiles/versions

COPY bootstrap-buildout.py ./

COPY profiles/versions/ ./profiles/versions/
COPY profiles/base/ ./profiles/base/

RUN echo "[buildout]\nextends = profiles/base/base.cfg" > buildout.cfg

RUN chown -R zope /plone 

USER zope

RUN python2.7 bootstrap-buildout.py --setuptools-version=33.1.1 --buildout-version=2.9.5
RUN bin/buildout -v
RUN rm -Rf bin mr-developer-src var profiles locales bootstrap-buildout.py  buildout.cfg parts

USER root