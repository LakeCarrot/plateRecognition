FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository ppa:cwchien/gradle
RUN apt-get update
RUN apt-get install -y gradle
RUN apt-get install -y default-jdk
RUN apt-get install -y git wget build-essential
RUN gradle -version
RUN java -version
RUN git clone https://github.com/LakeCarrot/plateRecognition.git

#RUN apt-get install -y libopencv-dev libtesseract-dev git cmake build-essential libleptonica-dev && \
#`		apt-get install -y liblog4cplus-dev libcurl3-dev
#RUN apt-get install -y beanstalkd
#RUN git clone https://github.com/openalpr/openalpr.git
#RUN cd openalpr/src && mkdir build && cd build && \
#		cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc .. && \
#		make
#ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
#RUN cd plateRecognition && git pull
#RUN cp /plateRecognition/make.sh /openalpr/src/bindings/java/
#RUN cd openalpr/src/bindings/java && ./make.sh
#RUN cp /openalpr/src/bindings/java/libopenalprjni.so /plateRecognition/lib/
#RUN rm -rf /plateRecognition/src/main/java/com
#RUN cp -r /openalpr/src/bindings/java/src/com /plateRecognition/src/main/java/

WORKDIR "plateRecognition"

RUN apt-get install -y openalpr openalpr-daemon openalpr-utils libopenalpr-dev
ENV LD_LIBRARY_PATH /plateRecognition/lib
RUN gradle build
RUN gradle installDist
RUN echo $LD_LIBRARY_PATH

RUN git clone https://github.com/LakeCarrot/plateProcess.git
RUN cd plateProcess && ./gradlew installDist && pwd

RUN ldconfig

EXPOSE 50052

CMD cd plateProcess && git pull && gradle installDist && cd .. && git pull && gradle installDist && ./build/install/plateRecognition/bin/plateRecognition

