#!/usr/bin/env sh
cd /.ansible
ansible-playbook -i hosts -c local setup-base.yml -e "mailname=$MAILNAME vmail_user=$VMAIL_USER vmail_uid=$VMAIL_UID vmail_group=$VMAIL_GROUP vmail_gid=$VMAIL_GID vmail_dir=$VMAIL_DIR vimbadmin_ver=$VIMBADMIN_VER vimbadmin_salt=$VIMBADMIN_SALT vimbadmin_hostname=$VIMBADMIN_HOSTNAME"
