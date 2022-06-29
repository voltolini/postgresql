--# QUANTIDADE DE PROCESSOS (SESSOES)
-------------------------------------
ps -ef | grep postgres | wc -l




--# QUANTIDADE DE PROCESSOS DE QUERIES PARALELAS
------------------------------------------------
ps -ef | grep postgres | grep parallel
