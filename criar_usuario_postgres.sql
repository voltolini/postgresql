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
