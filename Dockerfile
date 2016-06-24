FROM ubuntu:14.04

RUN apt-get update
RUN apt-get -y install openssh-server
RUN sed "s/\/usr\/lib\/openssh\/sftp-server/internal-sftp/g" -i /etc/ssh/sshd_config
RUN echo "Match Group sftp-users" >> /etc/ssh/sshd_config
RUN echo "    ChrootDirectory /sftp/%u" >> /etc/ssh/sshd_config
RUN echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config >> /etc/ssh/sshd_config

RUN addgroup sftp-users
RUN adduser --disabled-password --gecos "" sftp-user
RUN adduser sftp-user root
RUN adduser sftp-user sftp-users
RUN mkdir -p /sftp/sftp-user

RUN mkdir /var/run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
VOLUME /sftp/sftp-user/data

CMD ["/usr/sbin/sshd", "-D"]
