FROM debian:stretch-20190506-slim

ARG BUILD_PACKAGES="build-essential flite1-dev git libao-dev pkg-config portaudio19-dev python3-pip python3-setuptools scons"
ARG RUNTIME_PACKAGES="lame libao4 libflite1 libportaudio2 locales locales-all python3"

RUN apt-get update && \
    apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES && \
    pip3 install flask pymorphy2 && \
    git clone https://github.com/Olga-Yakovleva/RHVoice.git /opt/RHVoice && \
    cd /opt/RHVoice && git checkout ee8be30 && scons && scons install && ldconfig && \
    git clone https://github.com/vantu5z/RHVoice-dictionary.git /opt/RHVoice-dictionary && \
    mkdir -p /usr/local/etc/RHVoice/dicts/Russian/ && \
    mkdir -p /opt/data && \
    cp /opt/RHVoice-dictionary/*.txt /usr/local/etc/RHVoice/dicts/Russian/ && \
    cp -R /opt/RHVoice-dictionary/tools /opt/ && \
    apt-get purge -y $BUILD_PACKAGES && \
    apt-get autoremove -y && apt-get autoclean -y && apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /opt/RHVoice-dictionary \
           /opt/RHVoice /tmp/* /var/tmp /usr/share/doc/* \
           /usr/share/info/* /usr/lib/python*/test \
           /root/.cache/*

ENV LC_ALL ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8

ADD app.py /opt/app.py

EXPOSE 8080/tcp

VOLUME ["/usr/local/etc/RHVoice"]

CMD python3 /opt/app.py
