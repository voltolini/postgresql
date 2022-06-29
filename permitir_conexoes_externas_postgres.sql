--------------------------------------------
--# Permitir conexões externas no postgres
--------------------------------------------


--# Editar o arquivo
vi /etc/postgres/13/main/postgresql.conf



Descomentar a linha "listen_addresses"

Novo valor listen_addresses='*'



--# Quais IPs irão acessar
vi /etc/postgres/13/main/pg_hba.conf


-> Example:

local  database      user     method    [options]
host   base          usuario  address    method


host    all     luzadm        192.168.88.180/24     md5
