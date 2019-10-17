#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/01norecommend
echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01norecommend

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

apt-get install -y \
  ca-certificates \
  cmake \
  curl \
  gcc-multilib \
  git \
  golang-go \
  jq \
  less \
  libicu-dev \
  locales \
  make \
  sudo \
  vim

## Make sure we have a en_US.UTF-8 locale available
localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Install PostgreSQL common binaries and dependents
apt-get install -y \
  postgresql-common \
  postgresql-client-common \
  ssl-cert \
  sysstat \
  locales-all \
  libjson-perl \
  libjson-xs-perl
sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf

# Install PostgreSQL binaries and contrib
PGVERSION=10
apt-get install -y \
  postgresql-${PGVERSION} \
  postgresql-doc-${PGVERSION} \
  postgresql-client-${PGVERSION} \
  postgresql-contrib-${PGVERSION} \
  postgresql-server-dev-${PGVERSION} \
  postgresql-${PGVERSION}-hypopg \
  postgresql-${PGVERSION}-partman \
  postgresql-${PGVERSION}-pg-stat-kcache \
  postgresql-${PGVERSION}-pgextwlist \
  postgresql-${PGVERSION}-pgfincore \
  postgresql-${PGVERSION}-pgtap \
  postgresql-${PGVERSION}-repack \
  postgresql-${PGVERSION}-wal2json \
  pgbackrest

# Install etcd
ETCDVERSION=3.3.11
curl -sL https://github.com/coreos/etcd/releases/download/v${ETCDVERSION}/etcd-v${ETCDVERSION}-linux-amd64.tar.gz \
 | tar xz -C /bin --strip=1 --wildcards --no-anchored etcdctl etcd

# Install pip
apt-get install -y \
  python3 \
  python3-wheel \
  python3-pip \
  python3-psycopg2 \
  python3-setuptools \
  python3-etcd \
  python3-psutil \
  python3-requests \
  python3-yaml \
  python3-pygments \
  python3-cdiff \
  python3-idna \
  python3-certifi \
  python3-tz \
  python3-click \
  python3-prettytable \
  python3-tzlocal \
  python3-more-itertools \
  python3-py \
  python3-pluggy \
  python3-dateutil \
  postgresql-plpython3-${PGVERSION}

# Install patroni and pg_view
pip3 install \
  httpie \
  dumb-init \
  'git+https://github.com/zalando/patroni.git@master#egg=patroni[etcd]' \
  'git+https://github.com/zalando/pg_view.git@master#egg=pg-view'
pip3 install patroni[etcd]
pip3 install patroni[consul]
pip3 install patroni[zookeeper]
pip3 install patroni[kubernetes]

# clean up
rm -rf /var/lib/apt/lists/*

echo "export PATH=\$PATH:/usr/lib/postgresql/10/bin
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export EDITOR=vim" >> /etc/bash.bashrc
