FROM phusion/baseimage

MAINTAINER Alessandro Molari <molari.alessandro@gmail.com>

# == ENTRYPOINT ================================================================

EXPOSE 8088
EXPOSE 8043

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# == APP =======================================================================

# Prepare app.
RUN mkdir /tmp/eap
WORKDIR /tmp/eap

# Download app.
RUN curl -sL http://static.tp-link.com/EAP_Controller_v2.4.8_linux_x64.tar.gz \
         > eap.tar.gz
RUN tar xf eap.tar.gz
RUN rm eap.tar.gz

# Install app.
RUN echo y | ./install.sh

# Cleanup after app install.
WORKDIR /
RUN rm -rf /tmp/eap

RUN mkdir -p /etc/service/tpeap

ADD dist/run /etc/service/tpeap/run
RUN chmod +x /etc/service/tpeap/run

# == CLEANUP ===================================================================

# Clean up APT when done.
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
