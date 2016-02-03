#!/bin/bash

# modify the server config
sudo echo "listen_addresses = '*'" >> /var/lib/pgsql/9.2/data/postgresql.conf
sudo echo "max_wal_senders = 2" >> /var/lib/pgsql/9.2/data/postgresql.conf
sudo echo "wal_level = archive" >> /var/lib/pgsql/9.2/data/postgresql.conf

# modify the access config
sudo echo "# Custom configuration" >> /var/lib/pgsql/9.2/data/pg_hba.conf
sudo echo "host all all samenet md5" >> /var/lib/pgsql/9.2/data/pg_hba.conf
sudo echo "host replication all samenet trust" >> /var/lib/pgsql/9.2/data/pg_hba.conf
sudo service postgresql-9.2 restart

# add the delphix db user to the database
sudo -u postgres psql -U postgres -d postgres -c "CREATE USER delphix_u WITH LOGIN SUPERUSER PASSWORD 'delphix';"
sudo -u postgres psql -U postgres -d postgres -c "CREATE ROLE delphix_r SUPERUSER LOGIN REPLICATION PASSWORD 'delphix';"

# set a password on the postgres (db) user
sudo -u postgres psql -U postgres -d postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"

# set a password on the postgres (linux) user so we can su/remote login
echo postgres | passwd postgres --stdin