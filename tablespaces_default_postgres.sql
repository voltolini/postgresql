--# Para localizar as tablespaces padrões do banco de dados segue as queries;

postgres=# SHOW data_directory;

    data_directory
-----------------------
 /usr/LOCAL/pgsql/DATA
(1 ROW)


postgres=# SELECT setting||'/base' FROM pg_settings WHERE name='data_directory';

          ?COLUMN?
----------------------------
 /usr/LOCAL/pgsql/DATA/base
(1 ROW)


postgres=#  SELECT setting||'/global' FROM pg_settings WHERE name='data_directory';

           ?COLUMN?
------------------------------
 /usr/LOCAL/pgsql/DATA/global
(1 ROW)

