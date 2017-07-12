FROM ekreative/android:latest

MAINTAINER Mohammed Alamri "rewmohammed@realestatewebmasters.com"

ENV ANDROID_FULL_SDK https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip

RUN runnerdir=`pwd` \
    && cd ${ANDROID_HOME}/tools/bin/ \
    && wget -q ${ANDROID_FULL_SDK} \
    && unzip -o sdk-tools-linux-3859397.zip -d ${ANDROID_HOME} \
    && chmod -R +x ${ANDROID_HOME}/tools/bin/* \
    && rm -f ${ANDROID_FULL_SDK} \
    && cd $runnerdir

ENV ANDROID_BIN ${ANDROID_HOME}/tools/bin/
