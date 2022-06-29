'------------------------------------------------
--# instalação POSTGRESQL 11 no Linux Debian 10
-------------------------------------------------'

postgresql.org


sudo vi /etc/apt/sources.list.d/pgdg.list


deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main

save


#importar a chave de assinatura:

sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

deverá voltar "OK"

sudo apt update


sudo apt install postgresql -11


--# testar acesso

sudo -i -u postgres


--# conectar na base
psql


--# informações da conexão
\conninfo


--# bancos de dados disponíveis
\l


--# versão do PostgreSQL
psql --version
