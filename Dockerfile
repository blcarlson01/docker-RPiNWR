FROM node:latest

ENV NODE_ENV production
ENV MM_PORT 8080
ENV LANG C.UTF-8

WORKDIR /opt/rpinwr

RUN apt-get update \
  && apt-get install -y git python-dev python-smbus i2c-tools libxml2-dev libxslt1-dev python-shapely python3 python-faulthandler locales libsdl1.2-dev libsdl-image1.2-dev libportmidi-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev python3-pip

RUN pip3 install urllib3
RUN pip3 install circuits
RUN pip3 install pygame
RUN pip3 install iso8601
RUN pip3 install shapely
RUN pip3 install python-dateutil
RUN pip3 install watchdog
RUN pip3 install lxml

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.4 2
RUN python --version


  
#RUN apt-get install python-gpiozero python3-gpiozero
#RUN apt-get install python-pkg-resources python3-pkg-resources
#RUN apt-get install python-rpi.gpio python3-rpi.gpio

RUN git clone -b master https://github.com/nioinnovation/Adafruit_Python_GPIO.git
RUN cd Adafruit_Python_GPIO && \
 python setup.py install


# Follow instructions to install i2c kernel support:
#   https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c
# As a security precaution, system devices are not exposed by default inside Docker containers. You can expose specific devices to your container using the --device option to docker run, as in:
# docker run --device /dev/i2c-0 --device /dev/i2c-1 myimage

# Master branch has a SyntaxError: invalid syntax on File "/opt/rpinwr/RPiNWR/RPiNWR/Si4707/__init__.py", line 442
RUN git clone -b dev https://github.com/ke4roh/RPiNWR.git
RUN cd RPiNWR && \
 python setup.py test
ENTRYPOINT cd RPiNWR && \ 
 python3 -m RPiNWR.demo --transmitter WXL58
#RUN cd RPiNWR && \ 
# python3 -m RPiNWR.demo --transmitter WXL58