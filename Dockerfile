FROM registry.access.redhat.com/rhel7:latest

RUN yum -y --disablerepo=\* --enablerepo=rhel-7-server-rpms install yum-utils &&   yum-config-manager --disable \* &&   yum-config-manager --enable rhel-7-server-rpms &&   yum-config-manager --enable rhel-7-server-extras-rpms && yum clean all

RUN yum -y update && yum -y install http://mirror.nexcess.net/epel/7/x86_64/e/epel-release-7-5.noarch.rpm && yum clean all

# Debug only
#RUN yum -y install vim strace file less top

RUN yum -y install vim docker python-docker openscap-scanner tar python-cherrypy uwsgi-plugin-python uwsgi-router-http uwsgi-plugin-common python-psutil findutils python-flask && yum clean all


LABEL Version=1.0
LABEL Vendor="Red Hat" License=GPLv3


LABEL RUN="docker run --rm -it --privileged -v /proc/:/hostproc/ -v /sys/fs/cgroup:/sys/fs/cgroup  -v /var/log:/var/log -v /tmp:/tmp -v /run:/run -v /var/lib/docker/devicemapper/metadata/:/var/lib/docker/devicemapper/metadata/ -v /dev/:/dev/ --env container=docker --net=host --cap-add=SYS_ADMIN --ipc=host IMAGE"

ADD image_scanner.py /usr/bin/image-scanner
ADD rest.py /usr/bin/image-scanner-rest-server
RUN chmod a+x /usr/bin/image-scanner
RUN chmod a+x /usr/bin/image-scanner-rest-server

ADD docker_mount.py image_scanner.py image_scanner_client.py serv.py reporter.py dist_breakup.py applicationconfiguration.py scan.py /usr/lib/python2.7/site-packages/

RUN echo 'PS1="[image-scanner]#  "' > /etc/profile.d/ps1.sh

CMD /bin/bash
