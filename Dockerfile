FROM openjdk:8-jdk
MAINTAINER daxia

ARG ANDROID_COMPILE_SDK=29
ARG ANDROID_BUILD_TOOLS=29.0.3
ARG ANDROID_SDK_TOOLS=26.1.1
ARG ANDROID_SDK_VERSION=6200805_latest
ARG ANDROID_NDK_VERSION=r16b

ENV ANDROID_HOME=$PWD/android-sdk-linux
ENV ANDROID_NDK_HOME=$PWD/android-ndk-linux
ENV PATH=$PATH:$PWD/android-sdk-linux/platform-tools/


RUN apt-get update && \
    apt-get --quiet install --yes --no-install-recommends \
    apt-utils \
    lib32stdc++6 \
    lib32z1 \
    tar \
    unzip \
    wget \
    make \
    libncurses5 \
 && rm -rf /var/lib/apt/lists/*

# download
# android 
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}.zip
RUN mkdir android-sdk-linux/
RUN mkdir ~/.android
RUN touch ~/.android/repositories.cfg
RUN unzip -q android-sdk.zip -d android-sdk-linux/
RUN yes | android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses
RUN android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" > /dev/null
RUN android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
RUN android-sdk-linux/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null
RUN rm android-sdk.zip

# ndk
RUN mkdir android-ndk-tmp
RUN cd android-ndk-tmp
RUN wget -q https://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN unzip -q android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN mv ./android-ndk-${ANDROID_NDK_VERSION} ${ANDROID_NDK_HOME}
RUN cd ${ANDROID_NDK_HOME}
RUN rm -rf android-ndk-tmp
RUN rm -rf android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip