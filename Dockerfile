# Dockerfile for building an email server.
#

FROM ncadou/ansible
MAINTAINER Nicolas Cadou <ncadou@cadou.ca>

ENV VMAIL_USER vmail
ENV VMAIL_UID 150
ENV VMAIL_GROUP mail
ENV VMAIL_GID 8
ENV VMAIL_DIR /var/vmail

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y bcrypt dovecot-imapd dovecot-managesieved dovecot-pop3d dovecot-sieve dovecot-sqlite htop logrotate mail-server^ moreutils openssh-server postfix postgrey tree && apt-get clean

RUN mkdir /var/run/sshd
RUN echo root:root | chpasswd

ADD ansible /.ansible

RUN env
RUN cd /.ansible; ansible-playbook -i hosts -c local setup-base.yml -e "vmail_user=$VMAIL_USER" -e "vmail_uid=$VMAIL_UID" -e "vmail_group=$VMAIL_GROUP" -e "vmail_gid=$VMAIL_GID" -e "vmail_dir=$VMAIL_DIR"

EXPOSE 22
