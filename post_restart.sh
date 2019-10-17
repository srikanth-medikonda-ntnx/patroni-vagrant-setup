apt-get update
cd /tmp; git clone https://github.com/okbob/plpgsql_check; cd plpgsql_check; make; make install
cd /tmp; git clone https://github.com/cybertec-postgresql/pg_squeeze; cd pg_squeeze; make; make install
cd /tmp; git clone https://github.com/cybertec-postgresql/pg_permission; cd pg_permission; make; make install
cd /var/lib/postgresql; etcd &> /tmp/etcd.out &
sudo -u postgres -H bash <<- 'EOF'
mkdir -p ~postgres/conf/ ~postgres/log/postgresql0/ ~postgres/log/postgresql1/ ~postgres/log/postgresql2/ ~postgres/scripts/ ~postgres/wal/ ~postgres/.config/patroni/
cp /vagrant/conf/postgresql*.yml ~postgres/conf/
[ ! -f ~postgres/.config/patroni/patronictl.yaml ] && ln -s ~postgres/conf/postgresql0.yml ~postgres/.config/patroni/patronictl.yaml
patroni ~postgres/conf/postgresql0.yml &> /tmp/postgresql0.out &
sleep 5
patroni ~postgres/conf/postgresql1.yml &> /tmp/postgresql1.out &
sleep 5
patroni ~postgres/conf/postgresql2.yml &> /tmp/postgresql2.out &
sleep 5
patronictl list
git clone https://gitlab.com/postgres-ai-team/postgres-checkup
psql --echo-all --host=127.0.0.1 --port=5432 --username=postgres --dbname=postgres <<SQL_EOF
BEGIN;
CREATE EXTENSION IF NOT EXISTS btree_gin;
CREATE EXTENSION IF NOT EXISTS btree_gist;
CREATE EXTENSION IF NOT EXISTS file_fdw;
CREATE EXTENSION IF NOT EXISTS hypopg;
CREATE EXTENSION IF NOT EXISTS pageinspect;
CREATE EXTENSION IF NOT EXISTS pg_buffercache;
CREATE EXTENSION IF NOT EXISTS pg_partman;
CREATE EXTENSION IF NOT EXISTS pg_permissions;
CREATE EXTENSION IF NOT EXISTS pg_repack;
CREATE EXTENSION IF NOT EXISTS pg_squeeze;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_stat_kcache;
CREATE EXTENSION IF NOT EXISTS pgfincore;
CREATE EXTENSION IF NOT EXISTS pgrowlocks;
CREATE EXTENSION IF NOT EXISTS pgstattuple;
CREATE EXTENSION IF NOT EXISTS pgtap;
CREATE EXTENSION IF NOT EXISTS plpgsql_check;
CREATE EXTENSION IF NOT EXISTS plpython3u;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
END;
SQL_EOF
EOF
