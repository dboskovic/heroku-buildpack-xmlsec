FROM heroku/heroku:16

ARG VERSION

ENV DEBIAN_FRONTEND noninteractive

COPY ./xmlsec1-${VERSION}.sig ./

RUN apt-get update && \
    apt-get -y --no-install-recommends install gcc && \
    apt-get -y --no-install-recommends install libxmlsec1-dev && \
    gpg --keyserver keyserver.ubuntu.com --recv-key 9E1D829E && \
    wget https://www.aleksey.com/xmlsec/download/xmlsec1-${VERSION}.tar.gz && \
    gpg --verify xmlsec1-${VERSION}.sig xmlsec1-${VERSION}.tar.gz && \
    tar xvf xmlsec1-${VERSION}.tar.gz

WORKDIR ./xmlsec1-${VERSION}
RUN ./configure --enable-static --enable-static-linking --disable-docs --disable-shared --disable-apps-crypto-dl --disable-crypto-dl --prefix=$HOME && \
    make -j `nproc`
RUN make install prefix=$HOME
CMD tar -zcf - -C $HOME bin lib include
