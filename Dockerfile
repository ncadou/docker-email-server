# Dockerfile for building an email server.
#

FROM ncadou/ansible
MAINTAINER Nicolas Cadou <ncadou@cadou.ca>

ENV DEBIAN_FRONTEND noninteractive

ENV RANDOMIZE_PASSWORD 0
ENV MAILNAME mailserver.local
ENV VMAIL_USER vmail
ENV VMAIL_UID 150
ENV VMAIL_GROUP mail
ENV VMAIL_GID 8
ENV VMAIL_DIR /var/vmail
ENV VIMBADMIN_SALT 123
ENV VIMBADMIN_VER 2.2.2
ENV VIMBADMIN_HOSTNAME localhost

RUN bash -c 'debconf-set-selections <<< "postfix postfix/mailname string $MAILNAME"'
RUN apt-get install -y bcrypt curl dovecot-imapd dovecot-managesieved dovecot-pop3d dovecot-sieve dovecot-sqlite git logrotate mail-server^ nginx openssh-server php5-cli php5-fpm php5-sqlite postfix postgrey pwgen rsyslog subversion && apt-get clean

ADD ansible /.ansible
RUN cd /.ansible; ansible-playbook -i hosts -c local setup-base.yml -e "mailname=$MAILNAME vmail_user=$VMAIL_USER vmail_uid=$VMAIL_UID vmail_group=$VMAIL_GROUP vmail_gid=$VMAIL_GID vmail_dir=$VMAIL_DIR vimbadmin_ver=$VIMBADMIN_VER vimbadmin_salt=$VIMBADMIN_SALT vimbadmin_hostname=$VIMBADMIN_HOSTNAME"

EXPOSE 22 80 110 143 993 995
VOLUME ["/var/vmail"]
CMD ["/start"]
