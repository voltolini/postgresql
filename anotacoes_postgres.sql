------------------------
--# POSTGRES
------------------------



---------------------------------
--# instalação postgresql
---------------------------------

apt-get install postgresql postgresql-contrib


--# CONECTAR NA BASE COM O ROOT

sudo -u postgres psql postgres

# OR

su - postgres

psql postgres




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



------------------------------------------------------
--# definir uma senha para o usuário dentro do banco
------------------------------------------------------

\password postgres

digitar a senha desejada:

confirm:





------------------------------------------------
--# baixar o pacote adminpack dentro do banco
------------------------------------------------

CREATE EXTENSION adminpack;



------------------------------------------------
--# CRIAR UM USUÁRIO ESPECIFICO PARA O POSTGRES
------------------------------------------------


postgres createuser -D -A -P username

passwd



--------------------------------------
--# criar banco de dados
--------------------------------------

postgres createdb -o usuario name_database


database vai pertencer ao usuario que foi citado na criação



---------------------------------------------------------------------
--# habilitar conexões tcp/ip no banco por padrão vem desconectado
---------------------------------------------------------------------


vi /etc/postgresql/versao/main/postgresql.conf


localizar a linha listen addresses

descomentar a linha

listen_addresses = '*' /* para liberar o acesso a qualquer maquina na rede*/




-----------------------------------------------
--# reiniciar o serviço para pegar a alteração
-----------------------------------------------

service postgresql stop

service postgresql start

service postgresql restart





---------------------------------------------
--# instalar o  phpPgAdmin no linux debian
---------------------------------------------


-> Utilitário de administração via web, desenvolvido em php, para gerenciar o Postgres.


--# inicio

-> Verificar o ip da interface "eth0" por exemplo:

ifconfig

inet end.: ......

-> Este ip que será usado para testar o acesso ao phpPgAdmin


Obs: Este sistema está disponível nos repositórios padrões do debian.


--# instalar  o pacote

apt-get install apache2

apt-get install phppgadmin



---------------------------------------------------------------------------
--# apos a instalação, fazer a configuração em um dos arquivos do apache
---------------------------------------------------------------------------

vi /etc/apache2/conf.d/phppgadmin


-> procurar a linha "allow from"


# A linha allow from, deve ser comentada



# A linha allow from all deve ser descomentada


'--------------------------------------------------------------'

vi /etc/apache2/apache2.conf


-> incluir uma linha no arquivo


# Configuração do phpPgAdmin

Include /etc/apache2/conf.d/phppgadmin


'--------------------------------------------------------------'


-----------------------------------------------------------------
--# apos as alterações o serviço do apache, deve ser reiniciado
-----------------------------------------------------------------

service apache2 restart



'------------------------------
--# testar o acesso
------------------------------'

-> No navegador em outra máquina, testar com o ip que está na sua placa de rede


Address: http://ip/phppgadmin



-----------------------------
--# comandos basicos
-----------------------------


--# configurar senha

\password


--# verificar usuários no banco
\du


-> role no postgres é = usuário




-----------------------------------------------------------------------
--# realizar alteração para pedir senha ao tentar logar com o usuário
-----------------------------------------------------------------------


--# dentro do banco
psql


--# localizar o arquivo hba_file
show hba_file;


--# sair para o S.O e alterar o arquivo

Obs: arquivo de configuração para autenticação


sudo vi /etc/postgresql/11/main/pg_hba.conf

sessão: Databse administrative login by Unix domain socket

alterar o "method" para md5


--# reiniciar o postgres para pegar a alteração

sudo systemctl restart postgresql




'------------------------------------
--# criação e exclusão de usuários
------------------------------------'

--# criar usuário

createuser -dPs lucas


createuser --interactive lucas


--#verificar se o usuario foi criado
\du


--# configurar o acesso no arquivo de usuários


--# localizar o arquivo hba_file
show hba_file;


--# sair para o S.O e alterar o arquivo

Obs: arquivo de configuração para autenticação


sudo vi /etc/postgresql/11/main/pg_hba.conf

sessão: Database administrative login by Unix domain socket


#criar uma nova linha para o novo login

local   all     lucas    md5


--# reiniciar o postgres para pegar a alteração

sudo systemctl restart postgresql


--# acessar a base, sempre evidenciar a base
psql -U lucas postgres



--# apagar o usuário

dropuser lucas





--------------------------------------
--# Install pgAdmin4 in Linux Debian
--------------------------------------

Funciona em conjunto com o apache2



--# instalar os pacotes necessários
sudo apt install apache2 pgadmin4 pgadmin4-apache2


Irá aparecer uma tela para configuração.


"Configurando pgadmin4-apache2"

definir o usuário inicial


-> Iniciar o pgadmin







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





