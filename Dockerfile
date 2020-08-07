FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]


RUN yum -y install httpd; yum clean all; systemctl enable httpd.service
EXPOSE 80

RUN yum -y install epel-release; yum -y install http://software.internet2.edu/rpms/el7/x86_64/latest/packages/perfSONAR-repo-0.9-1.noarch.rpm; yum -y clean all
RUN yum -y install perfsonar-centralmanagement; yum -y install perfsonar-toolkit; yum clean all;

ADD maddash.yaml /etc/maddash/maddash-server/
## ADD su /etc/pam.d/
ADD esmondAPI /home/esmondAPI

CMD ["/usr/sbin/init"]