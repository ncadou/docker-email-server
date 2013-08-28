# Dockerfile for building an email server.
#

FROM ncadou/ansible
MAINTAINER Nicolas Cadou <ncadou@cadou.ca>

ENV DEBIAN_FRONTEND noninteractive

ENV RANDOMIZE_PASSWORD 0
ENV VMAIL_USER vmail
ENV VMAIL_UID 150
ENV VMAIL_GROUP mail
ENV VMAIL_GID 8
ENV VMAIL_DIR /var/vmail

RUN apt-get install -y bcrypt dovecot-imapd dovecot-managesieved dovecot-pop3d dovecot-sieve dovecot-sqlite logrotate mail-server^ openssh-server postfix postgrey && apt-get clean

RUN mkdir /var/run/sshd

RUN apt-get install -y curl git subversion nginx php5-cli php5-fpm php5-sqlite && apt-get clean

ENV VIMBADMIN_VER 2.2.2

ADD ansible /.ansible

RUN cd /.ansible; ansible-playbook -i hosts -c local setup-base.yml -e "vmail_user=$VMAIL_USER" -e "vmail_uid=$VMAIL_UID" -e "vmail_group=$VMAIL_GROUP" -e "vmail_gid=$VMAIL_GID" -e "vmail_dir=$VMAIL_DIR" -e "vimbadmin_ver=$VIMBADMIN_VER"

EXPOSE 22 80
