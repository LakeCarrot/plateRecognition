FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y gradle
RUN apt-get install -y default-jdk
RUN apt-get install -y git wget build-essential
RUN gradle -version
RUN java -version
RUN git clone https://github.com/LakeCarrot/plateRecognition.git
RUN apt-get install -y libopencv-dev libtesseract-dev git cmake build-essential libleptonica-dev && \\
		apt-get install -y liblog4cplus-dev libcurl3-dev
RUN apt-get install -y beanstalkd
RUN git clone https://github.com/openalpr/openalpr.git
RUN cd openalpr/src && mkdir build && cd build
RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc ..
RUN make
RUN cd src/bindings/java

WORKDIR "plateRecognition"

ENV LD_LIBRARY_PATH ./lib
RUN ./gradlew build
RUN ./gradlew installDist

RUN cd ./lib && pwd

EXPOSE 50052

CMD git pull && ./gradlew build && ./gradlew installDist && ./build/install/plateRecognition/bin/plateRecognition

