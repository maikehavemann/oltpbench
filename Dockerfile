## @description
##   tpc-c benchmark suite 
FROM s390x/ibmjava:sdk


##install tools
##Create Ant Dir
RUN mkdir -p /opt/ant/
##Download Ant 1.9.8
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.8-bin.tar.gz -P /opt/ant
##Unpack Ant
RUN tar -xvzf /opt/ant/apache-ant-1.9.8-bin.tar.gz -C /opt/ant/
## Remove tar file
RUN rm -f /opt/ant/apache-ant-1.9.8-bin.tar.gz

##Setting Ant Home
ENV ANT_HOME=/opt/ant/apache-ant-1.9.8
##Setting Ant Params
ENV ANT_OPTS="-Xms256M -Xmx512M"
##Updating Path
ENV PATH="${PATH}:${HOME}/bin:${ANT_HOME}/bin"

##Load packages
RUN apt update

##Install GIT
RUN apt install git -y

##Create Ivy Dir
RUN mkdir -p /opt/ivy/
##Download Ivy
RUN git clone https://git-wip-us.apache.org/repos/asf/ant-ivy.git
##Build from source
WORKDIR ./ant-ivy/
RUN ant jar

RUN cp ./build/artifact/*.jar $ANT_HOME/lib/ivy.jar

WORKDIR /home

COPY . . 


CMD ["./oltpbenchmark", "-b", "tpcc", "-c", "config/sample_tpcc_config.xml", "--execute=true", "-s", "5", "-o", "outputfile"]


