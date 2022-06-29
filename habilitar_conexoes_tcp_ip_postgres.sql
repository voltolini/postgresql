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

service postgresql restart
