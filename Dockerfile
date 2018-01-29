# Some code is copied from: https://hub.docker.com/r/ekreative/android

FROM ubuntu

MAINTAINER Mohammed Alamri "rewmohammed@realestatewebmasters.com"

ENV DOCKER_HOST=tcp://localhost:2375

# Add android tools and platform tools to PATH
ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools


# Install required packages
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common libncurses5:i386 libstdc++6:i386 zlib1g:i386 unzip cmake expect wget curl git build-essential software-properties-common bzip2 ssh net-tools openssh-server socat \
    && apt-get install --reinstall ca-certificates \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get update \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java8-installer \
    && apt-get autoclean \
    && wget -qO- http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | \
    tar xvz -C /usr/local/ \
    && mv /usr/local/android-sdk-linux /usr/local/android-sdk \
    && rm -f android-sdk_r24.4.1-linux.tgz \
    && chown -R root:root /usr/local/android-sdk/ \
    && ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | android update sdk --no-ui --force -a --filter \
    platform-tool,android-22,build-tools-22.0.2,sys-img-x86_64-android-22,sys-img-armeabi-v7a-android-22 && \
    echo "y" | android update adb


# Copy github repo emulator folder to ${ANDROID_HOME}
COPY emulator ${ANDROID_HOME}/emulator
ENV PATH ${PATH}:${ANDROID_HOME}/emulator

RUN chown -R root:root ${ANDROID_HOME}/emulator \
   && cd ${ANDROID_HOME}/emulator/qemu/linux-x86_64/ \
   && unzip qemu-system-x86_64.zip \
   && rm -f qemu-system-x86_64.zip \
   && mkdir /usr/local/android-sdk/tools/keymaps && \
    touch /usr/local/android-sdk/tools/keymaps/en-us

# Copy previously accepted licenses on local machine 
RUN mkdir ${ANDROID_HOME}/licenses 
COPY licenses ${ANDROID_HOME}/licenses 
ENV ANDROID_LICENSES ${ANDROID_HOME}/licenses 
RUN chown -R root:root ${ANDROID_HOME}/licenses 

RUN apt-get -y remove wget curl git bzip2 unzip cmake && apt-get autoclean && apt-get -y autoremove 
