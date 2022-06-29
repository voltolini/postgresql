-------------------------------------
--# Criar usuario luzadm no postgres
-------------------------------------

CREATE DATABASE luzadm;
CREATE ROLE luzadm WITH ENCRYPTED PASSWORD 'energ.a';
ALTER ROLE luzadm WITH SUPERUSER;
ALTER ROLE luzadm WITH CREATEROLE;
ALTER ROLE luzadm WITH CREATEDB;
ALTER ROLE luzadm WITH LOGIN;
CREATE ROLE luzadmm LOGIN PASSWORD 'energ.a';
GRANT CONNECT ON DATABASE luzadm TO luzadmm;
CREATE ROLE luzadmg;
GRANT CONNECT ON DATABASE luzadm TO luzadmg;
GRANT LUZADMG TO luzadm;
GRANT LUZADMG TO luzadmm;
