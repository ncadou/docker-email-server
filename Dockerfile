# Dockerfile for building an email server.
#

FROM ncadou/ansible
MAINTAINER Nicolas Cadou <ncadou@cadou.ca>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y bcrypt curl dovecot-imapd dovecot-managesieved dovecot-pop3d dovecot-sieve dovecot-sqlite git logrotate mail-server^ nginx openssh-server php5-cli php5-fpm php5-sqlite postfix postgrey pwgen subversion && apt-get clean

# The SSH init that we'll not be using would've created that directory.
RUN mkdir -p -m0755 /var/run/sshd

RUN apt-get install -y htop less moreutils tree && apt-get clean

ENV RANDOMIZE_PASSWORD 0
ENV VMAIL_USER vmail
ENV VMAIL_UID 150
ENV VMAIL_GROUP mail
ENV VMAIL_GID 8
ENV VMAIL_DIR /var/vmail
ENV VIMBADMIN_SALT 123
ENV VIMBADMIN_VER 2.2.2
ENV VIMBADMIN_HOSTNAME localhost

ADD ansible /.ansible

RUN cd /.ansible; ansible-playbook -i hosts -c local setup-base.yml -e "vmail_user=$VMAIL_USER vmail_uid=$VMAIL_UID vmail_group=$VMAIL_GROUP vmail_gid=$VMAIL_GID vmail_dir=$VMAIL_DIR vimbadmin_ver=$VIMBADMIN_VER vimbadmin_salt=$VIMBADMIN_SALT vimbadmin_hostname=$VIMBADMIN_HOSTNAME"

EXPOSE 22 80
VOLUME ["/var/vmail"]
CMD ["/start"]
