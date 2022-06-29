--------------------------------------
--# criar banco de dados
--------------------------------------

postgres createdb -o usuario name_database


database vai pertencer ao usuario que foi citado na criação



-----------------------
--# dropar o banco
-----------------------

DROP DATABASE DATABASE_NAME



--------------------------------------
--# criar banco de dados
--------------------------------------

--# SIMPLE
CREATE DATABASE TESTE;




--# SETAR NA CRIAÇÃO DO DATABASE
CREATE DATABASE TESTE
WITH
OWNER = XPTO
ENCODING = "UTF8"
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
TABLESPACE = PG_DEFAULT
CONNECTION LIMIT 500;


/* OBS: O USUÁRIO DEVE TER A PERMISSÃO CREATE_DB OR SUPER_USER */


---------------------
--# APAGAR O BANCO
---------------------


DROP DATABASE NAME_DATABASE;
