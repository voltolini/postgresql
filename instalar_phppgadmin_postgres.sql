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

