FROM centos
MAINTAINER OAI Application


# Add user oai
RUN useradd -d /home/oai -m oai

# Add bootstrap and application requirements
ADD ./bootstrap.sh /tmp/bootstrap.sh
ADD ./requirements.sh /tmp/requirements.sh

WORKDIR /tmp

# Install system dependencies
RUN bash bootstrap.sh -i && bash requirements.sh

# Add application sources
ADD . /home/oai/src

# Change permissions for user phoenix
RUN chown -R oai /home/oai/src

# cd into application
WORKDIR /home/oai/src

# Remaining tasks run as user phoenix
USER oai

# Update makefile and run install
RUN bash bootstrap.sh -u && make clean install 

# cd into conda environment
WORKDIR /home/oai/.conda/envs/oai

# all currently used ports in birdhouse
#EXPOSE 8080 8081 8082 8090 8091 8092 8093 8094 9001

#CMD ["bin/supervisord", "-n", "-c", "etc/supervisor/supervisord.conf"]
